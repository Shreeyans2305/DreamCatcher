// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DreamCatcher';

  @override
  String get tagline => 'Discover your future, step by step';

  @override
  String get navDashboard => 'Home';

  @override
  String get navOpportunities => 'Opportunities';

  @override
  String get navChat => 'Assistant';

  @override
  String get navProfile => 'Profile';

  @override
  String get onboardingWelcome => 'Let\'s build your future path';

  @override
  String get onboardingSubtitle =>
      'Tell us a bit about yourself so we can find scholarships, courses, exams, and jobs made for you.';

  @override
  String get stepBasic => 'Basic Info';

  @override
  String get stepLocation => 'Location & Background';

  @override
  String get stepEducation => 'Education & Skills';

  @override
  String get stepAspirations => 'Your Goals';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'e.g. Aarav Sharma';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => 'e.g. +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'Preferred Language';

  @override
  String get selectLanguage => 'Select your language';

  @override
  String get stateLabel => 'State';

  @override
  String get districtLabel => 'District';

  @override
  String get areaTypeLabel => 'Area Type';

  @override
  String get rural => 'Rural';

  @override
  String get urban => 'Urban';

  @override
  String get semiUrban => 'Semi-Urban';

  @override
  String get casteCategoryLabel => 'Social Category';

  @override
  String get incomeBracketLabel => 'Annual Family Income';

  @override
  String get educationLevelLabel => 'Highest Education Level';

  @override
  String get informalLearningLabel =>
      'What have you learned? (Practical/Informal)';

  @override
  String get informalLearningHint =>
      'e.g. Repaired solar pumps, assisted in pharmacy, farm bookkeeping...';

  @override
  String get skillsTitle => 'Skills You Have';

  @override
  String get interestsTitle => 'Fields You Like';

  @override
  String get aspirationLabel => 'What is your dream job or ambition?';

  @override
  String get aspirationHint =>
      'e.g. Agricultural Drone Pilot, Village Electrician, Civil Engineer...';

  @override
  String get btnNext => 'Continue';

  @override
  String get btnBack => 'Back';

  @override
  String get btnFinish => 'Complete Profile';

  @override
  String get saving => 'Saving your profile...';

  @override
  String greeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'Profile Completeness';

  @override
  String get dashboardMatchedOpps => 'Matched Opportunities';

  @override
  String get dashboardActiveDeadlines => 'Deadlines Approaching';

  @override
  String get topOpportunitiesTitle => 'Top Opportunities For You';

  @override
  String get viewAll => 'View All';

  @override
  String socialProofDistrict(int count) {
    return '$count students in your district applied this week';
  }

  @override
  String get searchHint => 'Search scholarships, courses, exams...';

  @override
  String get filterAll => 'All';

  @override
  String get filterScholarships => 'Scholarships';

  @override
  String get filterCourses => 'Courses';

  @override
  String get filterExams => 'Exams';

  @override
  String get filterInternships => 'Internships';

  @override
  String get filterEligibleOnly => 'Eligible Only';

  @override
  String get resetFilters => 'Reset Filters';

  @override
  String get eligibleBadge => 'Eligible';

  @override
  String get notEligibleBadge => 'Check Criteria';

  @override
  String rulesPassed(int passed, int total) {
    return '$passed of $total criteria met';
  }

  @override
  String get eligibilityReasoningTitle => 'Eligibility Breakdown';

  @override
  String get applyNow => 'Apply on Official Portal';

  @override
  String get noOpportunitiesFound =>
      'No matching opportunities found. Try adjusting your filters.';

  @override
  String get assistantTitle => 'AI Career Guide';

  @override
  String get assistantSubtitle => 'Personalized advice for your journey';

  @override
  String get chatInputHint => 'Ask anything about careers or scholarships...';

  @override
  String get send => 'Send';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get addSkill => 'Add Skill';

  @override
  String get addInterest => 'Add Interest';

  @override
  String get saveChanges => 'Save Changes';
}
