import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/design_tokens.dart';
import 'data/api_client.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/opportunities_provider.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DreamCatcherApp());
}

class DreamCatcherApp extends StatelessWidget {
  const DreamCatcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DreamCatcherApiClient>(
          create: (_) => DreamCatcherApiClient(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<DreamCatcherApiClient>()),
        ),
        ChangeNotifierProxyProvider2<DreamCatcherApiClient, AuthProvider, OnboardingProvider>(
          create: (context) => OnboardingProvider(
            context.read<DreamCatcherApiClient>(),
            context.read<AuthProvider>(),
          ),
          update: (_, client, auth, previous) =>
              previous ?? OnboardingProvider(client, auth),
        ),
        ChangeNotifierProxyProvider2<DreamCatcherApiClient, AuthProvider, OpportunitiesProvider>(
          create: (context) => OpportunitiesProvider(
            context.read<DreamCatcherApiClient>(),
            context.read<AuthProvider>(),
          ),
          update: (_, client, auth, previous) =>
              previous ?? OpportunitiesProvider(client, auth),
        ),
        ChangeNotifierProxyProvider3<DreamCatcherApiClient, AuthProvider, OpportunitiesProvider, ChatProvider>(
          create: (context) => ChatProvider(
            context.read<DreamCatcherApiClient>(),
            context.read<AuthProvider>(),
            context.read<OpportunitiesProvider>(),
          ),
          update: (_, client, auth, opps, previous) =>
              previous ?? ChatProvider(client, auth, opps),
        ),
      ],
      child: Consumer2<AuthProvider, OnboardingProvider>(
        builder: (context, auth, onboarding, child) {
            final languageCode = auth.isAuthenticated
              ? auth.preferredLanguage
              : onboarding.preferredLanguage;
          final locale = AppLocalizations.supportedLocales.firstWhere(
            (supportedLocale) => supportedLocale.languageCode == languageCode,
            orElse: () => AppLocalizations.supportedLocales.first,
          );

          return MaterialApp(
            title: 'DreamCatcher',
            locale: locale,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return const Scaffold(
        backgroundColor: DesignTokens.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: DesignTokens.primary),
              SizedBox(height: 16),
              Text(
                'Starting DreamCatcher...',
                style: TextStyle(
                  fontSize: 16,
                  color: DesignTokens.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (auth.isAuthenticated) {
      return const MainShell();
    }

    return const OnboardingScreen();
  }
}
