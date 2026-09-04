// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ட்ரீம்கேச்சர்';

  @override
  String get tagline => 'படிப்படியாக உங்கள் எதிர்காலத்தைக் கண்டறியுங்கள்';

  @override
  String get navDashboard => 'முகப்பு';

  @override
  String get navOpportunities => 'வாய்ப்புகள்';

  @override
  String get navChat => 'உதவியாளர்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get onboardingWelcome => 'உங்கள் எதிர்காலப் பாதையை உருவாக்குவோம்';

  @override
  String get onboardingSubtitle =>
      'உங்களைப் பற்றி சிறிது கூறுங்கள்; உங்களுக்கான உதவித்தொகைகள், படிப்புகள், தேர்வுகள் மற்றும் வேலைகளைக் கண்டறிய உதவுவோம்.';

  @override
  String get stepBasic => 'அடிப்படை தகவல்';

  @override
  String get stepLocation => 'இடம் மற்றும் பின்னணி';

  @override
  String get stepEducation => 'கல்வி மற்றும் திறன்கள்';

  @override
  String get stepAspirations => 'உங்கள் இலக்குகள்';

  @override
  String get fullNameLabel => 'முழுப் பெயர்';

  @override
  String get fullNameHint => 'எ.கா: ஆரவ் சர்மா';

  @override
  String get phoneLabel => 'தொலைபேசி எண்';

  @override
  String get phoneHint => 'எ.கா: +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'விருப்ப மொழி';

  @override
  String get selectLanguage => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get stateLabel => 'மாநிலம்';

  @override
  String get districtLabel => 'மாவட்டம்';

  @override
  String get areaTypeLabel => 'பகுதி வகை';

  @override
  String get rural => 'கிராமப்புறம்';

  @override
  String get urban => 'நகர்ப்புறம்';

  @override
  String get semiUrban => 'அரை நகர்ப்புறம்';

  @override
  String get casteCategoryLabel => 'சமூகப் பிரிவு';

  @override
  String get incomeBracketLabel => 'ஆண்டு குடும்ப வருமானம்';

  @override
  String get educationLevelLabel => 'உயர்ந்த கல்வி நிலை';

  @override
  String get informalLearningLabel =>
      'What have you learned? (Practical/Informal)';

  @override
  String get informalLearningHint =>
      'e.g. Repaired solar pumps, assisted in pharmacy, farm bookkeeping...';

  @override
  String get skillsTitle => 'உங்களிடம் உள்ள திறன்கள்';

  @override
  String get interestsTitle => 'நீங்கள் விரும்பும் துறைகள்';

  @override
  String get aspirationLabel => 'உங்கள் கனவு வேலை அல்லது இலக்கு என்ன?';

  @override
  String get aspirationHint =>
      'எ.கா: வேளாண் ட்ரோன் விமானி, மின்சாரப் பணியாளர், சிவில் பொறியாளர்...';

  @override
  String get btnNext => 'தொடரவும்';

  @override
  String get btnBack => 'பின்செல்';

  @override
  String get btnFinish => 'சுயவிவரத்தை முடிக்கவும்';

  @override
  String get saving => 'உங்கள் சுயவிவரம் சேமிக்கப்படுகிறது...';

  @override
  String greeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'சுயவிவர நிறைவு';

  @override
  String get dashboardMatchedOpps => 'பொருந்திய வாய்ப்புகள்';

  @override
  String get dashboardActiveDeadlines => 'Deadlines Approaching';

  @override
  String get topOpportunitiesTitle => 'உங்களுக்கான சிறந்த வாய்ப்புகள்';

  @override
  String get viewAll => 'அனைத்தையும் காண்க';

  @override
  String socialProofDistrict(int count) {
    return '$count students in your district applied this week';
  }

  @override
  String get searchHint => 'உதவித்தொகை, படிப்புகள், தேர்வுகளைத் தேடுங்கள்...';

  @override
  String get filterAll => 'அனைத்தும்';

  @override
  String get filterScholarships => 'உதவித்தொகைகள்';

  @override
  String get filterCourses => 'படிப்புகள்';

  @override
  String get filterExams => 'தேர்வுகள்';

  @override
  String get filterInternships => 'பயிற்சிகள்';

  @override
  String get filterEligibleOnly => 'தகுதியானவை மட்டும்';

  @override
  String get resetFilters => 'வடிகட்டிகளை மீட்டமைக்கவும்';

  @override
  String get eligibleBadge => 'தகுதியானது';

  @override
  String get notEligibleBadge => 'விதிமுறைகளைப் பார்க்கவும்';

  @override
  String rulesPassed(int passed, int total) {
    return '$passed of $total criteria met';
  }

  @override
  String get eligibilityReasoningTitle => 'தகுதி விவரம்';

  @override
  String get applyNow => 'அதிகாரப்பூர்வ தளத்தில் விண்ணப்பிக்கவும்';

  @override
  String get noOpportunitiesFound => 'பொருந்தும் வாய்ப்புகள் எதுவும் இல்லை.';

  @override
  String get assistantTitle => 'ஏஐ தொழில் வழிகாட்டி';

  @override
  String get assistantSubtitle => 'உங்கள் பயணத்திற்கான தனிப்பட்ட ஆலோசனை';

  @override
  String get chatInputHint => 'தொழில் அல்லது உதவித்தொகை பற்றி கேளுங்கள்...';

  @override
  String get send => 'அனுப்புக';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்தவும்';

  @override
  String get addSkill => 'திறனைச் சேர்க்கவும்';

  @override
  String get addInterest => 'விருப்பத்தைச் சேர்க்கவும்';

  @override
  String get saveChanges => 'மாற்றங்களைச் சேமிக்கவும்';
}
