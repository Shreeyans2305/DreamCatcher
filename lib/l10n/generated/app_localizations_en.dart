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

  @override
  String get authWelcomeTitle => 'Sign In to DreamCatcher';

  @override
  String get authWelcomeSubtitle =>
      'Choose how you want to sign in to explore careers and scholarships';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authGoogleSubtitle => 'Sign in with your Google account';

  @override
  String get authContinueOtp => 'Continue with Mobile or Email';

  @override
  String get authOtpSubtitle =>
      'We will send a 6-digit security code to your phone';

  @override
  String get authContinueGovId => 'Verify with Student ID or Aadhaar';

  @override
  String get authGovIdSubtitle =>
      'Sign in using your 12-digit government identification';

  @override
  String get authVoiceHint => 'Tap speaker to hear audio instructions';

  @override
  String get authOfflineNotice =>
      'You are offline. Connect to the internet to sign in for the first time.';

  @override
  String get authOfflineCachedNotice =>
      'Working offline with saved student account';

  @override
  String get authOrDivider => 'OR';

  @override
  String get authEnterPhoneOrEmail => 'Enter Mobile Number or Email';

  @override
  String get authPhoneOrEmailHint => '10-digit mobile number or email address';

  @override
  String get authSendCode => 'Send 6-Digit Code';

  @override
  String get authEnterSecurityCode => 'Enter 6-Digit Security Code';

  @override
  String get authCodeHint => 'Enter the 6 numbers sent to you';

  @override
  String get authTestCodeHint => 'For testing, enter 123456';

  @override
  String get authVerifyAndSignIn => 'Verify & Sign In';

  @override
  String get authInvalidCodeError =>
      'Incorrect code. Please enter 123456 to continue.';

  @override
  String get authChangePhoneOrEmail => 'Change mobile number or email';

  @override
  String get authGovIdConsentTitle => 'Why We Ask For Your Government ID';

  @override
  String get authGovIdConsentBody =>
      'Your ID is used solely to verify your identity for government scholarships, reservations, and fee waivers. It is stored securely encrypted on your device and will never be shared, sold, or logged.';

  @override
  String get authGovIdConsentCheckbox =>
      'I agree to verify my ID for educational scholarships';

  @override
  String get authEnterGovId => 'Enter 12-Digit ID Number';

  @override
  String get authGovIdHint => '1234 5678 9012';

  @override
  String get authGovIdInvalid => 'Please enter a valid 12-digit ID number';

  @override
  String get authGovIdVerifying => 'Verifying your student details securely...';

  @override
  String get authGovIdVerifiedSuccess => 'ID verified successfully!';

  @override
  String onboardingStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get stepBasicInfo => 'Basic Info';

  @override
  String get stepFamilyContext => 'Family Context';

  @override
  String get stepAcademic => 'Education & Learning';

  @override
  String get stepSkillsInterests => 'Skills & Interests';

  @override
  String get stepAspirations => 'Career Aspirations';

  @override
  String get stepReview => 'Review & Submit';

  @override
  String get btnNext => 'Next';

  @override
  String get btnBack => 'Back';

  @override
  String get btnSubmitProfile => 'Submit Profile';

  @override
  String get btnEdit => 'Edit';

  @override
  String get btnSavedDraftNotice => 'Progress saved on device';

  @override
  String get basicInfoTitle => 'Tell Us About Yourself';

  @override
  String get basicInfoSubtitle =>
      'This helps us personalize career guidance for you';

  @override
  String get fieldName => 'Full Name';

  @override
  String get fieldNameHint => 'Enter your full name';

  @override
  String get fieldAge => 'Age';

  @override
  String get fieldAgeHint => 'Enter your age';

  @override
  String get fieldGender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genderPreferNot => 'Prefer not to say';

  @override
  String get fieldState => 'State';

  @override
  String get fieldDistrict => 'District';

  @override
  String get fieldDistrictHint => 'Enter your district name';

  @override
  String get fieldLanguage => 'Preferred App Language';

  @override
  String get economicContextTitle => 'Family & Background Context';

  @override
  String get economicContextSubtitle =>
      'Helps match you with government scholarships and fee waivers';

  @override
  String get fieldIncomeBracket => 'Annual Family Income';

  @override
  String get incomeBelow1L => '< ₹1 Lakh / yr';

  @override
  String get income1LTo2_5L => '₹1 Lakh - ₹2.5 Lakhs / yr';

  @override
  String get income2_5LTo5L => '₹2.5 Lakhs - ₹5 Lakhs / yr';

  @override
  String get incomeAbove5L => '> ₹5 Lakhs / yr';

  @override
  String get fieldCasteCategory => 'Social / Caste Category';

  @override
  String get casteGeneral => 'General';

  @override
  String get casteObc => 'OBC';

  @override
  String get casteSc => 'SC';

  @override
  String get casteSt => 'ST';

  @override
  String get casteEws => 'EWS';

  @override
  String get whyWeAskTitle => 'Why we ask this';

  @override
  String get casteWhyWeAsk =>
      'Caste category is asked solely to verify your eligibility for state and central government reservation seats, scholarships, and fee waivers. It is stored securely on your device.';

  @override
  String get incomeWhyWeAsk =>
      'Many government scholarships require family income to be within specific thresholds (e.g., under ₹2.5 Lakhs/year). This ensures you see scholarships you qualify for.';

  @override
  String get firstGenWhyWeAsk =>
      'First-generation learners are eligible for special higher education tuition waivers, college fee reimbursements, and dedicated mentoring programs.';

  @override
  String get fieldFirstGenLearner => 'First-Generation Learner Status';

  @override
  String get firstGenLearnerDesc =>
      'Are you the first in your immediate family to pursue college or higher studies?';

  @override
  String get firstGenYes => 'Yes, First in Family';

  @override
  String get firstGenNo => 'No';

  @override
  String get academicTitle => 'Your Education & Practical Learning';

  @override
  String get academicSubtitle =>
      'Whether you attended formal school or learned through life & work, tell us your story';

  @override
  String get academicModeStructured => 'Formal School / College';

  @override
  String get academicModeUnstructured => 'Practical / Self-Taught';

  @override
  String get fieldBoard => 'School Board / System';

  @override
  String get boardState => 'State Board';

  @override
  String get boardCbse => 'CBSE';

  @override
  String get boardNios => 'Open School (NIOS)';

  @override
  String get boardOther => 'Other';

  @override
  String get fieldGrade => 'Class / Education Level';

  @override
  String get gradeBelow10 => 'Below Class 10';

  @override
  String get gradeClass10 => 'Class 10';

  @override
  String get gradeClass12 => 'Class 12';

  @override
  String get gradeVocationalIti => 'ITI / Vocational';

  @override
  String get gradeCollege => 'College / Degree';

  @override
  String get fieldMarks => 'Marks or Percentage (Optional)';

  @override
  String get fieldMarksHint => 'e.g. 68% or First Division';

  @override
  String get unstructuredLearningPrompt =>
      'Tell me what you have studied and what you are good at';

  @override
  String get unstructuredLearningHint =>
      'Describe what you\'ve learned in or out of school, such as repairing machines, farming, tailoring, local business...';

  @override
  String get voiceNoteButton => 'Speak / Voice Note';

  @override
  String get voiceNoteHint => 'Tap to speak your experience';

  @override
  String get voiceNoteRecordedSuccess => 'Voice note transcribed successfully!';

  @override
  String get commonSubjectsTitle => 'Common Subjects & Practical Skills';

  @override
  String get commonSubjectsSubtitle =>
      'Select any that you know or have practiced';

  @override
  String get skillsInterestsTitle => 'Skills & Interests';

  @override
  String get skillsInterestsSubtitle =>
      'Select skills you possess and areas you want to explore';

  @override
  String get skillsTitle => 'Your Skills';

  @override
  String get interestsTitle => 'Your Interests';

  @override
  String get addCustomTagHint =>
      'Add a skill or topic (e.g., Solar Maintenance)';

  @override
  String get btnAdd => 'Add';

  @override
  String get freeTextInterestsPrompt =>
      'Tell us more about your hobbies and passions';

  @override
  String get freeTextInterestsHint =>
      'e.g., I enjoy cricket, music, making local handicrafts...';

  @override
  String get aspirationsTitle => 'Your Career Aspirations';

  @override
  String get aspirationsSubtitle =>
      'What do you want to become or achieve in the future?';

  @override
  String get aspirationsPrompt => 'What do you want to become or achieve?';

  @override
  String get aspirationsHint => 'Type your dream job or goals here...';

  @override
  String get aspirationSuggestionsTitle => 'Not sure? Tap an idea below:';

  @override
  String get aspNotSure => 'Not sure yet — need guidance';

  @override
  String get aspGovtJob => 'Want a secure Government job';

  @override
  String get aspStudyFurther => 'Want to study further in college';

  @override
  String get aspStartBusiness => 'Want to start my own business';

  @override
  String get aspTechnicalSkill => 'Want a practical technical career';

  @override
  String get aspEarnWhileLearning => 'Want to earn money while studying';

  @override
  String get reviewTitle => 'Review Your Profile';

  @override
  String get reviewSubtitle =>
      'Please review your information. You can tap edit to make any changes.';

  @override
  String get reviewBasicInfo => 'Personal Information';

  @override
  String get reviewEconomic => 'Family & Economic Context';

  @override
  String get reviewAcademic => 'Education & Learning';

  @override
  String get reviewSkills => 'Skills & Interests';

  @override
  String get reviewAspirations => 'Career Aspirations';

  @override
  String get reviewOfflineNotice =>
      'You are currently offline. Your profile will be saved on your device and automatically synced once you reconnect.';

  @override
  String get reviewOnlineNotice =>
      'Your profile will be saved and synced securely to the server.';

  @override
  String get profileSubmittedSuccess =>
      'Profile saved successfully! Welcome to DreamCatcher.';

  @override
  String get profileQueuedOfflineSuccess =>
      'Profile saved offline! It will automatically sync when connected to the internet.';

  @override
  String get syncPendingNotice => 'Syncing pending offline profile...';

  @override
  String get syncSuccessNotice => 'Offline profile synchronized successfully!';
}
