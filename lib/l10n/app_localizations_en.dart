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
  String get appTagline => 'Career guidance & opportunities for every student';

  @override
  String get navHome => 'Home';

  @override
  String get navOpportunities => 'Opportunities';

  @override
  String get navChat => 'AI Advisor';

  @override
  String get navProfile => 'My Profile';

  @override
  String get navAuth => 'Account Access';

  @override
  String get navOnboarding => 'Welcome';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionSave => 'Save Profile';

  @override
  String get actionExplore => 'Explore Opportunities';

  @override
  String get actionAskAdvisor => 'Talk to Advisor';

  @override
  String get actionSignIn => 'Sign In';

  @override
  String get actionSignOut => 'Sign Out';

  @override
  String get actionSkip => 'Skip for Now';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get offlineTitle => 'Offline Mode';

  @override
  String get offlineMessage =>
      'You are currently viewing offline data. Connect to the internet to sync updates.';

  @override
  String get networkErrorTitle => 'Connection Interrupted';

  @override
  String get networkErrorMessage =>
      'Unable to connect right now. Using locally stored data.';

  @override
  String get networkSimulatorActive => 'Simulated Rural Network Mode Active';

  @override
  String get networkSimulatorToggle => 'Simulate Low-Connectivity (2G/3G)';

  @override
  String get networkSimulatorFailToggle => 'Simulate Network Failure';

  @override
  String get sensitivityNoticeTitle => 'Why we ask for this information';

  @override
  String get sensitivityNoticeBody =>
      'Information such as caste category and family income is used exclusively to find government scholarships, fee waivers, and reservation benefits you qualify for. It is stored securely on your device.';

  @override
  String get profileTitle => 'Student Profile';

  @override
  String get profileSubtitle =>
      'Tell us about yourself to discover matching careers';

  @override
  String get profileName => 'Full Name';

  @override
  String get profileAge => 'Age';

  @override
  String get profileLocation => 'State & District';

  @override
  String get profileIncome => 'Annual Family Income';

  @override
  String get profileCaste => 'Social / Caste Category';

  @override
  String get profileCurriculum => 'School Board / Stream';

  @override
  String get profileSkills => 'Skills & Subjects Learned';

  @override
  String get profileInterests => 'Interests & Hobbies';

  @override
  String get profileAspirations => 'Career Aspirations';

  @override
  String get opportunitiesTitle => 'Opportunity Finder';

  @override
  String get opportunitiesSubtitle =>
      'Scholarships, exams, courses, and jobs tailored for you';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryPathways => 'Pathways';

  @override
  String get categoryScholarships => 'Scholarships';

  @override
  String get categoryExams => 'Exams';

  @override
  String get categoryCourses => 'Courses';

  @override
  String get categoryInternships => 'Internships';

  @override
  String get categoryHigherEd => 'Higher Ed';

  @override
  String get eligibilityLabel => 'Eligibility';

  @override
  String get deadlineLabel => 'Application Deadline';

  @override
  String get providerLabel => 'Offered by';

  @override
  String get chatTitle => 'Career Guidance Assistant';

  @override
  String get chatSubtitle => 'Ask questions in your language anytime';

  @override
  String get chatInputPlaceholder =>
      'Ask a question about careers or colleges...';

  @override
  String get chatSend => 'Send';

  @override
  String get chatInitialGreeting =>
      'Namaste! I am DreamCatcher Advisor. How can I help guide your education and career today?';

  @override
  String get onboardingWelcome => 'Empowering Your Ambitions';

  @override
  String get onboardingDescription =>
      'Find government scholarships, free vocational courses, and step-by-step guidance designed for your future.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get splashLoading => 'Starting DreamCatcher...';
}
