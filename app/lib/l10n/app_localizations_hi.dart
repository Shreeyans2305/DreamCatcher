// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'ड्रीमकैचर';

  @override
  String get tagline => 'अपने भविष्य की राह खोजें, कदम दर कदम';

  @override
  String get navDashboard => 'होम';

  @override
  String get navOpportunities => 'अवसर';

  @override
  String get navChat => 'सहायक';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get onboardingWelcome => 'आइए अपनी राह बनाएं';

  @override
  String get onboardingSubtitle =>
      'अपने बारे में थोड़ा बताएं ताकि हम आपके लिए सही छात्रवृत्तियां, पाठ्यक्रम और परीक्षाएं ढूंढ सकें।';

  @override
  String get stepBasic => 'बुनियादी जानकारी';

  @override
  String get stepLocation => 'स्थान व पृष्ठभूमि';

  @override
  String get stepEducation => 'शिक्षा व हुनर';

  @override
  String get stepAspirations => 'आपके लक्ष्य';

  @override
  String get fullNameLabel => 'पूरा नाम';

  @override
  String get fullNameHint => 'जैसे: आरव शर्मा';

  @override
  String get phoneLabel => 'फ़ोन नंबर';

  @override
  String get phoneHint => 'जैसे: +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'पसंदीदा भाषा';

  @override
  String get selectLanguage => 'अपनी भाषा चुनें';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get districtLabel => 'ज़िला';

  @override
  String get areaTypeLabel => 'क्षेत्र प्रकार';

  @override
  String get rural => 'ग्रामीण';

  @override
  String get urban => 'शहरी';

  @override
  String get semiUrban => 'अर्ध-शहरी';

  @override
  String get casteCategoryLabel => 'सामाजिक श्रेणी';

  @override
  String get incomeBracketLabel => 'वार्षिक पारिवारिक आय';

  @override
  String get educationLevelLabel => 'उच्चतम शिक्षा स्तर';

  @override
  String get informalLearningLabel =>
      'आपने क्या सीखा है? (व्यावहारिक/अनौपचारिक)';

  @override
  String get informalLearningHint =>
      'जैसे: सौर पंप ठीक करना, दवाई दुकान में सहयोग, खेती का हिसाब...';

  @override
  String get skillsTitle => 'आपके हुनर (Skills)';

  @override
  String get interestsTitle => 'पसंदीदा क्षेत्र (Interests)';

  @override
  String get aspirationLabel => 'आपका सपना या लक्ष्य क्या है?';

  @override
  String get aspirationHint =>
      'जैसे: कृषि ड्रोन पायलट, इलेक्ट्रीशियन, सिविल इंजीनियर...';

  @override
  String get btnNext => 'आगे बढ़ें';

  @override
  String get btnBack => 'पीछे';

  @override
  String get btnFinish => 'प्रोफ़ाइल पूरी करें';

  @override
  String get saving => 'प्रोफ़ाइल सहेजी जा रही है...';

  @override
  String greeting(String name) {
    return 'नमस्ते, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'प्रोफ़ाइल पूर्णता';

  @override
  String get dashboardMatchedOpps => 'आपके लिए सुझाये अवसर';

  @override
  String get dashboardActiveDeadlines => 'नज़दीकी अंतिम तिथियां';

  @override
  String get topOpportunitiesTitle => 'आपके लिए प्रमुख अवसर';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String socialProofDistrict(int count) {
    return 'आपके ज़िले के $count छात्रों ने इस सप्ताह आवेदन किया';
  }

  @override
  String get searchHint => 'छात्रवृत्तियां, कोर्स, परीक्षाएं खोजें...';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterScholarships => 'छात्रवृत्तियां';

  @override
  String get filterCourses => 'पाठ्यक्रम';

  @override
  String get filterExams => 'प्रवेश परीक्षाएं';

  @override
  String get filterInternships => 'इंटर्नशिप';

  @override
  String get filterEligibleOnly => 'केवल पात्र';

  @override
  String get eligibleBadge => 'पात्र (Eligible)';

  @override
  String get notEligibleBadge => 'पात्रता जांचें';

  @override
  String rulesPassed(int passed, int total) {
    return '$total में से $passed शर्तें पूरी हुईं';
  }

  @override
  String get eligibilityReasoningTitle => 'पात्रता विवरण';

  @override
  String get applyNow => 'आधिकारिक पोर्टल पर आवेदन करें';

  @override
  String get noOpportunitiesFound =>
      'कोई अवसर नहीं मिला। फ़िल्टर बदल कर देखें।';

  @override
  String get assistantTitle => 'एआई करियर मार्गदर्शक';

  @override
  String get assistantSubtitle => 'आपकी राह के लिए व्यक्तिगत सलाह';

  @override
  String get chatInputHint =>
      'करियर या छात्रवृत्ति के बारे में कुछ भी पूछें...';

  @override
  String get send => 'भेजें';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get addSkill => 'नया हुनर जोड़ें';

  @override
  String get addInterest => 'नयी रुचि जोड़ें';

  @override
  String get saveChanges => 'बदलाव सहेजें';
}
