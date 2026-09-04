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
  String get onboardingWelcome => 'চলুন আপনার ভবিষ্যতের পথ তৈরি করি';

  @override
  String get onboardingSubtitle =>
      'আপনার সম্পর্কে কিছু বলুন, যাতে আমরা আপনার জন্য সঠিক বৃত্তি, কোর্স, পরীক্ষা ও চাকরি খুঁজে দিতে পারি।';

  @override
  String get stepBasic => 'মৌলিক তথ্য';

  @override
  String get stepLocation => 'স্থান ও পটভূমি';

  @override
  String get stepEducation => 'শিক্ষা ও দক্ষতা';

  @override
  String get stepAspirations => 'আপনার লক্ষ্য';

  @override
  String get fullNameLabel => 'পুরো নাম';

  @override
  String get fullNameHint => 'যেমন: আরভ শর্মা';

  @override
  String get phoneLabel => 'ফোন নম্বর';

  @override
  String get phoneHint => 'যেমন: +91 98765 43210';

  @override
  String get preferredLanguageLabel => 'পছন্দের ভাষা';

  @override
  String get selectLanguage => 'আপনার ভাষা নির্বাচন করুন';

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
  String get educationLevelLabel => 'সর্বোচ্চ শিক্ষাগত স্তর';

  @override
  String get informalLearningLabel =>
      'What have you learned? (Practical/Informal)';

  @override
  String get informalLearningHint =>
      'e.g. Repaired solar pumps, assisted in pharmacy, farm bookkeeping...';

  @override
  String get skillsTitle => 'আপনার দক্ষতা';

  @override
  String get interestsTitle => 'আপনার পছন্দের ক্ষেত্র';

  @override
  String get aspirationLabel => 'আপনার স্বপ্নের কাজ বা উচ্চাকাঙ্ক্ষা কী?';

  @override
  String get aspirationHint =>
      'যেমন: কৃষি ড্রোন পাইলট, ইলেকট্রিশিয়ান, সিভিল ইঞ্জিনিয়ার...';

  @override
  String get btnNext => 'চালিয়ে যান';

  @override
  String get btnBack => 'পিছনে';

  @override
  String get btnFinish => 'প্রোফাইল সম্পূর্ণ করুন';

  @override
  String get saving => 'আপনার প্রোফাইল সংরক্ষণ হচ্ছে...';

  @override
  String greeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get dashboardCompleteness => 'প্রোফাইল সম্পূর্ণতা';

  @override
  String get dashboardMatchedOpps => 'মিলেছে এমন সুযোগ';

  @override
  String get dashboardActiveDeadlines => 'Deadlines Approaching';

  @override
  String get topOpportunitiesTitle => 'আপনার জন্য সেরা সুযোগ';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String socialProofDistrict(int count) {
    return '$count students in your district applied this week';
  }

  @override
  String get searchHint => 'বৃত্তি, কোর্স, পরীক্ষা খুঁজুন...';

  @override
  String get filterAll => 'সব';

  @override
  String get filterScholarships => 'বৃত্তি';

  @override
  String get filterCourses => 'কোর্স';

  @override
  String get filterExams => 'পরীক্ষা';

  @override
  String get filterInternships => 'ইন্টার্নশিপ';

  @override
  String get filterEligibleOnly => 'শুধু যোগ্য';

  @override
  String get resetFilters => 'ফিল্টার রিসেট করুন';

  @override
  String get eligibleBadge => 'যোগ্য';

  @override
  String get notEligibleBadge => 'শর্ত দেখুন';

  @override
  String rulesPassed(int passed, int total) {
    return '$passed of $total criteria met';
  }

  @override
  String get eligibilityReasoningTitle => 'যোগ্যতার বিবরণ';

  @override
  String get applyNow => 'সরকারি পোর্টালে আবেদন করুন';

  @override
  String get noOpportunitiesFound => 'কোনও মিল পাওয়া সুযোগ নেই।';

  @override
  String get assistantTitle => 'এআই ক্যারিয়ার গাইড';

  @override
  String get assistantSubtitle => 'আপনার যাত্রার জন্য ব্যক্তিগত পরামর্শ';

  @override
  String get chatInputHint => 'ক্যারিয়ার বা বৃত্তি সম্পর্কে জিজ্ঞাসা করুন...';

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
}
