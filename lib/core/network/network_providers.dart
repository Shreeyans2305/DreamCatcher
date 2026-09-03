import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import 'dio_client.dart';
import 'network_simulator_interceptor.dart';

/// Network simulation state representation.
class NetworkSimulatorState {
  final bool isEnabled;
  final bool simulateFailure;
  final int minLatencyMs;
  final int maxLatencyMs;

  const NetworkSimulatorState({
    this.isEnabled = true,
    this.simulateFailure = false,
    this.minLatencyMs = 300,
    this.maxLatencyMs = 1500,
  });

  NetworkSimulatorState copyWith({
    bool? isEnabled,
    bool? simulateFailure,
    int? minLatencyMs,
    int? maxLatencyMs,
  }) {
    return NetworkSimulatorState(
      isEnabled: isEnabled ?? this.isEnabled,
      simulateFailure: simulateFailure ?? this.simulateFailure,
      minLatencyMs: minLatencyMs ?? this.minLatencyMs,
      maxLatencyMs: maxLatencyMs ?? this.maxLatencyMs,
    );
  }
}

/// Notifier to toggle simulated rural network latency and connection failure.
class NetworkSimulatorNotifier extends StateNotifier<NetworkSimulatorState> {
  final NetworkSimulatorInterceptor interceptor;

  NetworkSimulatorNotifier(this.interceptor)
      : super(NetworkSimulatorState(
          isEnabled: interceptor.isEnabled,
          simulateFailure: interceptor.simulateFailure,
          minLatencyMs: interceptor.minLatencyMs,
          maxLatencyMs: interceptor.maxLatencyMs,
        ));

  void toggleEnabled(bool enabled) {
    interceptor.isEnabled = enabled;
    state = state.copyWith(isEnabled: enabled);
  }

  void toggleSimulateFailure(bool simulateFailure) {
    interceptor.simulateFailure = simulateFailure;
    state = state.copyWith(simulateFailure: simulateFailure);
  }

  void updateLatency({required int minMs, required int maxMs}) {
    interceptor.minLatencyMs = minMs;
    interceptor.maxLatencyMs = maxMs;
    state = state.copyWith(minLatencyMs: minMs, maxLatencyMs: maxMs);
  }
}

/// Singleton interceptor instance.
final simulatorInterceptorProvider = Provider<NetworkSimulatorInterceptor>((ref) {
  return NetworkSimulatorInterceptor();
});

/// Simulator state provider for UI toggling.
final networkSimulatorProvider =
    StateNotifierProvider<NetworkSimulatorNotifier, NetworkSimulatorState>((ref) {
  final interceptor = ref.watch(simulatorInterceptorProvider);
  return NetworkSimulatorNotifier(interceptor);
});

/// Dio client provider.
final dioClientProvider = Provider<DioClient>((ref) {
  final simulator = ref.watch(simulatorInterceptorProvider);
  return DioClient(simulator: simulator);
});

/// Provider for deciding whether mock repositories should be used.
final useMockRepositoriesProvider = StateProvider<bool>((ref) {
  return AppConfig.useMockRepositories;
});
