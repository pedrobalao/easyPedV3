import 'package:easypedv3/services/biometric_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Singleton [BiometricService] provider.
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

/// Whether biometric lock is currently enabled (persisted preference).
final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
  final service = ref.watch(biometricServiceProvider);
  return BiometricEnabledNotifier(service);
});

class BiometricEnabledNotifier extends StateNotifier<bool> {
  BiometricEnabledNotifier(this._service) : super(_service.isEnabled);

  final BiometricService _service;

  Future<void> toggle() async {
    final newValue = !state;
    await _service.setEnabled(enabled: newValue);
    state = newValue;
  }

  Future<void> setEnabled({required bool enabled}) async {
    await _service.setEnabled(enabled: enabled);
    state = enabled;
  }
}

/// Tracks whether the user has passed biometric auth in the current session.
final biometricAuthenticatedProvider = StateProvider<bool>((ref) => false);
