import 'package:flutter_test/flutter_test.dart';
import 'package:dreamcatcher/data/models/eligibility.dart';
import 'package:dreamcatcher/data/models/opportunity.dart';
import 'package:dreamcatcher/data/models/reference.dart';
import 'package:dreamcatcher/data/models/student.dart';

void main() {
  group('Model Serialization & Logic Tests', () {
    test('Language parsing works', () {
      final json = {
        'code': 'hi',
        'name': 'Hindi',
        'native_name': 'हिन्दी',
        'script': 'Devanagari',
        'is_active': true,
      };
      final lang = Language.fromJson(json);
      expect(lang.code, 'hi');
      expect(lang.nativeName, 'हिन्दी');
    });

    test('LocationItem displayName formats hierarchical village and district', () {
      final loc = LocationItem(
        id: 'loc-1',
        country: 'India',
        state: 'Maharashtra',
        district: 'Pune',
        village: 'Khed',
      );
      expect(loc.displayName, 'Khed, Pune, Maharashtra');
    });

    test('EligibilityCheckResult and RuleEvaluation plain language fallback', () {
      final json = {
        'opportunity_id': 'opp-1',
        'opportunity_title': 'National Rural Tech Grant',
        'is_eligible': true,
        'passed_rules_count': 2,
        'total_rules_count': 2,
        'rule_evaluations': [
          {
            'rule': 'INCOME LTE 250000',
            'rule_type': 'INCOME',
            'operator': 'LTE',
            'expected_value': '250000',
            'student_value': 180000,
            'required': true,
            'passed': true,
            'description': 'Annual family income must be under ₹2,50,000.',
          },
          {
            'rule': 'GENDER EQ female',
            'rule_type': 'GENDER',
            'operator': 'EQ',
            'expected_value': 'female',
            'student_value': 'female',
            'required': true,
            'passed': true,
            'description': null,
          }
        ]
      };

      final result = EligibilityCheckResult.fromJson(json);
      expect(result.isEligible, isTrue);
      expect(result.passedRulesCount, 2);
      expect(result.ruleEvaluations.length, 2);
      expect(result.ruleEvaluations.first.plainLanguageDescription,
          'Annual family income must be under ₹2,50,000.');
      expect(result.ruleEvaluations.last.plainLanguageDescription,
          'Eligible for: female');
    });

    test('Opportunity typeLabel and benefit calculation', () {
      final scholarshipJson = {
        'id': 'opp-10',
        'type': 'scholarship',
        'title': 'Pre-Matric Minority Scholarship',
        'scholarship': {
          'amount': 25000.0,
          'recurrence': 'per year',
        }
      };
      final opp = Opportunity.fromJson(scholarshipJson);
      expect(opp.typeLabel, 'Scholarship');
      expect(opp.highlightBenefit, '₹25000 per year');
    });

    test('StudentProfile completeness percentage getter', () {
      final student = StudentProfile(
        id: 'std-1',
        name: 'Aarav Sharma',
        profileCompleteness: 0.75,
      );
      expect(student.completenessPercentage, 75);
      expect(student.copyWith(avatarUrl: 'base64-photo', profileCompleteness: 0.80).completenessPercentage, 80);
      expect(student.copyWith(avatarUrl: 'base64-photo').avatarUrl, 'base64-photo');
    });

    test('StudentProfile avatar can complete a stale 95% server score', () {
      final student = StudentProfile(
        id: 'std-2',
        name: 'Aarav Sharma',
        phone: '9876543210',
        email: 'aarav@example.com',
        dateOfBirth: '2005-01-01',
        gender: 'male',
        locationId: 'loc-1',
        avatarUrl: 'base64-photo',
        profileCompleteness: 0.95,
        educationRecords: [
          StudentEducation(
            id: 'edu-1',
            educationLevel: 'secondary',
            status: 'completed',
          ),
        ],
        skills: [
          StudentSkill(id: 'skill-1', skillId: 'skill-1'),
        ],
        interests: [
          StudentInterest(id: 'interest-1', interestId: 'interest-1'),
        ],
        aspirations: [
          StudentAspiration(id: 'aspiration-1', aspirationText: 'Engineer'),
        ],
      );

      expect(student.completenessPercentage, 100);
    });
  });
}
