import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/auth_token_storage.dart';
import '../../data/repositories/http_auth_repository.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../../data/repositories/mock_gov_id_repository.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/models/gov_id_verification_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/gov_id_repository.dart';

/// Active TokenStorage provider (swappable for in-memory during tests)
final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return SecureAuthTokenStorage();
});

/// Provides the active AuthRepository (Mock vs Real selected via config flag)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final useMock = ref.watch(useMockRepositoriesProvider);
  final tokenStorage = ref.watch(authTokenStorageProvider);

  if (useMock) {
    return MockAuthRepository(tokenStorage: tokenStorage);
  }
  final dioClient = ref.watch(dioClientProvider);
  return HttpAuthRepository(dioClient: dioClient, tokenStorage: tokenStorage);
});

/// Provides the active GovIdRepository (Mock vs Real selected via config flag)
final govIdRepositoryProvider = Provider<GovIdRepository>((ref) {
  final tokenStorage = ref.watch(authTokenStorageProvider);
  return MockGovIdRepository(tokenStorage: tokenStorage);
});

/// State representation for authentication flows.
class AuthState {
  final AuthUser? user;
  final bool isLoading;
  final bool isOffline;
  final String? errorMessage;
  final GovIdVerificationResult? govIdResult;
  final String? pendingIdentifier;
  final bool otpSent;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isOffline = false,
    this.errorMessage,
    this.govIdResult,
    this.pendingIdentifier,
    this.otpSent = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AuthUser? user,
    bool? isLoading,
    bool? isOffline,
    String? errorMessage,
    bool clearError = false,
    GovIdVerificationResult? govIdResult,
    String? pendingIdentifier,
    bool? otpSent,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      isOffline: isOffline ?? this.isOffline,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      govIdResult: govIdResult ?? this.govIdResult,
      pendingIdentifier: pendingIdentifier ?? this.pendingIdentifier,
      otpSent: otpSent ?? this.otpSent,
    );
  }
}

/// State notifier managing authentication, session checking, OTP flows, and Government ID.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final GovIdRepository govIdRepository;
  final Ref ref;

  AuthNotifier({
    required this.authRepository,
    required this.govIdRepository,
    required this.ref,
  }) : super(const AuthState());

  /// Checks initial session from secure storage.
  /// If device is offline but has a cached session, restores user in read-only mode.
  Future<AuthUser?> checkInitialSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final simState = ref.read(networkSimulatorProvider);
    final isOffline = simState.simulateFailure;

    try {
      final user = await authRepository.getCurrentUser();
      state = state.copyWith(
        user: user,
        isLoading: false,
        isOffline: isOffline,
      );
      return user;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isOffline: isOffline,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Initiates Google Sign-In flow.
  Future<AuthUser?> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await authRepository.signInWithGoogle();
      state = state.copyWith(user: user, isLoading: false);
      return user;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Requests 6-digit OTP to be sent via SMS / Email.
  Future<bool> requestOtp(String identifier) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await authRepository.requestOtp(identifier);
      state = state.copyWith(
        isLoading: false,
        pendingIdentifier: identifier,
        otpSent: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Verifies 6-digit OTP code against repository (any code '123456' succeeds in mock).
  Future<AuthUser?> signInWithOtp(String identifier, String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await authRepository.signInWithOtp(identifier, otp);
      state = state.copyWith(
        user: user,
        isLoading: false,
        otpSent: false,
      );
      return user;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Verifies Government ID (e.g. Aadhaar) with student consent.
  Future<GovIdVerificationResult> verifyGovId({
    required String idNumber,
    required bool consentGiven,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await govIdRepository.verifyGovId(
        idNumber: idNumber,
        consentGiven: consentGiven,
      );

      if (result.isSuccess) {
        // Authenticate student session with verified Gov ID
        final verifiedUser = AuthUser(
          id: 'usr_govid_${DateTime.now().millisecondsSinceEpoch}',
          displayName: result.studentName ?? 'Verified Student',
          token: result.token ?? 'mock_gov_id_token',
          authProvider: 'gov_id',
          isProfileComplete: false,
        );
        state = state.copyWith(
          user: verifiedUser,
          isLoading: false,
          govIdResult: result,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.message,
          govIdResult: result,
        );
      }

      return result;
    } catch (e) {
      final failResult = GovIdVerificationResult(
        isSuccess: false,
        message: e.toString(),
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        govIdResult: failResult,
      );
      return failResult;
    }
  }

  /// Resets pending OTP flow state.
  void resetOtpFlow() {
    state = state.copyWith(
      otpSent: false,
      pendingIdentifier: null,
      clearError: true,
    );
  }

  /// Clears any transient error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Signs out student session.
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await authRepository.signOut();
    state = const AuthState();
  }
}

/// Global authentication state provider.
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final govIdRepo = ref.watch(govIdRepositoryProvider);
  return AuthNotifier(
    authRepository: authRepo,
    govIdRepository: govIdRepo,
    ref: ref,
  );
});
