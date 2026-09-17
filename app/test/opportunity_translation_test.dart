import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamcatcher/core/localization/opportunity_translator.dart';
import 'package:dreamcatcher/data/models/opportunity.dart';
import 'package:dreamcatcher/l10n/app_localizations.dart';

void main() {
  group('Opportunity and Profile Localization Tests', () {
    test('Translates opportunity titles correctly across languages', () {
      const enTitle = 'PM Yashasvi Central Sector Scholarship for OBC/EBC/DNT';

      final hiTitle = OpportunityTranslator.getTitle(enTitle, 'hi');
      expect(hiTitle, contains('पीएम यशस्वी'));

      final mrTitle = OpportunityTranslator.getTitle(enTitle, 'mr');
      expect(mrTitle, contains('पीएम यशस्वी'));

      final bnTitle = OpportunityTranslator.getTitle(enTitle, 'bn');
      expect(bnTitle, contains('পিএম যশস্বী'));

      final taTitle = OpportunityTranslator.getTitle(enTitle, 'ta');
      expect(taTitle, contains('பிரதமர் யஷஸ்வி'));

      final teTitle = OpportunityTranslator.getTitle(enTitle, 'te');
      expect(teTitle, contains('పీఎం యశస్వి'));

      final knTitle = OpportunityTranslator.getTitle(enTitle, 'kn');
      expect(knTitle, contains('ಪಿಎಂ ಯಶಸ್ವಿ'));

      final guTitle = OpportunityTranslator.getTitle(enTitle, 'gu');
      expect(guTitle, contains('પીએમ યશસ્વી'));

      final orTitle = OpportunityTranslator.getTitle(enTitle, 'or');
      expect(orTitle, contains('ପିଏମ ଯଶସ୍ୱୀ'));

      final enResult = OpportunityTranslator.getTitle(enTitle, 'en');
      expect(enResult, equals(enTitle));
    });

    test('Translates opportunity descriptions correctly', () {
      const enTitle = 'DDU-GKY Free Residential Rural Skill Training & Placement';
      const enDesc = 'Government of India fully funded skill certification with free food, accommodation, uniform, tablet, and guaranteed placement for rural youth.';

      final hiDesc = OpportunityTranslator.getDescription(enDesc, enTitle, 'hi');
      expect(hiDesc, contains('निःशुल्क भोजन'));

      final mrDesc = OpportunityTranslator.getDescription(enDesc, enTitle, 'mr');
      expect(mrDesc, contains('मोफत भोजन'));

      final bnDesc = OpportunityTranslator.getDescription(enDesc, enTitle, 'bn');
      expect(bnDesc, contains('বিনামূল্যে'));
    });

    test('Translates rule evaluations properly', () {
      final hiRule = OpportunityTranslator.getRuleDescription(
        ruleType: 'INCOME',
        operator: 'LTE',
        value: '250000',
        fallbackDesc: 'Annual income <= 250000',
        langCode: 'hi',
      );
      expect(hiRule, contains('पारिवारिक आय ₹250000'));

      final mrRule = OpportunityTranslator.getRuleDescription(
        ruleType: 'SOCIAL_CATEGORY',
        operator: 'EQ',
        value: 'OBC',
        fallbackDesc: 'Category must be OBC',
        langCode: 'mr',
      );
      expect(mrRule, contains('OBC प्रवर्गातील विद्यार्थी पात्र'));
    });

    testWidgets('AppLocalizations loads all 9 supported locales properly', (tester) async {
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                expect(l10n.navOpportunities, isNotEmpty);
                expect(l10n.navProfile, isNotEmpty);
                expect(l10n.demographicsTitle, isNotEmpty);
                expect(l10n.educationSectionTitle, isNotEmpty);
                expect(l10n.opportunityTypeScholarship, isNotEmpty);
                expect(l10n.opportunitiesAvailable(5), isNotEmpty);
                return Text(l10n.navProfile);
              },
            ),
          ),
        );
      }
    });

    test('Opportunity model methods return localized strings', () {
      final opp = Opportunity(
        id: 'test-1',
        type: 'scholarship',
        title: 'PM Yashasvi Central Sector Scholarship for OBC/EBC/DNT',
        description: 'English description',
        scholarship: ScholarshipDetails(amount: 75000, recurrence: 'annual'),
      );

      expect(opp.getLocalizedTitle('hi'), contains('पीएम यशस्वी'));
      expect(opp.getLocalizedTitle('mr'), contains('पीएम यशस्वी'));
      expect(opp.getLocalizedTitle('en'), equals(opp.title));
    });

    test('Translates AICTE Pragati and Saksham scholarships in Marathi and Hindi', () {
      const pragatiTitle = 'AICTE Pragati Scholarship for Girl Students in Technical Education';
      expect(OpportunityTranslator.getTitle(pragatiTitle, 'mr'), contains('प्रगती शिष्यवृत्ती'));
      expect(OpportunityTranslator.getTitle(pragatiTitle, 'hi'), contains('प्रगति छात्रवृत्ति'));

      const sakshamTitle = 'AICTE Saksham Scholarship for Specially-Abled Students';
      expect(OpportunityTranslator.getTitle(sakshamTitle, 'mr'), contains('सक्षम शिष्यवृत्ती'));
      expect(OpportunityTranslator.getTitle(sakshamTitle, 'hi'), contains('सक्षम छात्रवृत्ति'));

      const sakshamDesc = 'Dedicated financial assistance for students with disability of 40% or more pursuing technical degrees or diplomas in AICTE approved institutions.';
      expect(OpportunityTranslator.getDescription(sakshamDesc, sakshamTitle, 'mr'), contains('दिव्यांगत्व'));
    });

    test('Translates disability rule properly across languages', () {
      final mrDisability = OpportunityTranslator.getRuleDescription(
        ruleType: 'DISABILITY',
        operator: 'EQ',
        value: '40% or more',
        fallbackDesc: 'Candidate must have not less than 40% benchmark disability.',
        langCode: 'mr',
      );
      expect(mrDisability, contains('दिव्यांगत्वाचे प्रमाणपत्र'));

      final hiDisability = OpportunityTranslator.getRuleDescription(
        ruleType: 'DISABILITY',
        operator: 'EQ',
        value: '40% or more',
        fallbackDesc: 'Candidate must have not less than 40% benchmark disability.',
        langCode: 'hi',
      );
      expect(hiDisability, contains('दिव्यांगता प्रमाणपत्र'));
    });

    test('Sanitizes and localizes education descriptions properly', () {
      const rawWithDemographics = 'Category: General | Tribe: None | Income: Rs 120000 | Area: rural | Interested in software engineering and computers.';
      final mrSanitized = OpportunityTranslator.sanitizeEducationDescription(rawWithDemographics, 'mr');
      expect(mrSanitized, contains('सॉफ्टवेअर अभियांत्रिकी आणि संगणक तंत्रज्ञान'));
      expect(mrSanitized.contains('Category:'), isFalse);
      expect(mrSanitized.contains('Income:'), isFalse);

      const rawPureDemographics = 'Category: General | Tribe: None | Income: Rs 120000 | Area: rural';
      final emptyResult = OpportunityTranslator.sanitizeEducationDescription(rawPureDemographics, 'mr');
      expect(emptyResult, isEmpty);
    });
  });
}
