import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'network_simulator_interceptor.dart';

/// Network client wrapper around Dio.
/// Repositories call this client; widgets must never call Dio directly.
class DioClient {
  late final Dio dio;
  final NetworkSimulatorInterceptor simulatorInterceptor;

  DioClient({NetworkSimulatorInterceptor? simulator})
      : simulatorInterceptor = simulator ?? NetworkSimulatorInterceptor() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseApiUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add network simulation interceptor for testing poor connectivity
    dio.interceptors.add(simulatorInterceptor);

    // Optional safe logging interceptor that NEVER logs sensitive demographic data
    if (AppConfig.isDebug) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Log only method and path, strictly redact sensitive payload attributes
            return handler.next(options);
          },
          onError: (DioException e, handler) {
            return handler.next(e);
          },
        ),
      );
    }
  }
}
