import 'dart:math';
import '../../../../core/network/api_exception.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_token_storage.dart';

/// Mock implementation of AuthRepository with artificial delay (300-1200ms)
/// to simulate realistic rural Indian network conditions, backed by secure session storage.
class MockAuthRepository implements AuthRepository {
  final AuthTokenStorage _tokenStorage;
  final Random _random = Random();

  MockAuthRepository({AuthTokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? SecureAuthTokenStorage();

  Future<void> _simulateDelay() async {
    final int delayMs = 300 + _random.nextInt(700); // 300ms to 1000ms
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    await _simulateDelay();
    // Check cached session in secure storage first (offline support)
    final cached = await _tokenStorage.getCachedUser();
    if (cached != null) {
      return cached;
    }

    final hasToken = await _tokenStorage.hasValidSession();
    if (hasToken) {
      const defaultUser = AuthUser(
        id: 'usr_rural_001',
        phoneNumber: '+919876543210',
        displayName: 'Priya Sharma',
        token: 'mock_jwt_secure_token_dc_001',
        authProvider: 'otp',
        isProfileComplete: true,
      );
      await _tokenStorage.saveUser(defaultUser);
      return defaultUser;
    }

    return null;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    await _simulateDelay();

    // Mock Google sign-in returns a newly authenticated user with incomplete profile
    // to route to onboarding per requirement.
    const googleUser = AuthUser(
      id: 'usr_google_001',
      email: 'student.dreamcatcher@gmail.com',
      phoneNumber: '',
      displayName: 'Aarav Patel',
      token: 'mock_jwt_google_secure_dc_002',
      authProvider: 'google',
      isProfileComplete: false,
    );

    await _tokenStorage.saveUser(googleUser);
    return googleUser;
  }

  @override
  Future<void> requestOtp(String identifier) async {
    await _simulateDelay();
    // Simulate sending 6-digit OTP to identifier (mobile or email)
  }

  @override
  Future<AuthUser> signInWithOtp(String identifier, String otp) async {
    await _simulateDelay();

    // Verify mock code: any code '123456' succeeds
    if (otp.trim() != '123456') {
      throw const ServerException(
        message: 'Invalid security code. Please enter 123456.',
        statusCode: 401,
      );
    }

    final isPhone = !identifier.contains('@');
    final user = AuthUser(
      id: 'usr_otp_001',
      phoneNumber: isPhone ? identifier : '',
      email: isPhone ? '' : identifier,
      displayName: 'Priya Sharma',
      token: 'mock_jwt_secure_token_dc_001',
      authProvider: 'otp',
      isProfileComplete: true,
    );

    await _tokenStorage.saveUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    await _simulateDelay();
    await _tokenStorage.clear();
  }

  @override
  Future<bool> hasCachedSession() async {
    return await _tokenStorage.hasValidSession();
  }
}
