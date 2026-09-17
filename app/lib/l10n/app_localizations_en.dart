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

  @override
  String opportunitiesAvailable(int count) {
    return '$count opportunities available';
  }

  @override
  String get opportunityTypeScholarship => 'Scholarship';

  @override
  String get opportunityTypeCourse => 'Vocational Course';

  @override
  String get opportunityTypeExam => 'Entrance Exam';

  @override
  String get opportunityTypeInternship => 'Internship / Fellowship';

  @override
  String get opportunityTypeGeneral => 'Opportunity';

  @override
  String get openToAllCriteria =>
      'Open to all candidates meeting basic requirements';

  @override
  String get noMatchingOpportunities => 'No matching opportunities';

  @override
  String get noMatchingOpportunitiesSubtitle =>
      'Try clearing your search query or disabling the \"Eligible Only\" filter.';

  @override
  String officialPortalOpening(String url) {
    return 'Opening official portal: $url';
  }

  @override
  String get statFinancialBenefit => 'Financial Benefit';

  @override
  String get statKeyDetails => 'Key Details';

  @override
  String get opportunityAbout => 'About this Opportunity';

  @override
  String yourProfileValue(String value) {
    return 'Your profile: $value';
  }

  @override
  String get openToAllGeneral =>
      'Open to all students meeting standard general qualification.';

  @override
  String get locationNotSet => 'Location not set';

  @override
  String get demographicsTitle => 'Demographics & Quotas';

  @override
  String get socialCategoryLabel => 'Social Category & Caste';

  @override
  String get tribeLabel => 'Tribe Affiliation';

  @override
  String get annualIncomeLabel => 'Annual Family Income';

  @override
  String get areaClassificationLabel => 'Area Classification';

  @override
  String get educationSectionTitle => 'Education & Learning';

  @override
  String skillsSectionTitle(int count) {
    return 'Skills ($count)';
  }

  @override
  String interestsSectionTitle(int count) {
    return 'Interests ($count)';
  }

  @override
  String get careerAspirationTitle => 'Career Ambition / Dream';

  @override
  String get btnUpdate => 'Update';

  @override
  String get btnAddSkill => '+ Add Skill';

  @override
  String get btnAddInterest => '+ Add Interest';

  @override
  String get btnSwitchProfile => 'Switch / Reset Profile';

  @override
  String get noneSpecified => 'None specified';

  @override
  String get nilIncome => '₹0 (Nil Income / Under ₹25k)';

  @override
  String underIncome(String amount) {
    return '₹$amount (Under ₹25,000)';
  }

  @override
  String perYearIncome(String amount) {
    return '₹$amount / year';
  }

  @override
  String get noEducationDescription =>
      'No informal or hands-on description added yet.';

  @override
  String get noSkillsAdded =>
      'No skills added yet. Tap \"+ Add Skill\" to link skills from our catalogue.';

  @override
  String get noInterestsAdded =>
      'No interests added yet. Tap \"+ Add Interest\" to pick fields you enjoy.';

  @override
  String get noAspirationAdded => 'No aspiration added yet.';

  @override
  String get qualifiesFullWaiver =>
      '✓ Qualifies for 100% full fee waiver and maximum need-based scholarships.';

  @override
  String get dialogAddSkillTitle => 'Add a New Skill';

  @override
  String get dialogAllSkillsAdded =>
      'All available catalogue skills are already added!';

  @override
  String get dialogAddInterestTitle => 'Add a Field of Interest';

  @override
  String get dialogAllInterestsAdded =>
      'All available interests are already added!';

  @override
  String get dialogUpdateEducationTitle => 'Update Education & Learning';

  @override
  String get dialogEduLevelLabel => 'Education Level';

  @override
  String get dialogEduDescLabel => 'Hands-on / Informal Learning Description';

  @override
  String get dialogEduDescHint => 'What have you learned to do practically?';

  @override
  String get dialogAspirationTitle => 'Your Career Goal / Ambition';

  @override
  String get dialogAspirationHint =>
      'e.g. Agricultural Drone Pilot, Electrical Contractor...';

  @override
  String get dialogDemographicsTitle => 'Update Demographics & Quotas';

  @override
  String get dialogCasteQuotaLabel => 'Social Category / Caste Quota';

  @override
  String get dialogTribeLabel => 'Tribe / Community (Optional)';

  @override
  String get dialogTribeSubtitle =>
      'Unlocks specific Ministry of Tribal Affairs (MoTA) and PVTG programs.';

  @override
  String get dialogTribeCustomHint => 'Or enter custom tribe / PVTG name...';

  @override
  String get dialogIncomeLabel => 'Family Income';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnSave => 'Save';

  @override
  String snackbarSkillAdded(String name) {
    return 'Added skill: $name';
  }

  @override
  String snackbarInterestAdded(String name) {
    return 'Added interest: $name';
  }

  @override
  String get snackbarEducationUpdated =>
      'Education details updated successfully!';

  @override
  String get snackbarAspirationUpdated => 'Aspiration updated!';

  @override
  String get snackbarDemographicsUpdated =>
      'Demographics & quota eligibility updated!';

  @override
  String snackbarError(String error) {
    return 'Error: $error';
  }

  @override
  String get eduPrimary => 'Primary School (Up to 5th)';

  @override
  String get eduUpperPrimary => 'Middle School (6th - 8th)';

  @override
  String get eduSecondary => '10th Pass (Secondary)';

  @override
  String get eduSeniorSecondary => '12th Pass (Higher Secondary)';

  @override
  String get eduDiploma => 'Diploma / Polytechnic';

  @override
  String get eduVocational => 'Vocational / ITI';

  @override
  String get eduBachelor => 'Bachelor\'s Degree';

  @override
  String get eduMaster => 'Master\'s Degree';

  @override
  String get eduInformal => 'Informal / Practical Learning';

  @override
  String get eduSelfLearning => 'Self-Taught';

  @override
  String get eduOther => 'Other';

  @override
  String get catGeneral => 'General';

  @override
  String get catOBC => 'OBC';

  @override
  String get catSC => 'SC';

  @override
  String get catST => 'ST';

  @override
  String get catEWS => 'EWS';
}
