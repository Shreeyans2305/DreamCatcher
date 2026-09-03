import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamcatcherapp/core/theme/app_theme.dart';
import 'package:dreamcatcherapp/core/widgets/sensitivity_notice.dart';
import 'package:dreamcatcherapp/features/home/presentation/home_screen.dart';
import 'package:dreamcatcherapp/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('DreamCatcher home screen happy path renders navigation hub and trust disclaimers',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );

    // Initial pump
    await tester.pumpAndSettle();

    // Verify app title and welcome text are displayed
    expect(find.text('DreamCatcher'), findsOneWidget);

    // Verify key action cards exist (Opportunities, Chat, Profile)
    expect(find.text('Opportunities'), findsOneWidget);
    expect(find.text('AI Advisor'), findsOneWidget);
    expect(find.text('My Profile'), findsOneWidget);

    // Verify sensitivity trust notice is shown
    expect(find.byType(SensitivityNotice), findsOneWidget);
    expect(find.text('Why we ask for this information'), findsOneWidget);

    // Verify network simulator controls are accessible
    expect(find.text('Simulate Low-Connectivity (2G/3G)'), findsOneWidget);
    expect(find.text('Simulate Network Failure'), findsOneWidget);
  });
}
