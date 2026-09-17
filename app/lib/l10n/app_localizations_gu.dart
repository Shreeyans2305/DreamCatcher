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
  String get tagline => 'તમારું ભવિષ્ય શોધો, એક પછી એક ડગલું';

  @override
  String get navDashboard => 'હોમ';

  @override
  String get navOpportunities => 'તકો';

  @override
  String get navChat => 'સહાયક';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get onboardingWelcome => 'ચાલો તમારા ભવિષ્યની રાહ બનાવીએ';

  @override
  String get onboardingSubtitle =>
      'તમારા વિશે થોડી માહિતી આપો જેથી અમે તમારા માટે યોગ્ય સ્કોલરશીપ, કોર્સ, પરીક્ષાઓ અને નોકરીઓ શોધી શકીએ.';

  @override
  String get stepBasic => 'મૂળભૂત માહિતી';

  @override
  String get stepLocation => 'સ્થળ અને પૃષ્ઠભૂમિ';

  @override
  String get stepEducation => 'શિક્ષણ અને કૌશલ્ય';

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
  String get incomeBracketLabel => 'વાર્ષિક કૌટુંબિક આવક';

  @override
  String get educationLevelLabel => 'ઉચ્ચતમ શિક્ષણ સ્તર';

  @override
  String get informalLearningLabel =>
      'તમે શું શીખ્યા છો? (પ્રાયોગિક/બિનઔપચારિક)';

  @override
  String get informalLearningHint =>
      'દા.ત. સોલર પંપ રિપેરિંગ, દવાની દુકાનમાં સહાય, ખેતીનો હિસાબ...';

  @override
  String get skillsTitle => 'તમારા કૌશલ્યો (Skills)';

  @override
  String get interestsTitle => 'પસંદગીના ક્ષેત્રો (Interests)';

  @override
  String get aspirationLabel => 'તમારી સપનાની નોકરી કે મહત્વાકાંક્ષા શું છે?';

  @override
  String get aspirationHint =>
      'દા.ત. એગ્રીકલ્ચરલ ડ્રોન પાયલટ, ઇલેક્ટ્રિશિયન, સિવિલ એન્જિનિયર...';

  @override
  String get btnNext => 'આગળ વધો';

  @override
  String get btnBack => 'પાછળ';

  @override
  String get btnFinish => 'પ્રોફાઇલ પૂર્ણ કરો';

  @override
  String get saving => 'પ્રોફાઇલ સાચવી રહ્યાં છીએ...';

  @override
  String greeting(String name) {
    return 'નમસ્તે, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'પ્રોફાઇલ પૂર્ણતા';

  @override
  String get dashboardMatchedOpps => 'મળતી આવતી તકો';

  @override
  String get dashboardActiveDeadlines => 'નજીકની અંતિમ તારીખો';

  @override
  String get topOpportunitiesTitle => 'તમારા માટે શ્રેષ્ઠ તકો';

  @override
  String get viewAll => 'બધું જુઓ';

  @override
  String socialProofDistrict(int count) {
    return 'તમારા જિલ્લાના $count વિદ્યાર્થીઓએ આ અઠવાડિયે અરજી કરી';
  }

  @override
  String get searchHint => 'સ્કોલરશીપ, કોર્સ, પરીક્ષાઓ શોધો...';

  @override
  String get filterAll => 'બધા';

  @override
  String get filterScholarships => 'સ્કોલરશીપ';

  @override
  String get filterCourses => 'કોર્સ';

  @override
  String get filterExams => 'પ્રવેશ પરીક્ષાઓ';

  @override
  String get filterInternships => 'ઇન્ટર્નશીપ';

  @override
  String get filterEligibleOnly => 'માત્ર પાત્ર';

  @override
  String get resetFilters => 'ફિલ્ટર રીસેટ કરો';

  @override
  String get eligibleBadge => 'પાત્ર (Eligible)';

  @override
  String get notEligibleBadge => 'પાત્રતા તપાસો';

  @override
  String rulesPassed(int passed, int total) {
    return '$total માંથી $passed શરતો પૂરી થઈ';
  }

  @override
  String get eligibilityReasoningTitle => 'પાત્રતાની વિગતો';

  @override
  String get applyNow => 'સત્તાવાર પોર્ટલ પર અરજી કરો';

  @override
  String get noOpportunitiesFound => 'કોઈ તક મળી નથી. ફિલ્ટર બદલીને જુઓ.';

  @override
  String get assistantTitle => 'એઆઈ કારકિર્દી માર્ગદર્શક';

  @override
  String get assistantSubtitle => 'તમારી સફર માટે અંગત સલાહ';

  @override
  String get chatInputHint => 'કારકિર્દી કે સ્કોલરશીપ વિશે કંઈ પણ પૂછો...';

  @override
  String get send => 'મોકલો';

  @override
  String get editProfile => 'પ્રોફાઇલ સંપાદિત કરો';

  @override
  String get addSkill => 'કૌશલ્ય ઉમેરો';

  @override
  String get addInterest => 'રસ ઉમેરો';

  @override
  String get saveChanges => 'ફેરફારો સાચવો';

  @override
  String opportunitiesAvailable(int count) {
    return '$count તકો ઉપલબ્ધ છે';
  }

  @override
  String get opportunityTypeScholarship => 'સ્કોલરશીપ';

  @override
  String get opportunityTypeCourse => 'વ્યાવસાયિક કોર્સ';

  @override
  String get opportunityTypeExam => 'પ્રવેશ પરીક્ષા';

  @override
  String get opportunityTypeInternship => 'ઇન્ટર્નશીપ / ફેલોશીપ';

  @override
  String get opportunityTypeGeneral => 'તક';

  @override
  String get openToAllCriteria =>
      'મૂળભૂત શરતો પૂરી કરતા તમામ ઉમેદવારો માટે ખુલ્લું';

  @override
  String get noMatchingOpportunities => 'કોઈ મેળ ખાતી તક મળી નથી';

  @override
  String get noMatchingOpportunitiesSubtitle =>
      'શોધ બદલો અથવા \'માત્ર પાત્ર\' ફિલ્ટર બંધ કરો.';

  @override
  String officialPortalOpening(String url) {
    return 'સત્તાવાર પોર્ટલ ખોલી રહ્યું છે: $url';
  }

  @override
  String get statFinancialBenefit => 'નાણાકીય લાભ';

  @override
  String get statKeyDetails => 'મુખ્ય વિગતો';

  @override
  String get opportunityAbout => 'આ તક વિશે';

  @override
  String yourProfileValue(String value) {
    return 'તમારી પ્રોફાઇલ: $value';
  }

  @override
  String get openToAllGeneral =>
      'સામાન્ય લાયકાત પૂરી કરતા તમામ વિદ્યાર્થીઓ માટે ઉપલબ્ધ.';

  @override
  String get locationNotSet => 'સ્થળ નક્કી કરેલ નથી';

  @override
  String get demographicsTitle => 'વસ્તી વિષયક અને અનામત ક્વોટા';

  @override
  String get socialCategoryLabel => 'સામાજિક શ્રેણી અને જાતિ';

  @override
  String get tribeLabel => 'જનજાતિ જોડાણ';

  @override
  String get annualIncomeLabel => 'વાર્ષિક પારિવારિક આવક';

  @override
  String get areaClassificationLabel => 'વિસ્તાર વર્ગીકરણ';

  @override
  String get educationSectionTitle => 'શિક્ષણ અને શીખવું';

  @override
  String skillsSectionTitle(int count) {
    return 'કૌશલ્યો ($count)';
  }

  @override
  String interestsSectionTitle(int count) {
    return 'પસંદગીના ક્ષેત્રો ($count)';
  }

  @override
  String get careerAspirationTitle => 'કારકિર્દી લક્ષ્ય / સ્વપ્ન';

  @override
  String get btnUpdate => 'અપડેટ કરો';

  @override
  String get btnAddSkill => '+ કૌશલ્ય ઉમેરો';

  @override
  String get btnAddInterest => '+ રસ ઉમેરો';

  @override
  String get btnSwitchProfile => 'પ્રોફાઇલ બદલો / રીસેટ કરો';

  @override
  String get noneSpecified => 'કંઈ સ્પષ્ટ નથી';

  @override
  String get nilIncome => '₹0 (શૂન્ય આવક / ₹25,000 થી ઓછી)';

  @override
  String underIncome(String amount) {
    return '₹$amount (₹25,000 થી ઓછી)';
  }

  @override
  String perYearIncome(String amount) {
    return '₹$amount / વર્ષ';
  }

  @override
  String get noEducationDescription =>
      'હજુ સુધી કોઈ વ્યવહારુ અનુભવ ઉમેરવામાં આવ્યો નથી.';

  @override
  String get noSkillsAdded =>
      'હજુ સુધી કોઈ કૌશલ્ય ઉમેરાયું નથી. યાદીમાંથી ઉમેરવા \'+ કૌશલ્ય ઉમેરો\' પર ટૅપ કરો.';

  @override
  String get noInterestsAdded =>
      'હજુ સુધી કોઈ રસ ઉમેરાયો નથી. ક્ષેત્ર પસંદ કરવા \'+ રસ ઉમેરો\' પર ટૅપ કરો.';

  @override
  String get noAspirationAdded => 'હજુ સુધી કોઈ લક્ષ્ય ઉમેરાયું નથી.';

  @override
  String get qualifiesFullWaiver =>
      '✓ ૧૦૦% સંપૂર્ણ ફી માફી અને મહત્તમ સ્કોલરશીપ માટે પાત્ર.';

  @override
  String get dialogAddSkillTitle => 'નવું કૌશલ્ય ઉમેરો';

  @override
  String get dialogAllSkillsAdded =>
      'કૅટેલૉગના તમામ કૌશલ્યો પહેલેથી જ ઉમેરેલા છે!';

  @override
  String get dialogAddInterestTitle => 'રસનું ક્ષેત્ર ઉમેરો';

  @override
  String get dialogAllInterestsAdded =>
      'તમામ ઉપલબ્ધ રુચિઓ પહેલેથી જ ઉમેરેલી છે!';

  @override
  String get dialogUpdateEducationTitle =>
      'શિક્ષણ અને પ્રાયોગિક માહિતી અપડેટ કરો';

  @override
  String get dialogEduLevelLabel => 'શિક્ષણ સ્તર';

  @override
  String get dialogEduDescLabel => 'પ્રાયોગિક / અનૌપચારિક શિક્ષણનું વર્ણન';

  @override
  String get dialogEduDescHint => 'તમે વ્યવહારિક રીતે શું કામ શીખ્યા છો?';

  @override
  String get dialogAspirationTitle => 'તમારું કારકિર્દી લક્ષ્ય / મહત્વાકાંક્ષા';

  @override
  String get dialogAspirationHint =>
      'દા.ત. એગ્રીકલ્ચરલ ડ્રોન પાયલટ, ઇલેક્ટ્રિકલ કોન્ટ્રાક્ટર...';

  @override
  String get dialogDemographicsTitle => 'વસ્તી વિષયક અને ક્વોટા અપડેટ કરો';

  @override
  String get dialogCasteQuotaLabel => 'સામાજિક વર્ગ / જાતિ ક્વોટા';

  @override
  String get dialogTribeLabel => 'જનજાતિ / સમુદાય (વૈકલ્પિક)';

  @override
  String get dialogTribeSubtitle =>
      'જનજાતિ કાર્ય મંત્રાલય (MoTA) અને PVTG વિશેષ યોજનાઓ સક્ષમ કરે છે.';

  @override
  String get dialogTribeCustomHint => 'અથવા તમારી જનજાતિ / PVTG નું નામ લખો...';

  @override
  String get dialogIncomeLabel => 'કૌટુંબિક આવક';

  @override
  String get btnCancel => 'રદ કરો';

  @override
  String get btnSave => 'સાચવો';

  @override
  String snackbarSkillAdded(String name) {
    return 'કૌશલ્ય ઉમેરાયું: $name';
  }

  @override
  String snackbarInterestAdded(String name) {
    return 'રસ ઉમેરાયો: $name';
  }

  @override
  String get snackbarEducationUpdated => 'શિક્ષણની વિગતો સફળતાપૂર્વક અપડેટ થઈ!';

  @override
  String get snackbarAspirationUpdated => 'કારકિર્દી લક્ષ્ય અપડેટ થયું!';

  @override
  String get snackbarDemographicsUpdated =>
      'વસ્તી વિષયક અને ક્વોટા પાત્રતા અપડેટ થઈ!';

  @override
  String snackbarError(String error) {
    return 'ભૂલ: $error';
  }

  @override
  String get eduPrimary => 'પ્રાથમિક શાળા (૫મા ધોરણ સુધી)';

  @override
  String get eduUpperPrimary => 'ઉચ્ચ પ્રાથમિક (૬ઠ્ઠા - ૮મા)';

  @override
  String get eduSecondary => '૧૦મું પાસ (માધ્યમિક)';

  @override
  String get eduSeniorSecondary => '૧૨મું પાસ (ઉચ્ચતર માધ્યમિક)';

  @override
  String get eduDiploma => 'ડિપ્લોમા / પોલિટેકનિક';

  @override
  String get eduVocational => 'વ્યવસાયિક / ITI';

  @override
  String get eduBachelor => 'સ્નાતક પદવી (Bachelor\'s)';

  @override
  String get eduMaster => 'અનુસ્નાતક પદવી (Master\'s)';

  @override
  String get eduInformal => 'અનૌપચારિક / પ્રાયોગિક શિક્ષણ';

  @override
  String get eduSelfLearning => 'સ્વ-શિક્ષિત (Self-Taught)';

  @override
  String get eduOther => 'અન્ય';

  @override
  String get catGeneral => 'સામાન્ય (General)';

  @override
  String get catOBC => 'અન્ય પછાત વર્ગ (OBC)';

  @override
  String get catSC => 'અનુસૂચિત જાતિ (SC)';

  @override
  String get catST => 'અનુસૂચિત જનજાતિ (ST)';

  @override
  String get catEWS => 'આર્થિક રીતે નબળા (EWS)';
}
