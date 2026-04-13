import 'package:easypedv3/services/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ── Service ─────────────────────────────────────────────────────────

/// Singleton [SubscriptionService] provider.
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService.instance;
});

// ── Pro status ──────────────────────────────────────────────────────

/// Stream of whether the current user has an active `pro` entitlement.
///
/// Emits real-time updates via the RevenueCat customer info listener.
/// Falls back to `false` while loading or if RevenueCat is not yet initialised.
final isProProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(subscriptionServiceProvider);
  return service.isProStream;
});

// ── Offerings ───────────────────────────────────────────────────────

/// Available packages and localised prices from RevenueCat.
final offeringsProvider = FutureProvider<Offerings>((ref) async {
  final service = ref.watch(subscriptionServiceProvider);
  return service.getOfferings();
});

// ── Customer info ───────────────────────────────────────────────────

/// Full RevenueCat customer info (expiry date, plan type, etc.).
final customerInfoProvider = FutureProvider<CustomerInfo>((ref) async {
  final service = ref.watch(subscriptionServiceProvider);
  return service.getCustomerInfo();
});

// ── Usage tracking ──────────────────────────────────────────────────

/// Manages the daily dose-calculation counter for free users.
///
/// Uses Hive box `usage_tracking` with a date-keyed entry that resets daily.
class DoseUsageNotifier extends StateNotifier<int> {
  DoseUsageNotifier() : super(0) {
    _load();
  }

  static const _boxName = 'usage_tracking';
  static const _key = 'dose_calc';

  String get _todayKey => DateTime.now().toIso8601String().substring(0, 10);

  void _load() {
    final box = Hive.box(_boxName);
    final storedDate = box.get('${_key}_date') as String?;
    if (storedDate == _todayKey) {
      state = (box.get('${_key}_count') as int?) ?? 0;
    } else {
      // New day — reset.
      state = 0;
      box.put('${_key}_date', _todayKey);
      box.put('${_key}_count', 0);
    }
  }

  /// Increments the daily counter and persists it.
  void increment() {
    state++;
    final box = Hive.box(_boxName);
    box.put('${_key}_date', _todayKey);
    box.put('${_key}_count', state);
  }

  /// Maximum free calculations per day.
  static const int freeLimit = 3;
}

/// Current daily dose-calculation count.
final doseUsageProvider =
    StateNotifierProvider<DoseUsageNotifier, int>((ref) {
  return DoseUsageNotifier();
});
