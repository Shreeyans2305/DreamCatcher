// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'ડ્રીમકેચર';

  @override
  String get tagline => 'પગલું દર પગલું તમારું ભવિષ્ય શોધો';

  @override
  String get navDashboard => 'હોમ';

  @override
  String get navOpportunities => 'તકો';

  @override
  String get navChat => 'સહાયક';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get onboardingWelcome => 'ચાલો તમારા ભવિષ્યનો માર્ગ બનાવીએ';

  @override
  String get onboardingSubtitle =>
      'તમારા વિશે થોડી માહિતી આપો જેથી અમે તમારા માટે યોગ્ય શિષ્યવૃત્તિ, અભ્યાસક્રમ, પરીક્ષા અને નોકરી શોધી શકીએ.';

  @override
  String get stepBasic => 'મૂળભૂત માહિતી';

  @override
  String get stepLocation => 'સ્થાન અને પૃષ્ઠભૂમિ';

  @override
  String get stepEducation => 'શિક્ષણ અને કુશળતા';

  @override
  String get stepAspirations => 'તમારા લક્ષ્યો';

  @override
  String get fullNameLabel => 'પૂરું નામ';

  @override
  String get fullNameHint => 'દા.ત. આરવ શર્મા';

  @override
  String get phoneLabel => 'ફોન નંબર';

  @override
  String get phoneHint => 'દા.ત. +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'પસંદગીની ભાષા';

  @override
  String get selectLanguage => 'તમારી ભાષા પસંદ કરો';

  @override
  String get stateLabel => 'રાજ્ય';

  @override
  String get districtLabel => 'જિલ્લો';

  @override
  String get areaTypeLabel => 'વિસ્તારનો પ્રકાર';

  @override
  String get rural => 'ગ્રામીણ';

  @override
  String get urban => 'શહેરી';

  @override
  String get semiUrban => 'અર્ધ-શહેરી';

  @override
  String get casteCategoryLabel => 'સામાજિક વર્ગ';

  @override
  String get incomeBracketLabel => 'વાર્ષિક કુટુંબ આવક';

  @override
  String get educationLevelLabel => 'સર્વોચ્ચ શિક્ષણ સ્તર';

  @override
  String get informalLearningLabel =>
      'What have you learned? (Practical/Informal)';

  @override
  String get informalLearningHint =>
      'e.g. Repaired solar pumps, assisted in pharmacy, farm bookkeeping...';

  @override
  String get skillsTitle => 'તમારી કુશળતા';

  @override
  String get interestsTitle => 'તમને ગમતા ક્ષેત્રો';

  @override
  String get aspirationLabel => 'તમારી સ્વપ્ન નોકરી અથવા મહત્વાકાંક્ષા શું છે?';

  @override
  String get aspirationHint =>
      'દા.ત. કૃષિ ડ્રોન પાઇલટ, ઇલેક્ટ્રિશિયન, સિવિલ એન્જિનિયર...';

  @override
  String get btnNext => 'ચાલુ રાખો';

  @override
  String get btnBack => 'પાછળ';

  @override
  String get btnFinish => 'પ્રોફાઇલ પૂર્ણ કરો';

  @override
  String get saving => 'તમારી પ્રોફાઇલ સાચવાઈ રહી છે...';

  @override
  String greeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'પ્રોફાઇલ પૂર્ણતા';

  @override
  String get dashboardMatchedOpps => 'મેળવેલી તકો';

  @override
  String get dashboardActiveDeadlines => 'Deadlines Approaching';

  @override
  String get topOpportunitiesTitle => 'તમારા માટેની શ્રેષ્ઠ તકો';

  @override
  String get viewAll => 'બધી જુઓ';

  @override
  String socialProofDistrict(int count) {
    return '$count students in your district applied this week';
  }

  @override
  String get searchHint => 'શિષ્યવૃત્તિ, અભ્યાસક્રમ, પરીક્ષા શોધો...';

  @override
  String get filterAll => 'બધું';

  @override
  String get filterScholarships => 'શિષ્યવૃત્તિ';

  @override
  String get filterCourses => 'અભ્યાસક્રમો';

  @override
  String get filterExams => 'પરીક્ષાઓ';

  @override
  String get filterInternships => 'ઇન્ટર્નશિપ';

  @override
  String get filterEligibleOnly => 'માત્ર પાત્ર';

  @override
  String get resetFilters => 'ફિલ્ટર રીસેટ કરો';

  @override
  String get eligibleBadge => 'પાત્ર';

  @override
  String get notEligibleBadge => 'માપદંડ જુઓ';

  @override
  String rulesPassed(int passed, int total) {
    return '$passed of $total criteria met';
  }

  @override
  String get eligibilityReasoningTitle => 'પાત્રતાની વિગતો';

  @override
  String get applyNow => 'સત્તાવાર પોર્ટલ પર અરજી કરો';

  @override
  String get noOpportunitiesFound => 'મેળ ખાતી કોઈ તક મળી નથી.';

  @override
  String get assistantTitle => 'એઆઈ કારકિર્દી માર્ગદર્શક';

  @override
  String get assistantSubtitle => 'તમારી યાત્રા માટે વ્યક્તિગત સલાહ';

  @override
  String get chatInputHint => 'કારકિર્દી અથવા શિષ્યવૃત્તિ વિશે પૂછો...';

  @override
  String get send => 'મોકલો';

  @override
  String get editProfile => 'પ્રોફાઇલ સંપાદિત કરો';

  @override
  String get addSkill => 'કુશળતા ઉમેરો';

  @override
  String get addInterest => 'રસ ઉમેરો';

  @override
  String get saveChanges => 'ફેરફારો સાચવો';
}
