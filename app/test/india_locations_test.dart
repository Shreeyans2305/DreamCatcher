import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamcatcher/data/india_locations.dart';
import 'package:dreamcatcher/core/widgets/searchable_location_picker.dart';

void main() {
  group('India Locations Dataset Tests', () {
    test('Contains exactly 36 States and Union Territories', () {
      final states = IndiaLocations.states;
      expect(states.length, equals(36));
      expect(states.contains('Maharashtra'), isTrue);
      expect(states.contains('Bihar'), isTrue);
      expect(states.contains('Gujarat'), isTrue);
      expect(states.contains('Tamil Nadu'), isTrue);
      expect(states.contains('Karnataka'), isTrue);
      expect(states.contains('Uttar Pradesh'), isTrue);
      expect(states.contains('Delhi'), isTrue);
      expect(states.contains('Ladakh'), isTrue);
      expect(states.contains('Jammu and Kashmir'), isTrue);
      expect(states.contains('Puducherry'), isTrue);
    });

    test('Every state and UT has at least one valid district', () {
      for (final state in IndiaLocations.states) {
        final districts = IndiaLocations.getDistricts(state);
        expect(districts.isNotEmpty, isTrue, reason: '$state should have districts');
        for (final d in districts) {
          expect(d.trim().isNotEmpty, isTrue);
        }
      }
    });

    test('Total districts across India exceeds 700', () {
      int totalDistricts = 0;
      for (final state in IndiaLocations.states) {
        totalDistricts += IndiaLocations.getDistricts(state).length;
      }
      expect(totalDistricts, greaterThan(700));
    });

    test('getDistricts returns sorted districts and is case-insensitive', () {
      final maharashtraDistricts = IndiaLocations.getDistricts('maharashtra');
      expect(maharashtraDistricts.contains('Pune'), isTrue);
      expect(maharashtraDistricts.contains('Mumbai City'), isTrue);
      expect(maharashtraDistricts.contains('Nagpur'), isTrue);
      expect(maharashtraDistricts.contains('Nashik'), isTrue);
      expect(maharashtraDistricts.contains('Satara'), isTrue);

      final biharDistricts = IndiaLocations.getDistricts('BIHAR');
      expect(biharDistricts.contains('Patna'), isTrue);
      expect(biharDistricts.contains('Muzaffarpur'), isTrue);
      expect(biharDistricts.contains('Gaya'), isTrue);
    });

    test('searchStates filters by substring', () {
      final tamilMatch = IndiaLocations.searchStates('Tamil');
      expect(tamilMatch, equals(['Tamil Nadu']));

      final pradeshMatch = IndiaLocations.searchStates('pradesh');
      expect(pradeshMatch.contains('Andhra Pradesh'), isTrue);
      expect(pradeshMatch.contains('Arunachal Pradesh'), isTrue);
      expect(pradeshMatch.contains('Himachal Pradesh'), isTrue);
      expect(pradeshMatch.contains('Madhya Pradesh'), isTrue);
      expect(pradeshMatch.contains('Uttar Pradesh'), isTrue);
    });

    test('searchDistricts filters districts within state', () {
      final puneMatch = IndiaLocations.searchDistricts('Maharashtra', 'pun');
      expect(puneMatch, equals(['Pune']));

      final mumbaiMatch = IndiaLocations.searchDistricts('Maharashtra', 'mumbai');
      expect(mumbaiMatch.length, equals(2));
      expect(mumbaiMatch.contains('Mumbai City'), isTrue);
      expect(mumbaiMatch.contains('Mumbai Suburban'), isTrue);
    });

    test('Validation helpers verify state and district legitimacy', () {
      expect(IndiaLocations.isValidState('Maharashtra'), isTrue);
      expect(IndiaLocations.isValidState('maharashtra'), isTrue);
      expect(IndiaLocations.isValidState('Atlantis'), isFalse);

      expect(IndiaLocations.isValidDistrict('Maharashtra', 'Pune'), isTrue);
      expect(IndiaLocations.isValidDistrict('Maharashtra', 'Patna'), isFalse);
      expect(IndiaLocations.isValidDistrict('Bihar', 'Patna'), isTrue);
    });
  });

  group('Location UI Widget Tests', () {
    testWidgets('LocationSelectorField renders label, value and responds to tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationSelectorField(
              label: 'State / UT',
              value: 'Maharashtra',
              hintText: 'Select State',
              icon: Icons.map_outlined,
              isRequired: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('State / UT'), findsOneWidget);
      expect(find.text(' *'), findsOneWidget);
      expect(find.text('Maharashtra'), findsOneWidget);
      expect(find.byIcon(Icons.map_outlined), findsOneWidget);

      await tester.tap(find.text('Maharashtra'));
      expect(tapped, isTrue);
    });

    testWidgets('showSearchableLocationPicker displays states and filters on search', (tester) async {
      String? selectedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  selectedResult = await showSearchableLocationPicker(
                    context,
                    title: 'Select State',
                    searchHint: 'Search state...',
                    items: IndiaLocations.states,
                    selectedItem: 'Maharashtra',
                  );
                },
                child: const Text('Open Picker'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();

      expect(find.text('Select State'), findsOneWidget);
      expect(find.text('36 available'), findsOneWidget);
      expect(find.text('Andhra Pradesh'), findsOneWidget);

      // Search for "Kerala"
      await tester.enterText(find.byType(TextField), 'Kerala');
      await tester.pumpAndSettle();

      final keralaTile = find.widgetWithText(InkWell, 'Kerala');
      expect(keralaTile, findsOneWidget);
      expect(find.widgetWithText(InkWell, 'Maharashtra'), findsNothing);

      // Tap Kerala
      await tester.tap(keralaTile);
      await tester.pumpAndSettle();

      expect(selectedResult, equals('Kerala'));
    });
  });
}
