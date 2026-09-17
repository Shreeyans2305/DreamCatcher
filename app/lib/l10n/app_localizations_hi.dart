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
  String get dashboardMatchedOpps => 'सुझाये गए अवसर';

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
  String get resetFilters => 'फ़िल्टर रीसेट करें';

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

  @override
  String opportunitiesAvailable(int count) {
    return '$count अवसर उपलब्ध';
  }

  @override
  String get opportunityTypeScholarship => 'छात्रवृत्ति';

  @override
  String get opportunityTypeCourse => 'व्यावसायिक पाठ्यक्रम';

  @override
  String get opportunityTypeExam => 'प्रवेश परीक्षा';

  @override
  String get opportunityTypeInternship => 'इंटर्नशिप / फेलोशिप';

  @override
  String get opportunityTypeGeneral => 'अवसर';

  @override
  String get openToAllCriteria =>
      'बुनियादी शर्तें पूरी करने वाले सभी उम्मीदवारों के लिए खुला';

  @override
  String get noMatchingOpportunities => 'कोई अवसर नहीं मिला';

  @override
  String get noMatchingOpportunitiesSubtitle =>
      'अपनी खोज बदलें या \'केवल पात्र\' फ़िल्टर हटाएं।';

  @override
  String officialPortalOpening(String url) {
    return 'आधिकारिक पोर्टल खोला जा रहा है: $url';
  }

  @override
  String get statFinancialBenefit => 'वित्तीय लाभ';

  @override
  String get statKeyDetails => 'मुख्य विवरण';

  @override
  String get opportunityAbout => 'इस अवसर के बारे में';

  @override
  String yourProfileValue(String value) {
    return 'आपकी प्रोफ़ाइल: $value';
  }

  @override
  String get openToAllGeneral =>
      'सामान्य योग्यता पूरी करने वाले सभी छात्रों के लिए उपलब्ध।';

  @override
  String get locationNotSet => 'स्थान निर्धारित नहीं है';

  @override
  String get demographicsTitle => 'जनसांख्यिकी और आरक्षण कोटा';

  @override
  String get socialCategoryLabel => 'सामाजिक श्रेणी व जाति';

  @override
  String get tribeLabel => 'जनजाति संबंध';

  @override
  String get annualIncomeLabel => 'वार्षिक पारिवारिक आय';

  @override
  String get areaClassificationLabel => 'क्षेत्र वर्गीकरण';

  @override
  String get educationSectionTitle => 'शिक्षा और शिक्षण';

  @override
  String skillsSectionTitle(int count) {
    return 'हुनर व कौशल ($count)';
  }

  @override
  String interestsSectionTitle(int count) {
    return 'पसंदीदा क्षेत्र ($count)';
  }

  @override
  String get careerAspirationTitle => 'करियर लक्ष्य व महत्वाकांक्षा';

  @override
  String get btnUpdate => 'अपडेट करें';

  @override
  String get btnAddSkill => '+ हुनर जोड़ें';

  @override
  String get btnAddInterest => '+ रुचि जोड़ें';

  @override
  String get btnSwitchProfile => 'प्रोफ़ाइल बदलें / रीसेट करें';

  @override
  String get noneSpecified => 'कोई निर्दिष्ट नहीं';

  @override
  String get nilIncome => '₹0 (शून्य आय / ₹25,000 से कम)';

  @override
  String underIncome(String amount) {
    return '₹$amount (₹25,000 से कम)';
  }

  @override
  String perYearIncome(String amount) {
    return '₹$amount / वर्ष';
  }

  @override
  String get noEducationDescription =>
      'अभी तक कोई व्यावहारिक अनुभव नहीं जोड़ा गया है।';

  @override
  String get noSkillsAdded =>
      'अभी तक कोई हुनर नहीं जोड़ा गया। सूची से हुनर जोड़ने के लिए \'+ हुनर जोड़ें\' पर टैप करें।';

  @override
  String get noInterestsAdded =>
      'अभी तक कोई रुचि नहीं जोड़ी गई। अपने पसंदीदा क्षेत्र चुनने के लिए \'+ रुचि जोड़ें\' पर टैप करें।';

  @override
  String get noAspirationAdded => 'अभी तक कोई लक्ष्य नहीं जोड़ा गया है।';

  @override
  String get qualifiesFullWaiver =>
      '✓ 100% पूर्ण शुल्क छूट और अधिकतम छात्रवृत्ति के लिए पात्र।';

  @override
  String get dialogAddSkillTitle => 'नया हुनर जोड़ें';

  @override
  String get dialogAllSkillsAdded =>
      'कैटलॉग के सभी हुनर पहले से जुड़े हुए हैं!';

  @override
  String get dialogAddInterestTitle => 'रुचि का क्षेत्र जोड़ें';

  @override
  String get dialogAllInterestsAdded =>
      'सभी उपलब्ध रुचियां पहले से जुड़ी हुई हैं!';

  @override
  String get dialogUpdateEducationTitle =>
      'शिक्षा व व्यावहारिक ज्ञान अपडेट करें';

  @override
  String get dialogEduLevelLabel => 'शिक्षा का स्तर';

  @override
  String get dialogEduDescLabel => 'व्यावहारिक / अनौपचारिक सीख का विवरण';

  @override
  String get dialogEduDescHint => 'आपने व्यावहारिक रूप से क्या काम सीखा है?';

  @override
  String get dialogAspirationTitle => 'आपका करियर लक्ष्य / महत्वाकांक्षा';

  @override
  String get dialogAspirationHint =>
      'जैसे: कृषि ड्रोन पायलट, इलेक्ट्रीशियन ठेकेदार...';

  @override
  String get dialogDemographicsTitle => 'जनसांख्यिकी व कोटा अपडेट करें';

  @override
  String get dialogCasteQuotaLabel => 'सामाजिक श्रेणी / जाति कोटा';

  @override
  String get dialogTribeLabel => 'जनजाति / समुदाय (वैकल्पिक)';

  @override
  String get dialogTribeSubtitle =>
      'जनजातीय कार्य मंत्रालय (MoTA) और PVTG विशेष योजनाओं को सक्षम करता है।';

  @override
  String get dialogTribeCustomHint => 'या अपनी जनजाति / PVTG का नाम लिखें...';

  @override
  String get dialogIncomeLabel => 'पारिवारिक आय';

  @override
  String get btnCancel => 'रद्द करें';

  @override
  String get btnSave => 'सहेजें';

  @override
  String snackbarSkillAdded(String name) {
    return 'हुनर जोड़ा गया: $name';
  }

  @override
  String snackbarInterestAdded(String name) {
    return 'रुचि जोड़ी गई: $name';
  }

  @override
  String get snackbarEducationUpdated =>
      'शिक्षा विवरण सफलतापूर्वक अपडेट किया गया!';

  @override
  String get snackbarAspirationUpdated => 'करियर लक्ष्य अपडेट किया गया!';

  @override
  String get snackbarDemographicsUpdated =>
      'जनसांख्यिकी और कोटा पात्रता अपडेट की गई!';

  @override
  String snackbarError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get eduPrimary => 'प्राथमिक विद्यालय (5वीं तक)';

  @override
  String get eduUpperPrimary => 'उच्च प्राथमिक (6वीं - 8वीं)';

  @override
  String get eduSecondary => '10वीं उत्तीर्ण (माध्यमिक)';

  @override
  String get eduSeniorSecondary => '12वीं उत्तीर्ण (उच्च माध्यमिक)';

  @override
  String get eduDiploma => 'डिप्लोमा / पॉलिटेक्निक';

  @override
  String get eduVocational => 'व्यावसायिक प्रशिक्षण / ITI';

  @override
  String get eduBachelor => 'स्नातक डिग्री (Bachelor\'s)';

  @override
  String get eduMaster => 'स्नातकोत्तर डिग्री (Master\'s)';

  @override
  String get eduInformal => 'अनौपचारिक / व्यावहारिक सीख';

  @override
  String get eduSelfLearning => 'स्व-शिक्षित (Self-Taught)';

  @override
  String get eduOther => 'अन्य';

  @override
  String get catGeneral => 'सामान्य (General)';

  @override
  String get catOBC => 'अन्य पिछड़ा वर्ग (OBC)';

  @override
  String get catSC => 'अनुसूचित जाति (SC)';

  @override
  String get catST => 'अनुसूचित जनजाति (ST)';

  @override
  String get catEWS => 'आर्थिक रूप से कमजोर (EWS)';
}
