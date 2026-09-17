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
      'तुम्ही काय शिकला आहात? (व्यावहारिक/अनौपचारिक)';

  @override
  String get informalLearningHint =>
      'उदा. सौर पंप दुरुस्ती, औषध दुकानात मदत, शेतीचा हिशेब...';

  @override
  String get skillsTitle => 'तुमची कौशल्ये';

  @override
  String get interestsTitle => 'तुम्हाला आवडणारी क्षेत्रे';

  @override
  String get aspirationLabel =>
      'तुमची स्वप्नातील नोकरी किंवा महत्त्वाकांक्षा काय आहे?';

  @override
  String get aspirationHint =>
      'उदा. कृषी ड्रोन पायलट, इलेक्ट्रिशियन, सिव्हिल इंजिनिअर...';

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
    return 'नमस्कार, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'प्रोफाइल पूर्णता';

  @override
  String get dashboardMatchedOpps => 'जुळलेल्या संधी';

  @override
  String get dashboardActiveDeadlines => 'जवळ आलेल्या अंतिम मुदती';

  @override
  String get topOpportunitiesTitle => 'तुमच्यासाठी उत्तम संधी';

  @override
  String get viewAll => 'सर्व पहा';

  @override
  String socialProofDistrict(int count) {
    return 'तुमच्या जिल्ह्यातील $count विद्यार्थ्यांनी या आठवड्यात अर्ज केला';
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
  String get filterExams => 'प्रवेश परीक्षा';

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
    return '$total पैकी $passed अटी पूर्ण झाल्या';
  }

  @override
  String get eligibilityReasoningTitle => 'पात्रतेचा तपशील';

  @override
  String get applyNow => 'अधिकृत पोर्टलवर अर्ज करा';

  @override
  String get noOpportunitiesFound =>
      'जुळणाऱ्या संधी सापडल्या नाहीत. फिल्टर बदलून पहा.';

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

  @override
  String opportunitiesAvailable(int count) {
    return '$count संधी उपलब्ध आहेत';
  }

  @override
  String get opportunityTypeScholarship => 'शिष्यवृत्ती';

  @override
  String get opportunityTypeCourse => 'व्यावसायिक अभ्यासक्रम';

  @override
  String get opportunityTypeExam => 'प्रवेश परीक्षा';

  @override
  String get opportunityTypeInternship => 'इंटर्नशिप / फेलोशिप';

  @override
  String get opportunityTypeGeneral => 'संधी';

  @override
  String get openToAllCriteria =>
      'मूलभूत पात्रता पूर्ण करणाऱ्या सर्व विद्यार्थ्यांसाठी खुले';

  @override
  String get noMatchingOpportunities => 'कोणतीही जुळणारी संधी सापडली नाही';

  @override
  String get noMatchingOpportunitiesSubtitle =>
      'शोध संज्ञा बदला किंवा \'फक्त पात्र\' फिल्टर बंद करा.';

  @override
  String officialPortalOpening(String url) {
    return 'अधिकृत पोर्टल उघडत आहे: $url';
  }

  @override
  String get statFinancialBenefit => 'आर्थिक लाभ';

  @override
  String get statKeyDetails => 'महत्त्वाचा तपशील';

  @override
  String get opportunityAbout => 'या संधीबद्दल माहिती';

  @override
  String yourProfileValue(String value) {
    return 'तुमचे प्रोफाइल: $value';
  }

  @override
  String get openToAllGeneral =>
      'सामान्य पात्रता पूर्ण करणाऱ्या सर्व विद्यार्थ्यांसाठी उपलब्ध.';

  @override
  String get locationNotSet => 'स्थान सेट केलेले नाही';

  @override
  String get demographicsTitle => 'लोकसंख्याशास्त्र आणि आरक्षण कोटा';

  @override
  String get socialCategoryLabel => 'सामाजिक प्रवर्ग व जात';

  @override
  String get tribeLabel => 'आदिवासी जमात';

  @override
  String get annualIncomeLabel => 'वार्षिक कौटुंबिक उत्पन्न';

  @override
  String get areaClassificationLabel => 'क्षेत्र वर्गीकरण';

  @override
  String get educationSectionTitle => 'शिक्षण आणि शिकणे';

  @override
  String skillsSectionTitle(int count) {
    return 'कौशल्ये ($count)';
  }

  @override
  String interestsSectionTitle(int count) {
    return 'आवडणारी क्षेत्रे ($count)';
  }

  @override
  String get careerAspirationTitle => 'करिअर ध्येय / स्वप्न';

  @override
  String get btnUpdate => 'अपडेट करा';

  @override
  String get btnAddSkill => '+ कौशल्य जोडा';

  @override
  String get btnAddInterest => '+ आवड जोडा';

  @override
  String get btnSwitchProfile => 'प्रोफाइल बदला / रीसेट करा';

  @override
  String get noneSpecified => 'काहीही नमूद नाही';

  @override
  String get nilIncome => '₹0 (शून्य उत्पन्न / ₹25,000 पेक्षा कमी)';

  @override
  String underIncome(String amount) {
    return '₹$amount (₹25,000 पेक्षा कमी)';
  }

  @override
  String perYearIncome(String amount) {
    return '₹$amount / वर्ष';
  }

  @override
  String get noEducationDescription =>
      'अद्याप कोणताही व्यावहारिक अनुभव जोडलेला नाही.';

  @override
  String get noSkillsAdded =>
      'अद्याप कोणतीही कौशल्ये जोडलेली नाहीत. कॅटलॉगमधून जोडण्यासाठी \'+ कौशल्य जोडा\' वर टॅप करा.';

  @override
  String get noInterestsAdded =>
      'अद्याप कोणतीही आवड जोडलेली नाही. आवडीचे क्षेत्र निवडण्यासाठी \'+ आवड जोडा\' वर टॅप करा.';

  @override
  String get noAspirationAdded => 'अद्याप कोणतेही ध्येय जोडलेले नाही.';

  @override
  String get qualifiesFullWaiver =>
      '✓ 100% पूर्ण फी माफी आणि कमाल शिष्यवृत्तीसाठी पात्र.';

  @override
  String get dialogAddSkillTitle => 'नवीन कौशल्य जोडा';

  @override
  String get dialogAllSkillsAdded =>
      'कॅटलॉगमधील सर्व उपलब्ध कौशल्ये आधीच जोडली गेली आहेत!';

  @override
  String get dialogAddInterestTitle => 'आवडीचे क्षेत्र जोडा';

  @override
  String get dialogAllInterestsAdded =>
      'सर्व उपलब्ध आवडी आधीच जोडल्या गेल्या आहेत!';

  @override
  String get dialogUpdateEducationTitle =>
      'शिक्षण आणि व्यावहारिक माहिती अपडेट करा';

  @override
  String get dialogEduLevelLabel => 'शिक्षण पातळी';

  @override
  String get dialogEduDescLabel => 'व्यावहारिक / अनौपचारिक शिक्षणाचे वर्णन';

  @override
  String get dialogEduDescHint => 'तुम्ही प्रत्यक्ष काय काम शिकला आहात?';

  @override
  String get dialogAspirationTitle => 'तुमचे करिअर ध्येय / महत्त्वाकांक्षा';

  @override
  String get dialogAspirationHint =>
      'उदा. कृषी ड्रोन पायलट, इलेक्ट्रिकल कंत्राटदार...';

  @override
  String get dialogDemographicsTitle => 'लोकसंख्याशास्त्र आणि कोटा अपडेट करा';

  @override
  String get dialogCasteQuotaLabel => 'सामाजिक प्रवर्ग / जात कोटा';

  @override
  String get dialogTribeLabel => 'जमात / समुदाय (पर्यायी)';

  @override
  String get dialogTribeSubtitle =>
      'आदिवासी कार्य मंत्रालय (MoTA) आणि PVTG विशेष योजना अनलॉक करते.';

  @override
  String get dialogTribeCustomHint =>
      'किंवा तुमच्या जमातीचे / PVTG नाव प्रविष्ट करा...';

  @override
  String get dialogIncomeLabel => 'कौटुंबिक उत्पन्न';

  @override
  String get btnCancel => 'रद्द करा';

  @override
  String get btnSave => 'जतन करा';

  @override
  String snackbarSkillAdded(String name) {
    return 'कौशल्य जोडले: $name';
  }

  @override
  String snackbarInterestAdded(String name) {
    return 'आवड जोडली: $name';
  }

  @override
  String get snackbarEducationUpdated =>
      'शिक्षणाचा तपशील यशस्वीरित्या अपडेट केला!';

  @override
  String get snackbarAspirationUpdated => 'करिअर ध्येय अपडेट झाले!';

  @override
  String get snackbarDemographicsUpdated =>
      'लोकसंख्याशास्त्र आणि कोटा पात्रता अपडेट केली!';

  @override
  String snackbarError(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get eduPrimary => 'प्राथमिक शाळा (५ वी पर्यंत)';

  @override
  String get eduUpperPrimary => 'माध्यमिक शाळा (६ वी - ८ वी)';

  @override
  String get eduSecondary => '१० वी उत्तीर्ण (माध्यमिक)';

  @override
  String get eduSeniorSecondary => '१२ वी उत्तीर्ण (उच्च माध्यमिक)';

  @override
  String get eduDiploma => 'डिप्लोमा / पॉलिटेक्निक';

  @override
  String get eduVocational => 'व्यावसायिक / ITI';

  @override
  String get eduBachelor => 'पदवी (Bachelor\'s)';

  @override
  String get eduMaster => 'व्युत्पन्न पदवी (Master\'s)';

  @override
  String get eduInformal => 'अनौपचारिक / प्रात्यक्षिक शिक्षण';

  @override
  String get eduSelfLearning => 'स्व-अध्ययन (Self-Taught)';

  @override
  String get eduOther => 'इतर';

  @override
  String get catGeneral => 'खुला प्रवर्ग (General)';

  @override
  String get catOBC => 'इतर मागासवर्गीय (OBC)';

  @override
  String get catSC => 'अनुसूचित जाती (SC)';

  @override
  String get catST => 'अनुसूचित जमाती (ST)';

  @override
  String get catEWS => 'आर्थिक दुर्बल घटक (EWS)';
}
