import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_token_storage.dart';

/// Production implementation of AuthRepository.
/// Integrates with GoogleSignIn plugin and backend REST endpoints via DioClient.
class HttpAuthRepository implements AuthRepository {
  final DioClient dioClient;
  final AuthTokenStorage _tokenStorage;
  final GoogleSignIn _googleSignIn;

  HttpAuthRepository({
    required this.dioClient,
    AuthTokenStorage? tokenStorage,
    GoogleSignIn? googleSignIn,
  })  : _tokenStorage = tokenStorage ?? SecureAuthTokenStorage(),
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email', 'profile'],
            );

  @override
  Future<AuthUser?> getCurrentUser() async {
    final cached = await _tokenStorage.getCachedUser();
    if (cached != null) return cached;

    final token = await _tokenStorage.getToken();
    if (token == null) return null;

    final response = await dioClient.dio.get('/auth/me');
    final user = AuthUser.fromJson(response.data as Map<String, dynamic>);
    await _tokenStorage.saveUser(user);
    return user;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign in was cancelled');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;

    final response = await dioClient.dio.post(
      '/auth/google',
      data: {'idToken': idToken},
    );

    final user = AuthUser.fromJson(response.data as Map<String, dynamic>);
    await _tokenStorage.saveUser(user);
    return user;
  }

  @override
  Future<void> requestOtp(String identifier) async {
    await dioClient.dio.post(
      '/auth/request-otp',
      data: {'identifier': identifier},
    );
  }

  @override
  Future<AuthUser> signInWithOtp(String identifier, String otp) async {
    final response = await dioClient.dio.post(
      '/auth/verify-otp',
      data: {
        'identifier': identifier,
        'otp': otp,
      },
    );

    final user = AuthUser.fromJson(response.data as Map<String, dynamic>);
    await _tokenStorage.saveUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _tokenStorage.clear();
  }

  @override
  Future<bool> hasCachedSession() async {
    return await _tokenStorage.hasValidSession();
  }
}
