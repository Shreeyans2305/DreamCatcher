import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamcatcher/core/widgets/student_avatar.dart';
import 'package:dreamcatcher/data/models/student.dart';

void main() {
  group('StudentAvatar & Completeness Tests', () {
    testWidgets('StudentAvatar displays correct initials fallback and edit badge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StudentAvatar(
              name: 'Sunil Murmu',
              size: 64,
              showEditBadge: true,
            ),
          ),
        ),
      );

      expect(find.text('SM'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
    });

    testWidgets('StudentAvatar decodes base64 data URI image', (tester) async {
      // 1x1 transparent PNG in base64
      const transparentPngBase64 =
          'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StudentAvatar(
              avatarUrl: transparentPngBase64,
              name: 'Sunil Murmu',
              size: 64,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    test('StudentProfile identifies missing steps and completed steps', () {
      final incompleteStudent = StudentProfile(
        id: 'std-inc',
        name: 'Sunil Murmu',
        phone: '9876543210',
        preferredLanguage: 'hi',
      );

      expect(incompleteStudent.missingSteps.isNotEmpty, isTrue);
      // Missing items should include education, skills, interests, aspirations, avatar
      final missingStepIds = incompleteStudent.missingSteps.map((s) => s.id).toList();
      expect(missingStepIds.contains(CompletenessStepId.education), isTrue);
      expect(missingStepIds.contains(CompletenessStepId.skills), isTrue);
      expect(missingStepIds.contains(CompletenessStepId.avatar), isTrue);
      expect(missingStepIds.contains(CompletenessStepId.interests), isTrue);
      expect(missingStepIds.contains(CompletenessStepId.aspirations), isTrue);

      // Phone is provided, so it should be in completed steps
      final completedStepIds = incompleteStudent.completedSteps.map((s) => s.id).toList();
      expect(completedStepIds.contains(CompletenessStepId.phone), isTrue);
    });

    test('StudentProfile calculates effective completeness accurately with sub-records', () {
      final minimalStudent = StudentProfile(
        id: 'std-min',
        name: 'Sunil Murmu',
        phone: '9876543210',
        preferredLanguage: 'hi',
      );
      // Min completeness fallback
      expect(minimalStudent.effectiveCompleteness, greaterThanOrEqualTo(0.1));

      final richStudent = StudentProfile(
        id: 'std-rich',
        name: 'Sunil Murmu',
        phone: '9876543210',
        gender: 'male',
        dateOfBirth: '2005-04-12',
        preferredLanguage: 'hi',
        avatarUrl: 'https://example.com/avatar.jpg',
        educationRecords: [
          StudentEducation(
            id: 'edu-1',
            educationLevel: 'higher_secondary',
            institutionName: 'Govt Higher Secondary School',
            fieldOfStudy: 'Science',
          )
        ],
        skills: [
          StudentSkill(
            id: 'sk-1',
            skillId: 'sk-item-1',
            proficiency: 'intermediate',
          )
        ],
        interests: [
          StudentInterest(
            id: 'in-1',
            interestId: 'in-item-1',
            strength: 0.9,
          )
        ],
        aspirations: [
          StudentAspiration(
            id: 'asp-1',
            aspirationText: 'Become a software engineer',
          )
        ],
      );

      expect(richStudent.completenessPercentage, greaterThanOrEqualTo(80));
    });
  });

  group('Chat Markdown Text Rendering Tests', () {
    testWidgets('MarkdownBody interprets **bold** and *italic* properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MarkdownBody(
              data: 'Hello **Sunil**, here are your *recommended* schemes:\n\n* **NSP Post-Matric**: Full fee waiver\n* **PM-YASASVI**: Merit award',
            ),
          ),
        ),
      );

      // Verify that markdown parsed properly without throwing
      expect(find.byType(MarkdownBody), findsOneWidget);
      // Raw asterisks shouldn't appear as lone text if parsed as markdown elements
      expect(find.text('**Sunil**'), findsNothing);
    });
  });
}
