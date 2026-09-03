/// Application runtime configuration.
class AppConfig {
  AppConfig._();

  /// Flag indicating whether mock repositories should be used.
  /// When true, Mock repositories are injected instead of real HTTP repositories.
  static bool useMockRepositories = true;

  /// Debug mode flag.
  static bool isDebug = true;

  /// Base API URL for future production backend.
  static const String baseApiUrl = 'https://api.dreamcatcher.app/v1';

  /// Default timeout for network calls (longer for 2G/3G conditions).
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
