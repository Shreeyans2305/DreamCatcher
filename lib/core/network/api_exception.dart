/// Base exception class for network and data layer errors in DreamCatcher.
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkOrOfflineError;

  const AppException({
    required this.message,
    this.statusCode,
    this.isNetworkOrOfflineError = false,
  });

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode, isOffline: $isNetworkOrOfflineError)';
}

class NetworkOfflineException extends AppException {
  const NetworkOfflineException({
    super.message = 'No internet connection. Please check your network and try again.',
  }) : super(isNetworkOrOfflineError: true);
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });
}
