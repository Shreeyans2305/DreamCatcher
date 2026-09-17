// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ட்ரீம்கேட்சர்';

  @override
  String get tagline => 'உங்கள் எதிர்காலத்தை படிப்படியாகக் கண்டறியுங்கள்';

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
      'உங்களுக்கான உதவித்தொகைகள், படிப்புகள், தேர்வுகள் மற்றும் வேலைகளைக் கண்டறிய உங்களைப் பற்றி சிறிதளவு கூறுங்கள்.';

  @override
  String get stepBasic => 'அடிப்படை விவரங்கள்';

  @override
  String get stepLocation => 'இருப்பிடம் மற்றும் பின்னணி';

  @override
  String get stepEducation => 'கல்வி மற்றும் திறன்கள்';

  @override
  String get stepAspirations => 'உங்கள் இலக்குகள்';

  @override
  String get fullNameLabel => 'முழுப் பெயர்';

  @override
  String get fullNameHint => 'எ.கா. ஆரವ್ சர்மா';

  @override
  String get phoneLabel => 'தொலைபேசி எண்';

  @override
  String get phoneHint => 'எ.கா. +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'விருப்பமான மொழி';

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
      'நீங்கள் என்ன கற்றுக் கொண்டீர்கள்? (நடைமுறை/முறைசாரா)';

  @override
  String get informalLearningHint =>
      'எ.கா. சோலார் பம்ப் பழுதுபார்த்தல், மருந்தகத்தில் உதவி, பண்ணைக் கணக்கு...';

  @override
  String get skillsTitle => 'உங்கள் திறன்கள் (Skills)';

  @override
  String get interestsTitle => 'விருப்பமான துறைகள் (Interests)';

  @override
  String get aspirationLabel => 'உங்கள் கனவு வேலை அல்லது லட்சியம் என்ன?';

  @override
  String get aspirationHint =>
      'எ.கா. விவசாய ட்ரோன் பைலட், எலக்ட்ரீஷியன், சிவில் இன்ஜினியர்...';

  @override
  String get btnNext => 'தொடரவும்';

  @override
  String get btnBack => 'பின்செல்';

  @override
  String get btnFinish => 'சுயவிவரத்தை முடிக்கவும்';

  @override
  String get saving => 'சுயவிவரம் சேமிக்கப்படுகிறது...';

  @override
  String greeting(String name) {
    return 'வணக்கம், $name 👋';
  }

  @override
  String get dashboardCompleteness => 'சுயவிவர நிறைவு';

  @override
  String get dashboardMatchedOpps => 'பொருந்திய வாய்ப்புகள்';

  @override
  String get dashboardActiveDeadlines => 'அடுத்து வரும் கடைசி தேதிகள்';

  @override
  String get topOpportunitiesTitle => 'உங்களுக்கான சிறந்த வாய்ப்புகள்';

  @override
  String get viewAll => 'அனைத்தையும் காண்க';

  @override
  String socialProofDistrict(int count) {
    return 'உங்கள் மாவட்டத்தைச் சேர்ந்த $count மாணவர்கள் இந்த வாரம் விண்ணப்பித்தனர்';
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
  String get filterExams => 'நுழைவுத் தேர்வுகள்';

  @override
  String get filterInternships => 'பயிற்சிப் பணி (Internship)';

  @override
  String get filterEligibleOnly => 'தகுதியானவை மட்டும்';

  @override
  String get resetFilters => 'வடிகட்டிகளை மீட்டமை';

  @override
  String get eligibleBadge => 'தகுதியானது (Eligible)';

  @override
  String get notEligibleBadge => 'தகுதியைச் சரிபார்க்கவும்';

  @override
  String rulesPassed(int passed, int total) {
    return '$total இல் $passed நிபந்தனைகள் பூர்த்தி செய்யப்பட்டுள்ளன';
  }

  @override
  String get eligibilityReasoningTitle => 'தகுதி விவரங்கள்';

  @override
  String get applyNow => 'அதிகாரப்பூர்வ தளத்தில் விண்ணப்பிக்கவும்';

  @override
  String get noOpportunitiesFound =>
      'பொருத்தமான வாய்ப்புகள் எதுவும் கிடைக்கவில்லை. வடிகட்டிகளை மாற்றி முயற்சிக்கவும்.';

  @override
  String get assistantTitle => 'AI தொழில் வழிகாட்டி';

  @override
  String get assistantSubtitle =>
      'உங்கள் பயணத்திற்கான தனிப்பயனாக்கப்பட்ட ஆலோசனை';

  @override
  String get chatInputHint =>
      'தொழில் அல்லது உதவித்தொகை பற்றி ஏதேனும் கேளுங்கள்...';

  @override
  String get send => 'அனுப்பு';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get addSkill => 'திறனைச் சேர்க்கவும்';

  @override
  String get addInterest => 'ஆர்வத்தைச் சேர்க்கவும்';

  @override
  String get saveChanges => 'மாற்றங்களைச் சேமிக்கவும்';

  @override
  String opportunitiesAvailable(int count) {
    return '$count வாய்ப்புகள் உள்ளன';
  }

  @override
  String get opportunityTypeScholarship => 'உதவித்தொகை';

  @override
  String get opportunityTypeCourse => 'தொழிற்கல்வி படிப்பு';

  @override
  String get opportunityTypeExam => 'நுழைவுத் தேர்வு';

  @override
  String get opportunityTypeInternship => 'பயிற்சிப் பணி / பெல்லோஷிப்';

  @override
  String get opportunityTypeGeneral => 'வாய்ப்பு';

  @override
  String get openToAllCriteria =>
      'அடிப்படை தகுதிகளை பூர்த்தி செய்யும் அனைத்து மாணவர்களுக்கும் திறக்கப்பட்டுள்ளது';

  @override
  String get noMatchingOpportunities =>
      'பொருத்தமான வாய்ப்புகள் எதுவும் கிடைக்கவில்லை';

  @override
  String get noMatchingOpportunitiesSubtitle =>
      'தேடலை மாற்றவும் அல்லது \'தகுதியானவை மட்டும்\' வடிகட்டியை நீக்கவும்.';

  @override
  String officialPortalOpening(String url) {
    return 'அதிகாரப்பூர்வ தளம் திறக்கப்படுகிறது: $url';
  }

  @override
  String get statFinancialBenefit => 'நிதிப் பலன்';

  @override
  String get statKeyDetails => 'முக்கிய விவரங்கள்';

  @override
  String get opportunityAbout => 'இந்த வாய்ப்பைப் பற்றி';

  @override
  String yourProfileValue(String value) {
    return 'உங்கள் சுயவிவரம்: $value';
  }

  @override
  String get openToAllGeneral =>
      'பொதுத் தகுதிகளைப் பூர்த்தி செய்யும் அனைத்து மாணவர்களுக்கும் கிடைக்கும்.';

  @override
  String get locationNotSet => 'இருப்பிடம் அமைக்கப்படவில்லை';

  @override
  String get demographicsTitle => 'மக்கள்தொகை மற்றும் இடஒதுக்கீடு ஒதுக்கீடு';

  @override
  String get socialCategoryLabel => 'சமூகப் பிரிவு மற்றும் சாதி';

  @override
  String get tribeLabel => 'பழங்குடியின தொடர்பு';

  @override
  String get annualIncomeLabel => 'ஆண்டு குடும்ப வருமானம்';

  @override
  String get areaClassificationLabel => 'பகுதி வகைப்பாடு';

  @override
  String get educationSectionTitle => 'கல்வி மற்றும் கற்றல்';

  @override
  String skillsSectionTitle(int count) {
    return 'திறன்கள் ($count)';
  }

  @override
  String interestsSectionTitle(int count) {
    return 'விருப்பமான துறைகள் ($count)';
  }

  @override
  String get careerAspirationTitle => 'தொழில் இலக்கு / கனவு';

  @override
  String get btnUpdate => 'புதுப்பிக்கவும்';

  @override
  String get btnAddSkill => '+ திறனைச் சேர்க்கவும்';

  @override
  String get btnAddInterest => '+ ஆர்வத்தைச் சேர்க்கவும்';

  @override
  String get btnSwitchProfile => 'சுயவிவரத்தை மாற்றவும் / மீட்டமைக்கவும்';

  @override
  String get noneSpecified => 'குறிப்பிடப்படவில்லை';

  @override
  String get nilIncome => '₹0 (வருமானம் இல்லை / ₹25,000 க்கும் குறைவு)';

  @override
  String underIncome(String amount) {
    return '₹$amount (₹25,000 க்கும் குறைவு)';
  }

  @override
  String perYearIncome(String amount) {
    return '₹$amount / ஆண்டு';
  }

  @override
  String get noEducationDescription =>
      'இதுவரை எந்த நடைமுறை அனுபவமும் சேர்க்கப்படவில்லை.';

  @override
  String get noSkillsAdded =>
      'திறன்கள் எதுவும் சேர்க்கப்படவில்லை. பட்டியலிலிருந்து சேர்க்க \'+ திறனைச் சேர்க்கவும்\' என்பதைத் தட்டவும்.';

  @override
  String get noInterestsAdded =>
      'ஆர்வங்கள் எதுவும் சேர்க்கப்படவில்லை. துறையைத் தேர்ந்தெடுக்க \'+ ஆர்வத்தைச் சேர்க்கவும்\' என்பதைத் தட்டவும்.';

  @override
  String get noAspirationAdded => 'இலக்கு எதுவும் இன்னும் சேர்க்கப்படவில்லை.';

  @override
  String get qualifiesFullWaiver =>
      '✓ 100% முழு கல்விக் கட்டண விலக்கு மற்றும் அதிகபட்ச உதவித்தொகைக்கு தகுதியுடையவர்.';

  @override
  String get dialogAddSkillTitle => 'புதிய திறனைச் சேர்க்கவும்';

  @override
  String get dialogAllSkillsAdded =>
      'பட்டியலில் உள்ள அனைத்துத் திறன்களும் ஏற்கனவே சேர்க்கப்பட்டுள்ளன!';

  @override
  String get dialogAddInterestTitle => 'விருப்பத் துறையைச் சேர்க்கவும்';

  @override
  String get dialogAllInterestsAdded =>
      'கிடைக்கக்கூடிய அனைத்து விருப்பங்களும் ஏற்கனவே சேர்க்கப்பட்டுள்ளன!';

  @override
  String get dialogUpdateEducationTitle =>
      'கல்வி மற்றும் நடைமுறை அறிவைப் புதுப்பிக்கவும்';

  @override
  String get dialogEduLevelLabel => 'கல்வி நிலை';

  @override
  String get dialogEduDescLabel => 'நடைமுறை / முறைசாரா கற்றல் விவரம்';

  @override
  String get dialogEduDescHint =>
      'நீங்கள் நடைமுறையில் என்ன வேலை கற்றுக்கொண்டீர்கள்?';

  @override
  String get dialogAspirationTitle => 'உங்கள் தொழில் இலக்கு / லட்சியம்';

  @override
  String get dialogAspirationHint =>
      'எ.கா. விவசாய ட்ரோன் பைலட், மின் ஒப்பந்ததாரர்...';

  @override
  String get dialogDemographicsTitle =>
      'மக்கள்தொகை மற்றும் ஒதுக்கீட்டைப் புதுப்பிக்கவும்';

  @override
  String get dialogCasteQuotaLabel => 'சமூகப் பிரிவு / சாதி ஒதுக்கீடு';

  @override
  String get dialogTribeLabel => 'பழங்குடி / சமூகம் (விருப்பத்தேர்வு)';

  @override
  String get dialogTribeSubtitle =>
      'பழங்குடியினர் விவகார அமைச்சகத்தின் (MoTA) மற்றும் PVTG சிறப்புத் திட்டங்களைத் திறக்கிறது.';

  @override
  String get dialogTribeCustomHint =>
      'அல்லது உங்கள் பழங்குடி / PVTG பெயரை உள்ளிடவும்...';

  @override
  String get dialogIncomeLabel => 'குடும்ப வருமானம்';

  @override
  String get btnCancel => 'ரத்துசெய்';

  @override
  String get btnSave => 'சேமி';

  @override
  String snackbarSkillAdded(String name) {
    return 'திறன் சேர்க்கப்பட்டது: $name';
  }

  @override
  String snackbarInterestAdded(String name) {
    return 'ஆர்வப் பிரிவு சேர்க்கப்பட்டது: $name';
  }

  @override
  String get snackbarEducationUpdated =>
      'கல்வி விவரங்கள் வெற்றிகரமாகப் புதுப்பிக்கப்பட்டன!';

  @override
  String get snackbarAspirationUpdated => 'தொழில் இலக்கு புதுப்பிக்கப்பட்டது!';

  @override
  String get snackbarDemographicsUpdated =>
      'மக்கள்தொகை மற்றும் ஒதுக்கீடு தகுதி புதுப்பிக்கப்பட்டது!';

  @override
  String snackbarError(String error) {
    return 'பிழை: $error';
  }

  @override
  String get eduPrimary => 'தொடக்கப் பள்ளி (5 ஆம் வகுப்பு வரை)';

  @override
  String get eduUpperPrimary => 'நடுநிலைப் பள்ளி (6 - 8 ஆம் வகுப்பு)';

  @override
  String get eduSecondary => '10 ஆம் வகுப்பு தேர்ச்சி (உயர்நிலை)';

  @override
  String get eduSeniorSecondary => '12 ஆம் வகுப்பு தேர்ச்சி (மேல்நிலை)';

  @override
  String get eduDiploma => 'டிப்ளமோ / பாலிடெக்னிக்';

  @override
  String get eduVocational => 'தொழிற்பயிற்சி / ITI';

  @override
  String get eduBachelor => 'இளங்கலை பட்டம் (Bachelor\'s)';

  @override
  String get eduMaster => 'முதுகலை பட்டம் (Master\'s)';

  @override
  String get eduInformal => 'முறைசாரா / நடைமுறைக் கற்றல்';

  @override
  String get eduSelfLearning => 'சுய கற்றல் (Self-Taught)';

  @override
  String get eduOther => 'மற்றவை';

  @override
  String get catGeneral => 'பொதுப் பிரிவு (General)';

  @override
  String get catOBC => 'இதர பிற்படுத்தப்பட்ட வகுப்பினர் (OBC)';

  @override
  String get catSC => 'பட்டியலின சாதியினர் (SC)';

  @override
  String get catST => 'பட்டியலின பழங்குடியினர் (ST)';

  @override
  String get catEWS => 'பொருளாதாரத்தில் பின்தங்கியோர் (EWS)';
}
