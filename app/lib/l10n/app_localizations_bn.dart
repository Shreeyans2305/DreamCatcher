// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ড্রিমক্যাচার';

  @override
  String get tagline => 'ধাপে ধাপে আপনার ভবিষ্যৎ আবিষ্কার করুন';

  @override
  String get navDashboard => 'হোম';

  @override
  String get navOpportunities => 'সুযোগ';

  @override
  String get navChat => 'সহায়ক';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get onboardingWelcome => 'আসুন আপনার ভবিষ্যৎ পথ তৈরি করি';

  @override
  String get onboardingSubtitle =>
      'আপনার সম্পর্কে একটু জানান যাতে আমরা আপনার জন্য উপযুক্ত স্কলারশিপ, কোর্স, পরীক্ষা এবং কাজের সুযোগ খুঁজে দিতে পারি।';

  @override
  String get stepBasic => 'প্রাথমিক তথ্য';

  @override
  String get stepLocation => 'অবস্থান ও পটভূমি';

  @override
  String get stepEducation => 'শিক্ষা ও দক্ষতা';

  @override
  String get stepAspirations => 'আপনার লক্ষ্য';

  @override
  String get fullNameLabel => 'পুরো নাম';

  @override
  String get fullNameHint => 'যেমন: সৌরভ শর্মা';

  @override
  String get phoneLabel => 'ফোন নম্বর';

  @override
  String get phoneHint => 'যেমন: +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'পছন্দের ভাষা';

  @override
  String get selectLanguage => 'আপনার ভাষা বেছে নিন';

  @override
  String get stateLabel => 'রাজ্য';

  @override
  String get districtLabel => 'জেলা';

  @override
  String get areaTypeLabel => 'এলাকার ধরন';

  @override
  String get rural => 'গ্রামীণ';

  @override
  String get urban => 'শহুরে';

  @override
  String get semiUrban => 'আধা-শহুরে';

  @override
  String get casteCategoryLabel => 'সামাজিক শ্রেণি';

  @override
  String get incomeBracketLabel => 'বার্ষিক পারিবারিক আয়';

  @override
  String get educationLevelLabel => 'সর্বোচ্চ শিক্ষার স্তর';

  @override
  String get informalLearningLabel =>
      'আপনি কী শিখেছেন? (ব্যবহারিক/অনানুষ্ঠানিক)';

  @override
  String get informalLearningHint =>
      'যেমন: সৌর পাম্প মেরামত, ফার্মেসিতে সহায়তা, চাষের হিসাব...';

  @override
  String get skillsTitle => 'আপনার দক্ষতা (Skills)';

  @override
  String get interestsTitle => 'পছন্দের ক্ষেত্র (Interests)';

  @override
  String get aspirationLabel => 'আপনার স্বপ্নের চাকরি বা উচ্চাকাঙ্ক্ষা কী?';

  @override
  String get aspirationHint =>
      'যেমন: এগ্রিকালচারাল ড্রোন পাইলট, ইলেকট্রিশিয়ান, সিভিল ইঞ্জিনিয়ার...';

  @override
  String get btnNext => 'এগিয়ে যান';

  @override
  String get btnBack => 'পেছনে';

  @override
  String get btnFinish => 'প্রোফাইল সম্পূর্ণ করুন';

  @override
  String get saving => 'প্রোফাইল সংরক্ষণ করা হচ্ছে...';

  @override
  String greeting(String name) {
    return 'নমস্কার, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'প্রোফাইল সম্পূর্ণতা';

  @override
  String get dashboardMatchedOpps => 'উপযুক্ত সুযোগসমূহ';

  @override
  String get dashboardActiveDeadlines => 'আসন্ন শেষ তারিখ';

  @override
  String get topOpportunitiesTitle => 'আপনার জন্য সেরা সুযোগ';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String socialProofDistrict(int count) {
    return 'আপনার জেলার $count জন শিক্ষার্থী এই সপ্তাহে আবেদন করেছে';
  }

  @override
  String get searchHint => 'স্কলারশিপ, কোর্স, পরীক্ষা খুঁজুন...';

  @override
  String get filterAll => 'সব';

  @override
  String get filterScholarships => 'স্কলারশিপ';

  @override
  String get filterCourses => 'কোর্স';

  @override
  String get filterExams => 'প্রবেশিকা পরীক্ষা';

  @override
  String get filterInternships => 'ইন্টার্নশিপ';

  @override
  String get filterEligibleOnly => 'শুধুমাত্র যোগ্য';

  @override
  String get resetFilters => 'ফিল্টার রিসেট করুন';

  @override
  String get eligibleBadge => 'যোগ্য (Eligible)';

  @override
  String get notEligibleBadge => 'শর্তাবলী পরীক্ষা করুন';

  @override
  String rulesPassed(int passed, int total) {
    return '$totalটির মধ্যে $passedটি শর্ত পূরণ হয়েছে';
  }

  @override
  String get eligibilityReasoningTitle => 'যোগ্যতার বিবরণ';

  @override
  String get applyNow => 'অফিসিয়াল পোর্টালে আবেদন করুন';

  @override
  String get noOpportunitiesFound =>
      'কোনো উপযুক্ত সুযোগ পাওয়া যায়নি। ফিল্টার পরিবর্তন করে দেখুন।';

  @override
  String get assistantTitle => 'এআই ক্যারিয়ার গাইড';

  @override
  String get assistantSubtitle => 'আপনার পথের জন্য ব্যক্তিগত পরামর্শ';

  @override
  String get chatInputHint =>
      'ক্যারিয়ার বা স্কলারশিপ সম্পর্কে কিছু জিজ্ঞাসা করুন...';

  @override
  String get send => 'পাঠান';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get addSkill => 'দক্ষতা যোগ করুন';

  @override
  String get addInterest => 'আগ্রহ যোগ করুন';

  @override
  String get saveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String opportunitiesAvailable(int count) {
    return '$countটি সুযোগ উপলব্ধ';
  }

  @override
  String get opportunityTypeScholarship => 'স্কলারশিপ';

  @override
  String get opportunityTypeCourse => 'পেশাগত কোর্স';

  @override
  String get opportunityTypeExam => 'প্রবেশিকা পরীক্ষা';

  @override
  String get opportunityTypeInternship => 'ইন্টার্নশিপ / ফেলোশিপ';

  @override
  String get opportunityTypeGeneral => 'সুযোগ';

  @override
  String get openToAllCriteria =>
      'মৌলিক শর্ত পূরণকারী সকল প্রার্থীর জন্য উন্মুক্ত';

  @override
  String get noMatchingOpportunities => 'কোনো মিল থাকা সুযোগ নেই';

  @override
  String get noMatchingOpportunitiesSubtitle =>
      'অনুসন্ধান পরিবর্তন করুন বা \'শুধুমাত্র যোগ্য\' ফিল্টারটি বন্ধ করুন।';

  @override
  String officialPortalOpening(String url) {
    return 'অফিসিয়াল পোর্টাল খোলা হচ্ছে: $url';
  }

  @override
  String get statFinancialBenefit => 'আর্থিক সুবিধা';

  @override
  String get statKeyDetails => 'মূল বিবরণ';

  @override
  String get opportunityAbout => 'এই সুযোগ সম্পর্কে';

  @override
  String yourProfileValue(String value) {
    return 'আপনার প্রোফাইল: $value';
  }

  @override
  String get openToAllGeneral =>
      'সাধারণ যোগ্যতা পূরণকারী সকল শিক্ষার্থীর জন্য উন্মুক্ত।';

  @override
  String get locationNotSet => 'অবস্থান নির্ধারিত নেই';

  @override
  String get demographicsTitle => 'জনসংখ্যার তথ্য ও কোটা';

  @override
  String get socialCategoryLabel => 'সামাজিক শ্রেণি ও জাতি';

  @override
  String get tribeLabel => 'জনজাতি অন্তর্ভুক্তি';

  @override
  String get annualIncomeLabel => 'বার্ষিক পারিবারিক আয়';

  @override
  String get areaClassificationLabel => 'এলাকা শ্রেণিবিভাগ';

  @override
  String get educationSectionTitle => 'শিক্ষা ও শিখন';

  @override
  String skillsSectionTitle(int count) {
    return 'দক্ষতা ($count)';
  }

  @override
  String interestsSectionTitle(int count) {
    return 'পছন্দের ক্ষেত্র ($count)';
  }

  @override
  String get careerAspirationTitle => 'ক্যারিয়ার লক্ষ্য ও স্বপ্ন';

  @override
  String get btnUpdate => 'আপডেট করুন';

  @override
  String get btnAddSkill => '+ দক্ষতা যোগ করুন';

  @override
  String get btnAddInterest => '+ আগ্রহ যোগ করুন';

  @override
  String get btnSwitchProfile => 'প্রোফাইল পরিবর্তন / রিসেট';

  @override
  String get noneSpecified => 'নির্দিষ্ট নয়';

  @override
  String get nilIncome => '₹0 (শূন্য আয় / ₹25,000 এর নিচে)';

  @override
  String underIncome(String amount) {
    return '₹$amount (₹25,000 এর নিচে)';
  }

  @override
  String perYearIncome(String amount) {
    return '₹$amount / বছর';
  }

  @override
  String get noEducationDescription =>
      'এখনও কোনো ব্যবহারিক অভিজ্ঞতার বিবরণ যোগ করা হয়নি।';

  @override
  String get noSkillsAdded =>
      'এখনও কোনো দক্ষতা যোগ করা হয়নি। তালিকা থেকে যোগ করতে \'+ দক্ষতা যোগ করুন\' এ চাপুন।';

  @override
  String get noInterestsAdded =>
      'এখনও কোনো পছন্দ যোগ করা হয়নি। পছন্দের ক্ষেত্র যোগ করতে \'+ আগ্রহ যোগ করুন\' এ চাপুন।';

  @override
  String get noAspirationAdded => 'এখনও কোনো লক্ষ্য যোগ করা হয়নি।';

  @override
  String get qualifiesFullWaiver =>
      '✓ ১০০% সম্পূর্ণ ফি মওকুফ এবং সর্বোচ্চ স্কলারশিপের জন্য যোগ্য।';

  @override
  String get dialogAddSkillTitle => 'নতুন দক্ষতা যোগ করুন';

  @override
  String get dialogAllSkillsAdded =>
      'ক্যাটালগের সমস্ত দক্ষতা ইতিমধ্যে যোগ করা হয়েছে!';

  @override
  String get dialogAddInterestTitle => 'আগ্রহের ক্ষেত্র যোগ করুন';

  @override
  String get dialogAllInterestsAdded =>
      'সমস্ত উপলভ্য ক্ষেত্র ইতিমধ্যে যোগ করা হয়েছে!';

  @override
  String get dialogUpdateEducationTitle =>
      'শিক্ষা ও ব্যবহারিক অভিজ্ঞতা আপডেট করুন';

  @override
  String get dialogEduLevelLabel => 'শিক্ষার স্তর';

  @override
  String get dialogEduDescLabel => 'ব্যবহারিক / অনানুষ্ঠানিক শিক্ষার বিবরণ';

  @override
  String get dialogEduDescHint => 'আপনি বাস্তবে কী কাজ শিখেছেন?';

  @override
  String get dialogAspirationTitle => 'আপনার ক্যারিয়ার লক্ষ্য / উচ্চাকাঙ্ক্ষা';

  @override
  String get dialogAspirationHint =>
      'যেমন: এগ্রিকালচারাল ড্রোন পাইলট, ইলেকট্রিক্যাল কন্ট্রাক্টর...';

  @override
  String get dialogDemographicsTitle => 'জনসংখ্যা ও কোটা আপডেট করুন';

  @override
  String get dialogCasteQuotaLabel => 'সামাজিক শ্রেণি / জাতি কোটা';

  @override
  String get dialogTribeLabel => 'উপজাতি / সম্প্রদায় (ঐচ্ছিক)';

  @override
  String get dialogTribeSubtitle =>
      'উপজাতীয় বিষয়ক মন্ত্রণালয় (MoTA) এবং PVTG বিশেষ প্রকল্প আনলক করে।';

  @override
  String get dialogTribeCustomHint => 'অথবা নিজস্ব উপজাতি / PVTG নাম লিখুন...';

  @override
  String get dialogIncomeLabel => 'পারিবারিক আয়';

  @override
  String get btnCancel => 'বাতিল';

  @override
  String get btnSave => 'সংরক্ষণ';

  @override
  String snackbarSkillAdded(String name) {
    return 'দক্ষতা যোগ করা হয়েছে: $name';
  }

  @override
  String snackbarInterestAdded(String name) {
    return 'আগ্রহ যোগ করা হয়েছে: $name';
  }

  @override
  String get snackbarEducationUpdated =>
      'শিক্ষার বিবরণ সফলভাবে আপডেট করা হয়েছে!';

  @override
  String get snackbarAspirationUpdated => 'ক্যারিয়ার লক্ষ্য আপডেট হয়েছে!';

  @override
  String get snackbarDemographicsUpdated =>
      'জনসংখ্যা ও কোটা যোগ্যতা আপডেট করা হয়েছে!';

  @override
  String snackbarError(String error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get eduPrimary => 'প্রাথমিক বিদ্যালয় (৫ম শ্রেণি পর্যন্ত)';

  @override
  String get eduUpperPrimary => 'উচ্চ প্রাথমিক (৬ষ্ঠ - ৮ম)';

  @override
  String get eduSecondary => '১০ম উত্তীর্ণ (মাধ্যমিক)';

  @override
  String get eduSeniorSecondary => '১২ম উত্তীর্ণ (উচ্চ মাধ্যমিক)';

  @override
  String get eduDiploma => 'ডিপ্লোমা / পলিটেকনিক';

  @override
  String get eduVocational => 'ভোকেশনাল / আইটিআই (ITI)';

  @override
  String get eduBachelor => 'স্নাতক ডিগ্রি (Bachelor\'s)';

  @override
  String get eduMaster => 'স্নাতকোত্তর ডিগ্রি (Master\'s)';

  @override
  String get eduInformal => 'অনানুষ্ঠানিক / ব্যবহারিক শিক্ষা';

  @override
  String get eduSelfLearning => 'স্বশিক্ষিত (Self-Taught)';

  @override
  String get eduOther => 'অন্যান্য';

  @override
  String get catGeneral => 'সাধারণ (General)';

  @override
  String get catOBC => 'অন্যান্য অনগ্রসর শ্রেণি (OBC)';

  @override
  String get catSC => 'তপশিলি জাতি (SC)';

  @override
  String get catST => 'তপশিলি উপজাতি (ST)';

  @override
  String get catEWS => 'অর্থনৈতিকভাবে দুর্বল (EWS)';
}
