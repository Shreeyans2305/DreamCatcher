import '../models/auth_user.dart';

/// Abstract repository interface for authentication operations.
abstract class AuthRepository {
  /// Check current user session (supports offline cached session retrieval).
  Future<AuthUser?> getCurrentUser();

  /// Google Sign-In entry path.
  Future<AuthUser> signInWithGoogle();

  /// Request a 6-digit OTP code to mobile number or email.
  Future<void> requestOtp(String identifier);

  /// Authenticate using 6-digit OTP code.
  Future<AuthUser> signInWithOtp(String identifier, String otp);

  /// Signs out and clears stored session tokens.
  Future<void> signOut();

  /// Check whether a cached session exists in secure storage.
  Future<bool> hasCachedSession();
}
