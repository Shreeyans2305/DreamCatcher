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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DreamCatcher'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Discover your future, step by step'**
  String get tagline;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navDashboard;

  /// No description provided for @navOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get navOpportunities;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build your future path'**
  String get onboardingWelcome;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself so we can find scholarships, courses, exams, and jobs made for you.'**
  String get onboardingSubtitle;

  /// No description provided for @stepBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get stepBasic;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location & Background'**
  String get stepLocation;

  /// No description provided for @stepEducation.
  ///
  /// In en, this message translates to:
  /// **'Education & Skills'**
  String get stepEducation;

  /// No description provided for @stepAspirations.
  ///
  /// In en, this message translates to:
  /// **'Your Goals'**
  String get stepAspirations;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Aarav Sharma'**
  String get fullNameHint;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. +91 98765 43210'**
  String get phoneHint;

  /// No description provided for @preferredLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguageLabel;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get selectLanguage;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateLabel;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtLabel;

  /// No description provided for @areaTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Area Type'**
  String get areaTypeLabel;

  /// No description provided for @rural.
  ///
  /// In en, this message translates to:
  /// **'Rural'**
  String get rural;

  /// No description provided for @urban.
  ///
  /// In en, this message translates to:
  /// **'Urban'**
  String get urban;

  /// No description provided for @semiUrban.
  ///
  /// In en, this message translates to:
  /// **'Semi-Urban'**
  String get semiUrban;

  /// No description provided for @casteCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Social Category'**
  String get casteCategoryLabel;

  /// No description provided for @incomeBracketLabel.
  ///
  /// In en, this message translates to:
  /// **'Annual Family Income'**
  String get incomeBracketLabel;

  /// No description provided for @educationLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Highest Education Level'**
  String get educationLevelLabel;

  /// No description provided for @informalLearningLabel.
  ///
  /// In en, this message translates to:
  /// **'What have you learned? (Practical/Informal)'**
  String get informalLearningLabel;

  /// No description provided for @informalLearningHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Repaired solar pumps, assisted in pharmacy, farm bookkeeping...'**
  String get informalLearningHint;

  /// No description provided for @skillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills You Have'**
  String get skillsTitle;

  /// No description provided for @interestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fields You Like'**
  String get interestsTitle;

  /// No description provided for @aspirationLabel.
  ///
  /// In en, this message translates to:
  /// **'What is your dream job or ambition?'**
  String get aspirationLabel;

  /// No description provided for @aspirationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Agricultural Drone Pilot, Village Electrician, Civil Engineer...'**
  String get aspirationHint;

  /// No description provided for @btnNext.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get btnNext;

  /// No description provided for @btnBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get btnBack;

  /// No description provided for @btnFinish.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get btnFinish;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving your profile...'**
  String get saving;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String greeting(String name);

  /// No description provided for @dashboardCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Profile Completeness'**
  String get dashboardCompleteness;

  /// No description provided for @dashboardMatchedOpps.
  ///
  /// In en, this message translates to:
  /// **'Matched Opportunities'**
  String get dashboardMatchedOpps;

  /// No description provided for @dashboardActiveDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadlines Approaching'**
  String get dashboardActiveDeadlines;

  /// No description provided for @topOpportunitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Opportunities For You'**
  String get topOpportunitiesTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @socialProofDistrict.
  ///
  /// In en, this message translates to:
  /// **'{count} students in your district applied this week'**
  String socialProofDistrict(int count);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search scholarships, courses, exams...'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterScholarships.
  ///
  /// In en, this message translates to:
  /// **'Scholarships'**
  String get filterScholarships;

  /// No description provided for @filterCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get filterCourses;

  /// No description provided for @filterExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get filterExams;

  /// No description provided for @filterInternships.
  ///
  /// In en, this message translates to:
  /// **'Internships'**
  String get filterInternships;

  /// No description provided for @filterEligibleOnly.
  ///
  /// In en, this message translates to:
  /// **'Eligible Only'**
  String get filterEligibleOnly;

  /// No description provided for @eligibleBadge.
  ///
  /// In en, this message translates to:
  /// **'Eligible'**
  String get eligibleBadge;

  /// No description provided for @notEligibleBadge.
  ///
  /// In en, this message translates to:
  /// **'Check Criteria'**
  String get notEligibleBadge;

  /// No description provided for @rulesPassed.
  ///
  /// In en, this message translates to:
  /// **'{passed} of {total} criteria met'**
  String rulesPassed(int passed, int total);

  /// No description provided for @eligibilityReasoningTitle.
  ///
  /// In en, this message translates to:
  /// **'Eligibility Breakdown'**
  String get eligibilityReasoningTitle;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply on Official Portal'**
  String get applyNow;

  /// No description provided for @noOpportunitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No matching opportunities found. Try adjusting your filters.'**
  String get noOpportunitiesFound;

  /// No description provided for @assistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Career Guide'**
  String get assistantTitle;

  /// No description provided for @assistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized advice for your journey'**
  String get assistantSubtitle;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about careers or scholarships...'**
  String get chatInputHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'Add Skill'**
  String get addSkill;

  /// No description provided for @addInterest.
  ///
  /// In en, this message translates to:
  /// **'Add Interest'**
  String get addInterest;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;
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
