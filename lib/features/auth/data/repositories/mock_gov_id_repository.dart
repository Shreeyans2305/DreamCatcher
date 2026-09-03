import 'dart:math';
import '../../domain/models/gov_id_verification_result.dart';
import '../../domain/repositories/gov_id_repository.dart';
import '../datasources/auth_token_storage.dart';

/// Mock implementation of GovIdRepository simulating Aadhaar/DigiLocker verification.
/// Validates 12-digit format, simulates network latency, and ensures sensitive raw IDs
/// are never logged or stored unencrypted.
class MockGovIdRepository implements GovIdRepository {
  final AuthTokenStorage _tokenStorage;
  final Random _random = Random();
  bool _hasStoredVerification = false;

  MockGovIdRepository({AuthTokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? SecureAuthTokenStorage();

  Future<void> _simulateDelay() async {
    final int delayMs = 400 + _random.nextInt(600); // 400-1000ms
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  Future<GovIdVerificationResult> verifyGovId({
    required String idNumber,
    required bool consentGiven,
  }) async {
    await _simulateDelay();

    if (!consentGiven) {
      return const GovIdVerificationResult(
        isSuccess: false,
        message: 'Student consent is required before verifying identification.',
      );
    }

    final sanitizedId = idNumber.replaceAll(RegExp(r'\s+|-'), '');

    // Validate 12 digits (standard Aadhaar format)
    if (!RegExp(r'^\d{12}$').hasMatch(sanitizedId)) {
      return const GovIdVerificationResult(
        isSuccess: false,
        message: 'Identification number must be exactly 12 digits.',
      );
    }

    // Mask ID to keep last 4 digits only (e.g., XXXX-XXXX-1234)
    final masked = 'XXXX-XXXX-${sanitizedId.substring(8)}';
    const mockGovToken = 'mock_gov_id_secure_jwt_token_999';

    // Store token securely
    await _tokenStorage.saveToken(mockGovToken);
    _hasStoredVerification = true;

    return GovIdVerificationResult(
      isSuccess: true,
      token: mockGovToken,
      maskedIdNumber: masked,
      studentName: 'Aadhaar Verified Student',
      message: 'Identification verified successfully.',
    );
  }

  @override
  Future<bool> hasStoredGovId() async {
    return _hasStoredVerification;
  }
}
