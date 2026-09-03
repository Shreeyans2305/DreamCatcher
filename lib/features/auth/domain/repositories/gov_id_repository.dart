import '../models/gov_id_verification_result.dart';

/// Abstract repository interface for Government ID (e.g. Aadhaar/DigiLocker) operations.
/// Designed for clean swap-in of production verification services without UI modifications.
abstract class GovIdRepository {
  /// Verifies a student government ID number with explicit student consent.
  /// Implementations must NEVER log raw government IDs.
  Future<GovIdVerificationResult> verifyGovId({
    required String idNumber,
    required bool consentGiven,
  });

  /// Check whether a verified Gov ID token exists.
  Future<bool> hasStoredGovId();
}
