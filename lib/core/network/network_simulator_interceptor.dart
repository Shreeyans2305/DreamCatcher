import 'dart:math';
import 'package:dio/dio.dart';

/// Dio interceptor to simulate poor rural connectivity (latency between 300-1500ms)
/// and intermittent failure conditions.
class NetworkSimulatorInterceptor extends Interceptor {
  bool isEnabled;
  bool simulateFailure;
  int minLatencyMs;
  int maxLatencyMs;

  final Random _random = Random();

  NetworkSimulatorInterceptor({
    this.isEnabled = true,
    this.simulateFailure = false,
    this.minLatencyMs = 300,
    this.maxLatencyMs = 1500,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!isEnabled) {
      return handler.next(options);
    }

    // Simulate 2G/3G network latency between minLatencyMs and maxLatencyMs
    final int delayMs = minLatencyMs + _random.nextInt(max(1, maxLatencyMs - minLatencyMs));
    await Future.delayed(Duration(milliseconds: delayMs));

    if (simulateFailure) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Simulated network offline/unreachable error',
          type: DioExceptionType.connectionError,
        ),
      );
    }

    return handler.next(options);
  }
}
