// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'ड्रीमकॅचर';

  @override
  String get tagline => 'पायरी पायरीने तुमचे भविष्य शोधा';

  @override
  String get navDashboard => 'मुख्यपृष्ठ';

  @override
  String get navOpportunities => 'संधी';

  @override
  String get navChat => 'सहाय्यक';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get onboardingWelcome => 'तुमच्या भविष्याची वाटचाल सुरू करूया';

  @override
  String get onboardingSubtitle =>
      'तुमच्याबद्दल थोडी माहिती द्या, म्हणजे आम्ही तुमच्यासाठी योग्य शिष्यवृत्ती, अभ्यासक्रम, परीक्षा आणि नोकऱ्या शोधू शकू.';

  @override
  String get stepBasic => 'मूलभूत माहिती';

  @override
  String get stepLocation => 'ठिकाण व पार्श्वभूमी';

  @override
  String get stepEducation => 'शिक्षण व कौशल्ये';

  @override
  String get stepAspirations => 'तुमची ध्येये';

  @override
  String get fullNameLabel => 'पूर्ण नाव';

  @override
  String get fullNameHint => 'उदा. आरव शर्मा';

  @override
  String get phoneLabel => 'फोन नंबर';

  @override
  String get phoneHint => 'उदा. +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'प्राधान्य भाषा';

  @override
  String get selectLanguage => 'तुमची भाषा निवडा';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get districtLabel => 'जिल्हा';

  @override
  String get areaTypeLabel => 'क्षेत्राचा प्रकार';

  @override
  String get rural => 'ग्रामीण';

  @override
  String get urban => 'शहरी';

  @override
  String get semiUrban => 'निमशहरी';

  @override
  String get casteCategoryLabel => 'सामाजिक प्रवर्ग';

  @override
  String get incomeBracketLabel => 'वार्षिक कौटुंबिक उत्पन्न';

  @override
  String get educationLevelLabel => 'सर्वोच्च शिक्षण पातळी';

  @override
  String get informalLearningLabel =>
      'What have you learned? (Practical/Informal)';

  @override
  String get informalLearningHint =>
      'e.g. Repaired solar pumps, assisted in pharmacy, farm bookkeeping...';

  @override
  String get skillsTitle => 'तुमची कौशल्ये';

  @override
  String get interestsTitle => 'तुम्हाला आवडणारी क्षेत्रे';

  @override
  String get aspirationLabel =>
      'तुमची स्वप्नातील नोकरी किंवा महत्त्वाकांक्षा काय आहे?';

  @override
  String get aspirationHint =>
      'उदा. कृषी ड्रोन पायलट, इलेक्ट्रिशियन, स्थापत्य अभियंता...';

  @override
  String get btnNext => 'पुढे चला';

  @override
  String get btnBack => 'मागे';

  @override
  String get btnFinish => 'प्रोफाइल पूर्ण करा';

  @override
  String get saving => 'तुमचे प्रोफाइल जतन होत आहे...';

  @override
  String greeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'प्रोफाइल पूर्णता';

  @override
  String get dashboardMatchedOpps => 'जुळलेल्या संधी';

  @override
  String get dashboardActiveDeadlines => 'Deadlines Approaching';

  @override
  String get topOpportunitiesTitle => 'तुमच्यासाठी उत्तम संधी';

  @override
  String get viewAll => 'सर्व पहा';

  @override
  String socialProofDistrict(int count) {
    return '$count students in your district applied this week';
  }

  @override
  String get searchHint => 'शिष्यवृत्ती, अभ्यासक्रम, परीक्षा शोधा...';

  @override
  String get filterAll => 'सर्व';

  @override
  String get filterScholarships => 'शिष्यवृत्ती';

  @override
  String get filterCourses => 'अभ्यासक्रम';

  @override
  String get filterExams => 'परीक्षा';

  @override
  String get filterInternships => 'इंटर्नशिप';

  @override
  String get filterEligibleOnly => 'फक्त पात्र';

  @override
  String get resetFilters => 'फिल्टर रीसेट करा';

  @override
  String get eligibleBadge => 'पात्र';

  @override
  String get notEligibleBadge => 'निकष तपासा';

  @override
  String rulesPassed(int passed, int total) {
    return '$passed of $total criteria met';
  }

  @override
  String get eligibilityReasoningTitle => 'पात्रतेचा तपशील';

  @override
  String get applyNow => 'अधिकृत पोर्टलवर अर्ज करा';

  @override
  String get noOpportunitiesFound => 'जुळणाऱ्या संधी सापडल्या नाहीत.';

  @override
  String get assistantTitle => 'एआय करिअर मार्गदर्शक';

  @override
  String get assistantSubtitle => 'तुमच्या वाटचालीसाठी वैयक्तिक सल्ला';

  @override
  String get chatInputHint => 'करिअर किंवा शिष्यवृत्तीबद्दल विचारा...';

  @override
  String get send => 'पाठवा';

  @override
  String get editProfile => 'प्रोफाइल संपादित करा';

  @override
  String get addSkill => 'कौशल्य जोडा';

  @override
  String get addInterest => 'आवड जोडा';

  @override
  String get saveChanges => 'बदल जतन करा';
}
