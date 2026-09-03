/// Represents the result of a Government ID verification.
/// Raw government IDs are never persisted or exposed in toString.
class GovIdVerificationResult {
  final bool isSuccess;
  final String? token;
  final String? maskedIdNumber;
  final String? studentName;
  final String? message;

  const GovIdVerificationResult({
    required this.isSuccess,
    this.token,
    this.maskedIdNumber,
    this.studentName,
    this.message,
  });

  @override
  String toString() =>
      'GovIdVerificationResult(isSuccess: $isSuccess, maskedId: $maskedIdNumber, studentName: $studentName)';
}
