// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'డ్రీమ్‌క్యాచర్';

  @override
  String get tagline => 'అడుగు అడుగునా మీ భవిష్యత్తును కనుగొనండి';

  @override
  String get navDashboard => 'హోమ్';

  @override
  String get navOpportunities => 'అవకాశాలు';

  @override
  String get navChat => 'సహాయకుడు';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get onboardingWelcome => 'మీ భవిష్యత్తు మార్గాన్ని నిర్మిద్దాం';

  @override
  String get onboardingSubtitle =>
      'మీ గురించి కొంత చెప్పండి; మీకు సరైన స్కాలర్‌షిప్‌లు, కోర్సులు, పరీక్షలు మరియు ఉద్యోగాలను కనుగొనడంలో సహాయపడతాం.';

  @override
  String get stepBasic => 'ప్రాథమిక సమాచారం';

  @override
  String get stepLocation => 'ప్రదేశం మరియు నేపథ్యం';

  @override
  String get stepEducation => 'విద్య మరియు నైపుణ్యాలు';

  @override
  String get stepAspirations => 'మీ లక్ష్యాలు';

  @override
  String get fullNameLabel => 'పూర్తి పేరు';

  @override
  String get fullNameHint => 'ఉదా: ఆరవ్ శర్మ';

  @override
  String get phoneLabel => 'ఫోన్ నంబర్';

  @override
  String get phoneHint => 'ఉదా: +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'ఇష్టమైన భాష';

  @override
  String get selectLanguage => 'మీ భాషను ఎంచుకోండి';

  @override
  String get stateLabel => 'రాష్ట్రం';

  @override
  String get districtLabel => 'జిల్లా';

  @override
  String get areaTypeLabel => 'ప్రాంతం రకం';

  @override
  String get rural => 'గ్రామీణ';

  @override
  String get urban => 'పట్టణ';

  @override
  String get semiUrban => 'సెమీ అర్బన్';

  @override
  String get casteCategoryLabel => 'సామాజిక వర్గం';

  @override
  String get incomeBracketLabel => 'వార్షిక కుటుంబ ఆదాయం';

  @override
  String get educationLevelLabel => 'అత్యధిక విద్యా స్థాయి';

  @override
  String get informalLearningLabel =>
      'What have you learned? (Practical/Informal)';

  @override
  String get informalLearningHint =>
      'e.g. Repaired solar pumps, assisted in pharmacy, farm bookkeeping...';

  @override
  String get skillsTitle => 'మీ నైపుణ్యాలు';

  @override
  String get interestsTitle => 'మీకు నచ్చిన రంగాలు';

  @override
  String get aspirationLabel => 'మీ కలల ఉద్యోగం లేదా ఆశయం ఏమిటి?';

  @override
  String get aspirationHint =>
      'ఉదా: వ్యవసాయ డ్రోన్ పైలట్, ఎలక్ట్రీషియన్, సివిల్ ఇంజనీర్...';

  @override
  String get btnNext => 'కొనసాగించండి';

  @override
  String get btnBack => 'వెనుకకు';

  @override
  String get btnFinish => 'ప్రొఫైల్ పూర్తి చేయండి';

  @override
  String get saving => 'మీ ప్రొఫైల్ సేవ్ అవుతోంది...';

  @override
  String greeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'ప్రొఫైల్ పూర్తి స్థాయి';

  @override
  String get dashboardMatchedOpps => 'సరిపోలిన అవకాశాలు';

  @override
  String get dashboardActiveDeadlines => 'Deadlines Approaching';

  @override
  String get topOpportunitiesTitle => 'మీ కోసం ఉత్తమ అవకాశాలు';

  @override
  String get viewAll => 'అన్నీ చూడండి';

  @override
  String socialProofDistrict(int count) {
    return '$count students in your district applied this week';
  }

  @override
  String get searchHint => 'స్కాలర్‌షిప్‌లు, కోర్సులు, పరీక్షలను వెతకండి...';

  @override
  String get filterAll => 'అన్నీ';

  @override
  String get filterScholarships => 'స్కాలర్‌షిప్‌లు';

  @override
  String get filterCourses => 'కోర్సులు';

  @override
  String get filterExams => 'పరీక్షలు';

  @override
  String get filterInternships => 'ఇంటర్న్‌షిప్‌లు';

  @override
  String get filterEligibleOnly => 'అర్హత ఉన్నవి మాత్రమే';

  @override
  String get resetFilters => 'ఫిల్టర్‌లను రీసెట్ చేయండి';

  @override
  String get eligibleBadge => 'అర్హత ఉంది';

  @override
  String get notEligibleBadge => 'నిబంధనలు చూడండి';

  @override
  String rulesPassed(int passed, int total) {
    return '$passed of $total criteria met';
  }

  @override
  String get eligibilityReasoningTitle => 'అర్హత వివరాలు';

  @override
  String get applyNow => 'అధికారిక పోర్టల్‌లో దరఖాస్తు చేయండి';

  @override
  String get noOpportunitiesFound => 'సరిపోలే అవకాశాలు ఏవీ లేవు.';

  @override
  String get assistantTitle => 'ఏఐ కెరీర్ గైడ్';

  @override
  String get assistantSubtitle => 'మీ ప్రయాణానికి వ్యక్తిగత సలహా';

  @override
  String get chatInputHint => 'కెరీర్ లేదా స్కాలర్‌షిప్‌ల గురించి అడగండి...';

  @override
  String get send => 'పంపండి';

  @override
  String get editProfile => 'ప్రొఫైల్‌ను సవరించండి';

  @override
  String get addSkill => 'నైపుణ్యాన్ని జోడించండి';

  @override
  String get addInterest => 'ఆసక్తిని జోడించండి';

  @override
  String get saveChanges => 'మార్పులను సేవ్ చేయండి';
}
