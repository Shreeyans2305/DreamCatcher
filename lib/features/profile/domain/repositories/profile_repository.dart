import '../models/student_profile.dart';

/// Abstract repository interface for student profile management.
abstract class ProfileRepository {
  Future<StudentProfile> getProfile(String studentId);
  Future<void> updateProfile(StudentProfile profile);
}
