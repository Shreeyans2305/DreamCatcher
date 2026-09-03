import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:dreamcatcherapp/core/network/network_providers.dart';
import 'package:dreamcatcherapp/core/theme/app_theme.dart';
import 'package:dreamcatcherapp/features/auth/data/datasources/auth_token_storage.dart';
import 'package:dreamcatcherapp/features/auth/domain/models/auth_user.dart';
import 'package:dreamcatcherapp/features/auth/presentation/auth_screen.dart';
import 'package:dreamcatcherapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:dreamcatcherapp/features/home/presentation/home_screen.dart';
import 'package:dreamcatcherapp/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dreamcatcherapp/features/splash/presentation/splash_screen.dart';
import 'package:dreamcatcherapp/l10n/generated/app_localizations.dart';

Widget createTestApp({
  required List<Override> overrides,
  String initialLocation = '/',
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  testWidgets(
      'successful Google mock sign-in stores token and navigates to onboarding',
      (WidgetTester tester) async {
    final inMemoryStorage = InMemoryAuthTokenStorage();

    await tester.pumpWidget(
      createTestApp(
        initialLocation: '/auth',
        overrides: [
          useMockRepositoriesProvider.overrideWith((ref) => true),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Verify on Auth Screen
    expect(find.byType(AuthScreen), findsOneWidget);
    expect(find.byKey(const Key('auth_google_button')), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    // Tap "Continue with Google"
    await tester.tap(find.byKey(const Key('auth_google_button')));

    // Pump past the mock delay
    await tester.pumpAndSettle();

    // Verify token was stored securely
    final token = await inMemoryStorage.getToken();
    expect(token, isNotNull);
    expect(token, contains('mock_jwt_google'));

    // Verify navigation reached /onboarding (since newly signed-in user has no profile yet)
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Empowering Your Ambitions'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets(
      'offline-with-cached-session on app launch lets student in and navigates to home',
      (WidgetTester tester) async {
    // Cached user with completed profile in secure storage
    const cachedUser = AuthUser(
      id: 'usr_rural_001',
      phoneNumber: '+919876543210',
      displayName: 'Priya Sharma',
      token: 'mock_jwt_secure_token_dc_001',
      authProvider: 'otp',
      isProfileComplete: true,
    );

    final inMemoryStorage = InMemoryAuthTokenStorage(
      initialToken: cachedUser.token,
      initialUser: cachedUser,
    );

    await tester.pumpWidget(
      createTestApp(
        initialLocation: '/',
        overrides: [
          useMockRepositoriesProvider.overrideWith((ref) => true),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
          networkSimulatorProvider.overrideWith((ref) {
            final interceptor = ref.watch(simulatorInterceptorProvider);
            final notifier = NetworkSimulatorNotifier(interceptor);
            notifier.toggleSimulateFailure(true); // Simulate offline/disconnected network
            return notifier;
          }),
        ],
      ),
    );

    // Initial frame renders splash screen
    expect(find.byType(SplashScreen), findsOneWidget);

    // Allow splash timer and cached session resolution to settle
    await tester.pumpAndSettle();

    // Verify the student was NOT blocked on /auth and instead navigated directly to /home
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('DreamCatcher'), findsOneWidget);
    expect(find.text('AI Advisor'), findsOneWidget);
  });

  testWidgets(
      'OTP flow: rejects invalid code and succeeds with mock code 123456',
      (WidgetTester tester) async {
    final inMemoryStorage = InMemoryAuthTokenStorage();

    await tester.pumpWidget(
      createTestApp(
        initialLocation: '/auth',
        overrides: [
          useMockRepositoriesProvider.overrideWith((ref) => true),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Open OTP modal
    await tester.tap(find.byKey(const Key('auth_otp_button')));
    await tester.pumpAndSettle();

    // Enter phone number
    await tester.enterText(
        find.byKey(const Key('auth_identifier_input')), '+919876543210');
    await tester.pump();

    // Tap Send Code
    await tester.tap(find.byKey(const Key('auth_send_code_button')));
    await tester.pumpAndSettle();

    // Verify 6-digit code entry step is displayed
    expect(find.byKey(const Key('auth_otp_input')), findsOneWidget);
    expect(find.text('For testing, enter 123456'), findsOneWidget);

    // Test invalid code
    await tester.enterText(find.byKey(const Key('auth_otp_input')), '000000');
    await tester.pump();
    await tester.tap(find.byKey(const Key('auth_verify_otp_button')));
    await tester.pumpAndSettle();

    // Should display invalid code error
    expect(find.text('Incorrect code. Please enter 123456 to continue.'),
        findsOneWidget);

    // Test correct mock code '123456'
    await tester.enterText(find.byKey(const Key('auth_otp_input')), '123456');
    await tester.pump();
    await tester.tap(find.byKey(const Key('auth_verify_otp_button')));
    await tester.pumpAndSettle();

    // Verifies token stored and navigates to /home (existing mock user Priya Sharma)
    final token = await inMemoryStorage.getToken();
    expect(token, isNotNull);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets(
      'Government ID flow: displays consent explanation and completes 12-digit verification',
      (WidgetTester tester) async {
    final inMemoryStorage = InMemoryAuthTokenStorage();

    await tester.pumpWidget(
      createTestApp(
        initialLocation: '/auth',
        overrides: [
          useMockRepositoriesProvider.overrideWith((ref) => true),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Open Government ID modal
    await tester.tap(find.byKey(const Key('auth_gov_id_button')));
    await tester.pumpAndSettle();

    // Verify consent title and explanation for sensitive data
    expect(find.text('Why We Ask For Your Government ID'), findsOneWidget);
    expect(find.byKey(const Key('auth_gov_id_consent_checkbox')),
        findsOneWidget);

    // Continue button should initially be disabled without consent
    final continueButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('auth_gov_id_continue_button')));
    expect(continueButton.onPressed, isNull);

    // Tap consent checkbox
    await tester.tap(find.byKey(const Key('auth_gov_id_consent_checkbox')));
    await tester.pumpAndSettle();

    // Continue button is now enabled
    await tester.tap(find.byKey(const Key('auth_gov_id_continue_button')));
    await tester.pumpAndSettle();

    // Step 2: Enter 12-digit Aadhaar / ID number
    expect(find.byKey(const Key('auth_gov_id_input')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('auth_gov_id_input')), '123456789012');
    await tester.pump();

    // Tap verify
    await tester.tap(find.byKey(const Key('auth_gov_id_verify_button')));
    await tester.pumpAndSettle();

    // Verify token is saved and navigates to onboarding
    final token = await inMemoryStorage.getToken();
    expect(token, isNotNull);
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
