import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'DreamCatcher'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Career guidance & opportunities for every student'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get navOpportunities;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'AI Advisor'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get navProfile;

  /// No description provided for @navAuth.
  ///
  /// In en, this message translates to:
  /// **'Account Access'**
  String get navAuth;

  /// No description provided for @navOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get navOnboarding;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get actionSave;

  /// No description provided for @actionExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore Opportunities'**
  String get actionExplore;

  /// No description provided for @actionAskAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Talk to Advisor'**
  String get actionAskAdvisor;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get actionSignIn;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get actionSignOut;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get actionSkip;

  /// No description provided for @actionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineTitle;

  /// No description provided for @offlineMessage.
  ///
  /// In en, this message translates to:
  /// **'You are currently viewing offline data. Connect to the internet to sync updates.'**
  String get offlineMessage;

  /// No description provided for @networkErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Interrupted'**
  String get networkErrorTitle;

  /// No description provided for @networkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect right now. Using locally stored data.'**
  String get networkErrorMessage;

  /// No description provided for @networkSimulatorActive.
  ///
  /// In en, this message translates to:
  /// **'Simulated Rural Network Mode Active'**
  String get networkSimulatorActive;

  /// No description provided for @networkSimulatorToggle.
  ///
  /// In en, this message translates to:
  /// **'Simulate Low-Connectivity (2G/3G)'**
  String get networkSimulatorToggle;

  /// No description provided for @networkSimulatorFailToggle.
  ///
  /// In en, this message translates to:
  /// **'Simulate Network Failure'**
  String get networkSimulatorFailToggle;

  /// No description provided for @sensitivityNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Why we ask for this information'**
  String get sensitivityNoticeTitle;

  /// No description provided for @sensitivityNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Information such as caste category and family income is used exclusively to find government scholarships, fee waivers, and reservation benefits you qualify for. It is stored securely on your device.'**
  String get sensitivityNoticeBody;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Student Profile'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself to discover matching careers'**
  String get profileSubtitle;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileName;

  /// No description provided for @profileAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileAge;

  /// No description provided for @profileLocation.
  ///
  /// In en, this message translates to:
  /// **'State & District'**
  String get profileLocation;

  /// No description provided for @profileIncome.
  ///
  /// In en, this message translates to:
  /// **'Annual Family Income'**
  String get profileIncome;

  /// No description provided for @profileCaste.
  ///
  /// In en, this message translates to:
  /// **'Social / Caste Category'**
  String get profileCaste;

  /// No description provided for @profileCurriculum.
  ///
  /// In en, this message translates to:
  /// **'School Board / Stream'**
  String get profileCurriculum;

  /// No description provided for @profileSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills & Subjects Learned'**
  String get profileSkills;

  /// No description provided for @profileInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests & Hobbies'**
  String get profileInterests;

  /// No description provided for @profileAspirations.
  ///
  /// In en, this message translates to:
  /// **'Career Aspirations'**
  String get profileAspirations;

  /// No description provided for @opportunitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Opportunity Finder'**
  String get opportunitiesTitle;

  /// No description provided for @opportunitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scholarships, exams, courses, and jobs tailored for you'**
  String get opportunitiesSubtitle;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryPathways.
  ///
  /// In en, this message translates to:
  /// **'Pathways'**
  String get categoryPathways;

  /// No description provided for @categoryScholarships.
  ///
  /// In en, this message translates to:
  /// **'Scholarships'**
  String get categoryScholarships;

  /// No description provided for @categoryExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get categoryExams;

  /// No description provided for @categoryCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get categoryCourses;

  /// No description provided for @categoryInternships.
  ///
  /// In en, this message translates to:
  /// **'Internships'**
  String get categoryInternships;

  /// No description provided for @categoryHigherEd.
  ///
  /// In en, this message translates to:
  /// **'Higher Ed'**
  String get categoryHigherEd;

  /// No description provided for @eligibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get eligibilityLabel;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Application Deadline'**
  String get deadlineLabel;

  /// No description provided for @providerLabel.
  ///
  /// In en, this message translates to:
  /// **'Offered by'**
  String get providerLabel;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Career Guidance Assistant'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask questions in your language anytime'**
  String get chatSubtitle;

  /// No description provided for @chatInputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ask a question about careers or colleges...'**
  String get chatInputPlaceholder;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatInitialGreeting.
  ///
  /// In en, this message translates to:
  /// **'Namaste! I am DreamCatcher Advisor. How can I help guide your education and career today?'**
  String get chatInitialGreeting;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Empowering Your Ambitions'**
  String get onboardingWelcome;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Find government scholarships, free vocational courses, and step-by-step guidance designed for your future.'**
  String get onboardingDescription;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Starting DreamCatcher...'**
  String get splashLoading;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In to DreamCatcher'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to sign in to explore careers and scholarships'**
  String get authWelcomeSubtitle;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authGoogleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account'**
  String get authGoogleSubtitle;

  /// No description provided for @authContinueOtp.
  ///
  /// In en, this message translates to:
  /// **'Continue with Mobile or Email'**
  String get authContinueOtp;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit security code to your phone'**
  String get authOtpSubtitle;

  /// No description provided for @authContinueGovId.
  ///
  /// In en, this message translates to:
  /// **'Verify with Student ID or Aadhaar'**
  String get authContinueGovId;

  /// No description provided for @authGovIdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in using your 12-digit government identification'**
  String get authGovIdSubtitle;

  /// No description provided for @authVoiceHint.
  ///
  /// In en, this message translates to:
  /// **'Tap speaker to hear audio instructions'**
  String get authVoiceHint;

  /// No description provided for @authOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Connect to the internet to sign in for the first time.'**
  String get authOfflineNotice;

  /// No description provided for @authOfflineCachedNotice.
  ///
  /// In en, this message translates to:
  /// **'Working offline with saved student account'**
  String get authOfflineCachedNotice;

  /// No description provided for @authOrDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get authOrDivider;

  /// No description provided for @authEnterPhoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number or Email'**
  String get authEnterPhoneOrEmail;

  /// No description provided for @authPhoneOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number or email address'**
  String get authPhoneOrEmailHint;

  /// No description provided for @authSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send 6-Digit Code'**
  String get authSendCode;

  /// No description provided for @authEnterSecurityCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-Digit Security Code'**
  String get authEnterSecurityCode;

  /// No description provided for @authCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 numbers sent to you'**
  String get authCodeHint;

  /// No description provided for @authTestCodeHint.
  ///
  /// In en, this message translates to:
  /// **'For testing, enter 123456'**
  String get authTestCodeHint;

  /// No description provided for @authVerifyAndSignIn.
  ///
  /// In en, this message translates to:
  /// **'Verify & Sign In'**
  String get authVerifyAndSignIn;

  /// No description provided for @authInvalidCodeError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Please enter 123456 to continue.'**
  String get authInvalidCodeError;

  /// No description provided for @authChangePhoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Change mobile number or email'**
  String get authChangePhoneOrEmail;

  /// No description provided for @authGovIdConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Why We Ask For Your Government ID'**
  String get authGovIdConsentTitle;

  /// No description provided for @authGovIdConsentBody.
  ///
  /// In en, this message translates to:
  /// **'Your ID is used solely to verify your identity for government scholarships, reservations, and fee waivers. It is stored securely encrypted on your device and will never be shared, sold, or logged.'**
  String get authGovIdConsentBody;

  /// No description provided for @authGovIdConsentCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I agree to verify my ID for educational scholarships'**
  String get authGovIdConsentCheckbox;

  /// No description provided for @authEnterGovId.
  ///
  /// In en, this message translates to:
  /// **'Enter 12-Digit ID Number'**
  String get authEnterGovId;

  /// No description provided for @authGovIdHint.
  ///
  /// In en, this message translates to:
  /// **'1234 5678 9012'**
  String get authGovIdHint;

  /// No description provided for @authGovIdInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 12-digit ID number'**
  String get authGovIdInvalid;

  /// No description provided for @authGovIdVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying your student details securely...'**
  String get authGovIdVerifying;

  /// No description provided for @authGovIdVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'ID verified successfully!'**
  String get authGovIdVerifiedSuccess;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @stepBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get stepBasicInfo;

  /// No description provided for @stepFamilyContext.
  ///
  /// In en, this message translates to:
  /// **'Family Context'**
  String get stepFamilyContext;

  /// No description provided for @stepAcademic.
  ///
  /// In en, this message translates to:
  /// **'Education & Learning'**
  String get stepAcademic;

  /// No description provided for @stepSkillsInterests.
  ///
  /// In en, this message translates to:
  /// **'Skills & Interests'**
  String get stepSkillsInterests;

  /// No description provided for @stepAspirations.
  ///
  /// In en, this message translates to:
  /// **'Career Aspirations'**
  String get stepAspirations;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get stepReview;

  /// No description provided for @btnNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get btnNext;

  /// No description provided for @btnBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get btnBack;

  /// No description provided for @btnSubmitProfile.
  ///
  /// In en, this message translates to:
  /// **'Submit Profile'**
  String get btnSubmitProfile;

  /// No description provided for @btnEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get btnEdit;

  /// No description provided for @btnSavedDraftNotice.
  ///
  /// In en, this message translates to:
  /// **'Progress saved on device'**
  String get btnSavedDraftNotice;

  /// No description provided for @basicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell Us About Yourself'**
  String get basicInfoTitle;

  /// No description provided for @basicInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us personalize career guidance for you'**
  String get basicInfoSubtitle;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fieldName;

  /// No description provided for @fieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fieldNameHint;

  /// No description provided for @fieldAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get fieldAge;

  /// No description provided for @fieldAgeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get fieldAgeHint;

  /// No description provided for @fieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get fieldGender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @genderPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNot;

  /// No description provided for @fieldState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get fieldState;

  /// No description provided for @fieldDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get fieldDistrict;

  /// No description provided for @fieldDistrictHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your district name'**
  String get fieldDistrictHint;

  /// No description provided for @fieldLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred App Language'**
  String get fieldLanguage;

  /// No description provided for @economicContextTitle.
  ///
  /// In en, this message translates to:
  /// **'Family & Background Context'**
  String get economicContextTitle;

  /// No description provided for @economicContextSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Helps match you with government scholarships and fee waivers'**
  String get economicContextSubtitle;

  /// No description provided for @fieldIncomeBracket.
  ///
  /// In en, this message translates to:
  /// **'Annual Family Income'**
  String get fieldIncomeBracket;

  /// No description provided for @incomeBelow1L.
  ///
  /// In en, this message translates to:
  /// **'< ₹1 Lakh / yr'**
  String get incomeBelow1L;

  /// No description provided for @income1LTo2_5L.
  ///
  /// In en, this message translates to:
  /// **'₹1 Lakh - ₹2.5 Lakhs / yr'**
  String get income1LTo2_5L;

  /// No description provided for @income2_5LTo5L.
  ///
  /// In en, this message translates to:
  /// **'₹2.5 Lakhs - ₹5 Lakhs / yr'**
  String get income2_5LTo5L;

  /// No description provided for @incomeAbove5L.
  ///
  /// In en, this message translates to:
  /// **'> ₹5 Lakhs / yr'**
  String get incomeAbove5L;

  /// No description provided for @fieldCasteCategory.
  ///
  /// In en, this message translates to:
  /// **'Social / Caste Category'**
  String get fieldCasteCategory;

  /// No description provided for @casteGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get casteGeneral;

  /// No description provided for @casteObc.
  ///
  /// In en, this message translates to:
  /// **'OBC'**
  String get casteObc;

  /// No description provided for @casteSc.
  ///
  /// In en, this message translates to:
  /// **'SC'**
  String get casteSc;

  /// No description provided for @casteSt.
  ///
  /// In en, this message translates to:
  /// **'ST'**
  String get casteSt;

  /// No description provided for @casteEws.
  ///
  /// In en, this message translates to:
  /// **'EWS'**
  String get casteEws;

  /// No description provided for @whyWeAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Why we ask this'**
  String get whyWeAskTitle;

  /// No description provided for @casteWhyWeAsk.
  ///
  /// In en, this message translates to:
  /// **'Caste category is asked solely to verify your eligibility for state and central government reservation seats, scholarships, and fee waivers. It is stored securely on your device.'**
  String get casteWhyWeAsk;

  /// No description provided for @incomeWhyWeAsk.
  ///
  /// In en, this message translates to:
  /// **'Many government scholarships require family income to be within specific thresholds (e.g., under ₹2.5 Lakhs/year). This ensures you see scholarships you qualify for.'**
  String get incomeWhyWeAsk;

  /// No description provided for @firstGenWhyWeAsk.
  ///
  /// In en, this message translates to:
  /// **'First-generation learners are eligible for special higher education tuition waivers, college fee reimbursements, and dedicated mentoring programs.'**
  String get firstGenWhyWeAsk;

  /// No description provided for @fieldFirstGenLearner.
  ///
  /// In en, this message translates to:
  /// **'First-Generation Learner Status'**
  String get fieldFirstGenLearner;

  /// No description provided for @firstGenLearnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you the first in your immediate family to pursue college or higher studies?'**
  String get firstGenLearnerDesc;

  /// No description provided for @firstGenYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, First in Family'**
  String get firstGenYes;

  /// No description provided for @firstGenNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get firstGenNo;

  /// No description provided for @academicTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Education & Practical Learning'**
  String get academicTitle;

  /// No description provided for @academicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether you attended formal school or learned through life & work, tell us your story'**
  String get academicSubtitle;

  /// No description provided for @academicModeStructured.
  ///
  /// In en, this message translates to:
  /// **'Formal School / College'**
  String get academicModeStructured;

  /// No description provided for @academicModeUnstructured.
  ///
  /// In en, this message translates to:
  /// **'Practical / Self-Taught'**
  String get academicModeUnstructured;

  /// No description provided for @fieldBoard.
  ///
  /// In en, this message translates to:
  /// **'School Board / System'**
  String get fieldBoard;

  /// No description provided for @boardState.
  ///
  /// In en, this message translates to:
  /// **'State Board'**
  String get boardState;

  /// No description provided for @boardCbse.
  ///
  /// In en, this message translates to:
  /// **'CBSE'**
  String get boardCbse;

  /// No description provided for @boardNios.
  ///
  /// In en, this message translates to:
  /// **'Open School (NIOS)'**
  String get boardNios;

  /// No description provided for @boardOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get boardOther;

  /// No description provided for @fieldGrade.
  ///
  /// In en, this message translates to:
  /// **'Class / Education Level'**
  String get fieldGrade;

  /// No description provided for @gradeBelow10.
  ///
  /// In en, this message translates to:
  /// **'Below Class 10'**
  String get gradeBelow10;

  /// No description provided for @gradeClass10.
  ///
  /// In en, this message translates to:
  /// **'Class 10'**
  String get gradeClass10;

  /// No description provided for @gradeClass12.
  ///
  /// In en, this message translates to:
  /// **'Class 12'**
  String get gradeClass12;

  /// No description provided for @gradeVocationalIti.
  ///
  /// In en, this message translates to:
  /// **'ITI / Vocational'**
  String get gradeVocationalIti;

  /// No description provided for @gradeCollege.
  ///
  /// In en, this message translates to:
  /// **'College / Degree'**
  String get gradeCollege;

  /// No description provided for @fieldMarks.
  ///
  /// In en, this message translates to:
  /// **'Marks or Percentage (Optional)'**
  String get fieldMarks;

  /// No description provided for @fieldMarksHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 68% or First Division'**
  String get fieldMarksHint;

  /// No description provided for @unstructuredLearningPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tell me what you have studied and what you are good at'**
  String get unstructuredLearningPrompt;

  /// No description provided for @unstructuredLearningHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what you\'ve learned in or out of school, such as repairing machines, farming, tailoring, local business...'**
  String get unstructuredLearningHint;

  /// No description provided for @voiceNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Speak / Voice Note'**
  String get voiceNoteButton;

  /// No description provided for @voiceNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak your experience'**
  String get voiceNoteHint;

  /// No description provided for @voiceNoteRecordedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Voice note transcribed successfully!'**
  String get voiceNoteRecordedSuccess;

  /// No description provided for @commonSubjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Common Subjects & Practical Skills'**
  String get commonSubjectsTitle;

  /// No description provided for @commonSubjectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select any that you know or have practiced'**
  String get commonSubjectsSubtitle;

  /// No description provided for @skillsInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills & Interests'**
  String get skillsInterestsTitle;

  /// No description provided for @skillsInterestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select skills you possess and areas you want to explore'**
  String get skillsInterestsSubtitle;

  /// No description provided for @skillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Skills'**
  String get skillsTitle;

  /// No description provided for @interestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Interests'**
  String get interestsTitle;

  /// No description provided for @addCustomTagHint.
  ///
  /// In en, this message translates to:
  /// **'Add a skill or topic (e.g., Solar Maintenance)'**
  String get addCustomTagHint;

  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btnAdd;

  /// No description provided for @freeTextInterestsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about your hobbies and passions'**
  String get freeTextInterestsPrompt;

  /// No description provided for @freeTextInterestsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., I enjoy cricket, music, making local handicrafts...'**
  String get freeTextInterestsHint;

  /// No description provided for @aspirationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Career Aspirations'**
  String get aspirationsTitle;

  /// No description provided for @aspirationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to become or achieve in the future?'**
  String get aspirationsSubtitle;

  /// No description provided for @aspirationsPrompt.
  ///
  /// In en, this message translates to:
  /// **'What do you want to become or achieve?'**
  String get aspirationsPrompt;

  /// No description provided for @aspirationsHint.
  ///
  /// In en, this message translates to:
  /// **'Type your dream job or goals here...'**
  String get aspirationsHint;

  /// No description provided for @aspirationSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Not sure? Tap an idea below:'**
  String get aspirationSuggestionsTitle;

  /// No description provided for @aspNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure yet — need guidance'**
  String get aspNotSure;

  /// No description provided for @aspGovtJob.
  ///
  /// In en, this message translates to:
  /// **'Want a secure Government job'**
  String get aspGovtJob;

  /// No description provided for @aspStudyFurther.
  ///
  /// In en, this message translates to:
  /// **'Want to study further in college'**
  String get aspStudyFurther;

  /// No description provided for @aspStartBusiness.
  ///
  /// In en, this message translates to:
  /// **'Want to start my own business'**
  String get aspStartBusiness;

  /// No description provided for @aspTechnicalSkill.
  ///
  /// In en, this message translates to:
  /// **'Want a practical technical career'**
  String get aspTechnicalSkill;

  /// No description provided for @aspEarnWhileLearning.
  ///
  /// In en, this message translates to:
  /// **'Want to earn money while studying'**
  String get aspEarnWhileLearning;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Your Profile'**
  String get reviewTitle;

  /// No description provided for @reviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review your information. You can tap edit to make any changes.'**
  String get reviewSubtitle;

  /// No description provided for @reviewBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get reviewBasicInfo;

  /// No description provided for @reviewEconomic.
  ///
  /// In en, this message translates to:
  /// **'Family & Economic Context'**
  String get reviewEconomic;

  /// No description provided for @reviewAcademic.
  ///
  /// In en, this message translates to:
  /// **'Education & Learning'**
  String get reviewAcademic;

  /// No description provided for @reviewSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills & Interests'**
  String get reviewSkills;

  /// No description provided for @reviewAspirations.
  ///
  /// In en, this message translates to:
  /// **'Career Aspirations'**
  String get reviewAspirations;

  /// No description provided for @reviewOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline. Your profile will be saved on your device and automatically synced once you reconnect.'**
  String get reviewOfflineNotice;

  /// No description provided for @reviewOnlineNotice.
  ///
  /// In en, this message translates to:
  /// **'Your profile will be saved and synced securely to the server.'**
  String get reviewOnlineNotice;

  /// No description provided for @profileSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully! Welcome to DreamCatcher.'**
  String get profileSubmittedSuccess;

  /// No description provided for @profileQueuedOfflineSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile saved offline! It will automatically sync when connected to the internet.'**
  String get profileQueuedOfflineSuccess;

  /// No description provided for @syncPendingNotice.
  ///
  /// In en, this message translates to:
  /// **'Syncing pending offline profile...'**
  String get syncPendingNotice;

  /// No description provided for @syncSuccessNotice.
  ///
  /// In en, this message translates to:
  /// **'Offline profile synchronized successfully!'**
  String get syncSuccessNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
