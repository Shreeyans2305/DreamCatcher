import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamcatcherapp/core/network/api_exception.dart';
import 'package:dreamcatcherapp/core/theme/app_theme.dart';
import 'package:dreamcatcherapp/core/widgets/offline_state_view.dart';
import 'package:dreamcatcherapp/features/opportunities/presentation/opportunity_finder_screen.dart';
import 'package:dreamcatcherapp/features/opportunities/presentation/providers/opportunity_providers.dart';
import 'package:dreamcatcherapp/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('OfflineStateView renders explicit connection interrupted state and handles retry',
      (WidgetTester tester) async {
    bool retried = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: OfflineStateView(
            message: 'Unable to connect right now. Using locally stored data.',
            onRetry: () {
              retried = true;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify offline icon, title and description
    expect(find.byIcon(Icons.signal_cellular_connected_no_internet_4_bar_rounded), findsOneWidget);
    expect(find.text('Connection Interrupted'), findsOneWidget);
    expect(find.text('Unable to connect right now. Using locally stored data.'), findsOneWidget);

    // Verify Retry button exists and functions
    final retryButtonFinder = find.widgetWithText(ElevatedButton, 'Retry');
    expect(retryButtonFinder, findsOneWidget);

    await tester.tap(retryButtonFinder);
    await tester.pump();

    expect(retried, isTrue);
  });

  testWidgets('OpportunityFinderScreen displays explicit offline error UI on network failure',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          opportunitiesProvider.overrideWith(
            (ref) => _FailingOpportunitiesNotifier(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OpportunityFinderScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify screen title and filter chips
    expect(find.text('Opportunity Finder'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);

    // Verify offline state view is shown instead of infinite spinner
    expect(find.byType(OfflineStateView), findsOneWidget);
    expect(find.text('Connection Interrupted'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });
}

class _FailingOpportunitiesNotifier extends StateNotifier<AsyncValue<OpportunitiesState>>
    implements OpportunitiesNotifier {
  _FailingOpportunitiesNotifier()
      : super(const AsyncValue.error(
          NetworkOfflineException(message: 'Simulated 2G/3G network disconnection'),
          StackTrace.empty,
        ));

  @override
  Future<void> loadOpportunities() async {
    state = const AsyncValue.error(
      NetworkOfflineException(message: 'Simulated 2G/3G network disconnection'),
      StackTrace.empty,
    );
  }
}
