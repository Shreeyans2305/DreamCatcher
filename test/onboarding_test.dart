import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:dreamcatcherapp/core/database/app_database.dart';
import 'package:dreamcatcherapp/core/database/database_provider.dart';
import 'package:dreamcatcherapp/core/network/network_providers.dart';
import 'package:dreamcatcherapp/core/network/network_simulator_interceptor.dart';
import 'package:dreamcatcherapp/core/theme/app_theme.dart';
import 'package:dreamcatcherapp/core/widgets/sensitivity_notice.dart';


import 'package:dreamcatcherapp/features/auth/data/datasources/auth_token_storage.dart';
import 'package:dreamcatcherapp/features/auth/domain/models/auth_user.dart';
import 'package:dreamcatcherapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:dreamcatcherapp/features/home/presentation/home_screen.dart';
import 'package:dreamcatcherapp/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dreamcatcherapp/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:dreamcatcherapp/features/profile/domain/models/student_profile.dart';
import 'package:dreamcatcherapp/features/profile/domain/repositories/profile_repository.dart';
import 'package:dreamcatcherapp/features/profile/presentation/providers/profile_providers.dart';
import 'package:dreamcatcherapp/l10n/generated/app_localizations.dart';

/// Test implementation of ProfileRepository to inspect sync payloads
class TestProfileRepository implements ProfileRepository {
  StudentProfile? lastUpdatedProfile;
  int updateCallsCount = 0;

  @override
  Future<StudentProfile> getProfile(String studentId) async {
    return lastUpdatedProfile ??
        StudentProfile(
          id: studentId,
          name: 'Test Student',
          age: 17,
          state: 'Madhya Pradesh',
          district: 'Hoshangabad',
          incomeBracket: '< ₹1,50,000 / year',
          casteCategory: 'General',
          curriculum: 'State Board',
          skills: [],
          subjectsLearned: [],
          interests: [],
          aspirations: [],
        );
  }

  @override
  Future<void> updateProfile(StudentProfile profile) async {
    lastUpdatedProfile = profile;
    updateCallsCount++;
  }
}

Widget createTestOnboardingApp({
  required List<Override> overrides,
  String initialLocation = '/onboarding',
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
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
  testWidgets('Full onboarding wizard happy path completes all 6 steps and navigates to home',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final testDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => testDb.close());

    final testProfileRepo = TestProfileRepository();
    final inMemoryStorage = InMemoryAuthTokenStorage(
      initialUser: const AuthUser(
        id: 'usr_happy_001',
        displayName: 'Ramesh Kumar',
        token: 'mock_token',
        isProfileComplete: false,
      ),
    );

    await tester.pumpWidget(
      createTestOnboardingApp(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          profileRepositoryProvider.overrideWithValue(testProfileRepo),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
          currentUserIdProvider.overrideWithValue('usr_happy_001'),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Verify Onboarding Screen is open
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Basic Info'), findsOneWidget);


    // --- STEP 1: Basic Info ---
    expect(find.byKey(const Key('onboarding_name_input')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('onboarding_name_input')), 'Ramesh Kumar');
    await tester.enterText(find.byKey(const Key('onboarding_district_input')), 'Hoshangabad');
    await tester.pump();


    // Tap Get Started / Next to advance to Step 2
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // --- STEP 2: Family & Economic Context ---
    expect(find.text('Family Context'), findsOneWidget);
    expect(find.byType(SensitivityNotice), findsOneWidget);


    // Select income bracket and first-gen learner
    await tester.tap(find.byKey(const Key('income_chip_< ₹1,00,000 / year')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('first_gen_yes_chip')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // --- STEP 3: Academic Background ---
    expect(find.text('Education & Learning'), findsOneWidget);
    expect(find.byKey(const Key('formal_mode_btn')), findsOneWidget);
    expect(find.byKey(const Key('unstructured_mode_btn')), findsOneWidget);

    // Select a regional practical subject tag
    await tester.tap(find.byKey(const Key('subject_chip_Farming & Agriculture')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // --- STEP 4: Skills & Interests ---
    expect(find.text('Skills & Interests'), findsNWidgets(2));


    // Add a custom tag
    await tester.enterText(find.byKey(const Key('custom_tag_input')), 'Drone Repair');
    await tester.pump();
    await tester.tap(find.byKey(const Key('add_custom_tag_button')));
    await tester.pump();

    expect(find.text('Drone Repair'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // --- STEP 5: Aspirations ---
    expect(find.text('Career Aspirations'), findsOneWidget);

    // Tap a prompt chip
    await tester.tap(find.byKey(const Key('aspiration_chip_Want to start my own business or shop')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // --- STEP 6: Review & Submit ---
    expect(find.text('Review & Submit'), findsOneWidget);
    expect(find.text('Ramesh Kumar'), findsOneWidget);
    expect(find.text('Drone Repair'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_submit_button')), findsOneWidget);

    // Tap Submit Profile
    await tester.ensureVisible(find.byKey(const Key('onboarding_submit_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_submit_button')));
    await tester.pumpAndSettle();


    // Verify navigates to HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(testProfileRepo.updateCallsCount, equals(1));
    expect(testProfileRepo.lastUpdatedProfile?.name, equals('Ramesh Kumar'));
  });

  testWidgets('Resuming onboarding after app restart mid-flow preserves step and answers',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final testDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => testDb.close());

    final inMemoryStorage = InMemoryAuthTokenStorage(
      initialUser: const AuthUser(
        id: 'usr_resume_002',
        displayName: 'Sunita Patel',
        token: 'mock_token',
        isProfileComplete: false,
      ),
    );

    // Launch app session 1
    await tester.pumpWidget(
      createTestOnboardingApp(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
          currentUserIdProvider.overrideWithValue('usr_resume_002'),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Student fills Step 1: enters custom district "Betul"
    await tester.enterText(find.byKey(const Key('onboarding_district_input')), 'Betul');
    await tester.pump();

    // Advance to Step 2
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    expect(find.text('Family Context'), findsOneWidget);

    // Student fills Step 2: selects caste category 'SC'
    await tester.tap(find.byKey(const Key('caste_chip_SC')));
    await tester.pump();

    // Advance to Step 3
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    expect(find.text('Education & Learning'), findsOneWidget);

    // --- SIMULATE APP RESTART / FORCE CLOSE ---
    // Dispose the widget tree completely
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();

    // Re-launch app with the SAME Drift database
    await tester.pumpWidget(
      createTestOnboardingApp(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
          currentUserIdProvider.overrideWithValue('usr_resume_002'),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Verify app resumed on Step 3 (Education & Learning) instead of resetting to Step 1!
    expect(find.text('Education & Learning'), findsOneWidget);
    expect(find.text('Step 3 of 6'), findsOneWidget);

    // Tap Back to verify Step 2's answers were preserved
    await tester.tap(find.byKey(const Key('onboarding_back_button')));
    await tester.pumpAndSettle();

    expect(find.text('Family Context'), findsOneWidget);

    // Tap Back to verify Step 1's answers were preserved
    await tester.tap(find.byKey(const Key('onboarding_back_button')));
    await tester.pumpAndSettle();

    expect(find.text('Basic Info'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Betul'), findsOneWidget);
  });

  testWidgets('Offline submission is queued in Drift with isPendingSync and synced when connectivity returns',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final testDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() => testDb.close());

    final testProfileRepo = TestProfileRepository();
    final inMemoryStorage = InMemoryAuthTokenStorage(
      initialUser: const AuthUser(
        id: 'usr_offline_003',
        displayName: 'Deepak Verma',
        token: 'mock_token',
        isProfileComplete: false,
      ),
    );

    // Create network simulator set to offline
    final interceptor = NetworkSimulatorInterceptor();
    final networkNotifier = NetworkSimulatorNotifier(interceptor);
    networkNotifier.toggleSimulateFailure(true); // Simulate offline

    await tester.pumpWidget(
      createTestOnboardingApp(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          profileRepositoryProvider.overrideWithValue(testProfileRepo),
          authTokenStorageProvider.overrideWithValue(inMemoryStorage),
          networkSimulatorProvider.overrideWith((ref) => networkNotifier),
          currentUserIdProvider.overrideWithValue('usr_offline_003'),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Step 1 -> Next
    await tester.enterText(find.byKey(const Key('onboarding_district_input')), 'Vidisha');
    await tester.pump();
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Step 2 -> Next
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Step 3 -> Next
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Step 4 -> Next
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Step 5 -> Next
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Step 6: Review Screen
    expect(find.text('Review & Submit'), findsOneWidget);
    expect(find.text('You are currently offline. Your profile will be saved on your device and automatically synced once you reconnect.'),
        findsOneWidget);

    // Ensure submit button is scrolled into view and tap it
    await tester.ensureVisible(find.byKey(const Key('onboarding_submit_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_submit_button')));
    await tester.pumpAndSettle();

    // Student should NOT be blocked: navigates to HomeScreen with offline message
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Profile saved offline! It will automatically sync when connected to the internet.'),
        findsOneWidget);

    // Verify remote repository has NOT been updated yet
    expect(testProfileRepo.updateCallsCount, equals(0));

    // Verify Drift database queued the profile with isPendingSync = true
    final cachedProfile = await testDb.getProfile('usr_offline_003');
    expect(cachedProfile, isNotNull);
    expect(cachedProfile!.isPendingSync, isTrue);

    // Verify OnboardingDrafts has pending sync item
    final pendingDrafts = await testDb.getPendingSyncDrafts();
    expect(pendingDrafts.length, equals(1));

    // Verify student session was marked complete so they are never forced back to onboarding
    final savedUser = await inMemoryStorage.getCachedUser();
    expect(savedUser?.isProfileComplete, isTrue);

    // --- RECONNECTIVITY EVENT ---
    // Simulate connectivity being restored
    networkNotifier.toggleSimulateFailure(false);

    // Trigger sync
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(testDb),
        profileRepositoryProvider.overrideWithValue(testProfileRepo),
        networkSimulatorProvider.overrideWith((ref) => networkNotifier),
      ],
    );
    addTearDown(() => container.dispose());

    final syncedCount = await container.read(onboardingStateProvider.notifier).syncPending();
    expect(syncedCount, greaterThanOrEqualTo(1));

    // Verify remote repository now received the profile update
    expect(testProfileRepo.updateCallsCount, greaterThanOrEqualTo(1));
    expect(testProfileRepo.lastUpdatedProfile?.id, equals('usr_offline_003'));
    expect(testProfileRepo.lastUpdatedProfile?.district, equals('Vidisha'));

    // Verify pending sync items are flushed
    final remainingPending = await testDb.getPendingSyncDrafts();
    expect(remainingPending.isEmpty, isTrue);
  });
}

