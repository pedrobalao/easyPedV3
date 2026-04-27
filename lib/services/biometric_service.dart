import 'package:easypedv3/utils/platform_support.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

const _boxName = 'biometric_preferences';
const _enabledKey = 'biometric_enabled';
const _lastActiveKey = 'last_active_timestamp';

/// Timeout duration (in minutes) after which re-authentication is required.
const int kReauthTimeoutMinutes = 5;

/// Service that wraps [LocalAuthentication] for biometric / PIN auth.
class BiometricService {
  BiometricService({LocalAuthentication? localAuth})
      : _auth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  // ── Device capability checks ────────────────────────────────────────

  /// Whether the biometric APIs are available at all on this platform.
  ///
  /// Returns `false` on web, where `local_auth` is not supported.
  Future<bool> isAvailable() async {
    if (!kSupportsBiometrics) return false;
    return _auth.isDeviceSupported();
  }

  /// Whether the device supports any form of biometric or credential auth.
  Future<bool> isDeviceSupported() async {
    if (!kSupportsBiometrics) return false;
    return _auth.isDeviceSupported();
  }

  /// Whether biometrics (Face ID / Touch ID / fingerprint) are enrolled.
  Future<bool> canCheckBiometrics() async {
    if (!kSupportsBiometrics) return false;
    return _auth.canCheckBiometrics;
  }

  /// Lists available biometric types on the device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (!kSupportsBiometrics) return const <BiometricType>[];
    return _auth.getAvailableBiometrics();
  }

  // ── Authentication ──────────────────────────────────────────────────

  /// Triggers the native biometric / device-credential prompt.
  ///
  /// Returns `true` when the user authenticates successfully. On web — where
  /// biometric auth is not supported — this is a no-op that returns `true`
  /// so callers do not block the user.
  Future<bool> authenticate() async {
    if (!kSupportsBiometrics) return true;
    try {
      return await _auth.authenticate(
        localizedReason: 'Autentique-se para aceder ao easyPed',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  // ── Persisted preference ────────────────────────────────────────────

  /// Whether the user has opted-in to biometric lock.
  bool get isEnabled {
    try {
      final box = Hive.box(_boxName);
      return box.get(_enabledKey, defaultValue: false) as bool;
    } catch (_) {
      return false;
    }
  }

  /// Toggle the biometric-lock preference.
  Future<void> setEnabled({required bool enabled}) async {
    final box = Hive.box(_boxName);
    await box.put(_enabledKey, enabled);
  }

  // ── Background timer helpers ────────────────────────────────────────

  /// Persist the current timestamp so we know when the app was backgrounded.
  Future<void> recordLastActive() async {
    final box = Hive.box(_boxName);
    await box.put(_lastActiveKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Returns `true` when the app has been in the background longer than
  /// [kReauthTimeoutMinutes].
  bool shouldReauthenticate() {
    try {
      final box = Hive.box(_boxName);
      final lastActive = box.get(_lastActiveKey) as int?;
      if (lastActive == null) return false;

      final elapsed = DateTime.now().millisecondsSinceEpoch - lastActive;
      return elapsed > kReauthTimeoutMinutes * 60 * 1000;
    } catch (_) {
      return false;
    }
  }
}
