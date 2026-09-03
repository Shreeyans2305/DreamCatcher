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
/// import 'l10n/app_localizations.dart';
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
