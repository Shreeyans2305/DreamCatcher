import '../../core/localization/opportunity_translator.dart';

class RuleEvaluationItem {
  final String rule;
  final String ruleType;
  final String operator;
  final String expectedValue;
  final dynamic studentValue;
  final bool required;
  final bool passed;
  final String? description;

  RuleEvaluationItem({
    required this.rule,
    required this.ruleType,
    required this.operator,
    required this.expectedValue,
    this.studentValue,
    required this.required,
    required this.passed,
    this.description,
  });

  String get plainLanguageDescription {
    if (description != null && description!.isNotEmpty) {
      return description!;
    }
    // Fallback plain language formatting
    switch (ruleType) {
      case 'INCOME':
        return 'Annual family income must be under ₹$expectedValue';
      case 'GENDER':
        return 'Eligible for: $expectedValue';
      case 'STATE':
        return 'Resident of $expectedValue';
      case 'EDUCATION_LEVEL':
        return 'Education level: $expectedValue';
      case 'PERCENTAGE':
        return 'Minimum academic score of $expectedValue%';
      case 'RURAL_STATUS':
        return 'Location requirement: $expectedValue background';
      case 'AGE':
        return 'Age requirement: $operator $expectedValue years';
      default:
        return '$ruleType must be $expectedValue';
    }
  }

  String getLocalizedDescription(String langCode) {
    return OpportunityTranslator.getRuleDescription(
      ruleType: ruleType,
      operator: operator,
      value: expectedValue,
      fallbackDesc: plainLanguageDescription,
      langCode: langCode,
    );
  }

  factory RuleEvaluationItem.fromJson(Map<String, dynamic> json) {
    return RuleEvaluationItem(
      rule: json['rule'] as String? ?? '',
      ruleType: json['rule_type'] as String? ?? 'CRITERIA',
      operator: json['operator'] as String? ?? 'EQ',
      expectedValue: json['expected_value']?.toString() ?? '',
      studentValue: json['student_value'],
      required: json['required'] as bool? ?? true,
      passed: json['passed'] as bool? ?? false,
      description: json['description'] as String?,
    );
  }
}

class EligibilityCheckResult {
  final String opportunityId;
  final String opportunityTitle;
  final bool isEligible;
  final int passedRulesCount;
  final int totalRulesCount;
  final List<RuleEvaluationItem> ruleEvaluations;

  EligibilityCheckResult({
    required this.opportunityId,
    required this.opportunityTitle,
    required this.isEligible,
    required this.passedRulesCount,
    required this.totalRulesCount,
    required this.ruleEvaluations,
  });

  factory EligibilityCheckResult.fromJson(Map<String, dynamic> json) {
    return EligibilityCheckResult(
      opportunityId: json['opportunity_id'] as String,
      opportunityTitle: json['opportunity_title'] as String? ?? '',
      isEligible: json['is_eligible'] as bool? ?? false,
      passedRulesCount: json['passed_rules_count'] as int? ?? 0,
      totalRulesCount: json['total_rules_count'] as int? ?? 0,
      ruleEvaluations: (json['rule_evaluations'] as List<dynamic>?)
              ?.map((e) => RuleEvaluationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
