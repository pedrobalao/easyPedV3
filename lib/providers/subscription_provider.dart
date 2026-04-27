import 'dart:async';

import 'package:easypedv3/services/subscription_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ── Service ─────────────────────────────────────────────────────────

/// Singleton [SubscriptionService] provider.
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService.instance;
});

// ── Pro status ──────────────────────────────────────────────────────

/// How often to refresh the Pro entitlement on the web. Mirrors the cache
/// TTL used inside `SubscriptionService` (web implementation).
const Duration _webProRefreshInterval = Duration(minutes: 10);

/// Stream of whether the current user has an active `pro` entitlement.
///
/// On native platforms this is driven by the RevenueCat customer info
/// listener registered in `SubscriptionService.init`.
///
/// On the web — where the SDK is unavailable — there is no native
/// listener, so we manually refresh the status:
///   * once on construction,
///   * whenever the Firebase auth state changes,
///   * whenever the app returns to the foreground
///     (`AppLifecycleState.resumed`),
///   * and on a periodic timer every [_webProRefreshInterval].
final isProProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(subscriptionServiceProvider);

  if (!kIsWeb) {
    return service.isProStream;
  }

  // ── Web refresh strategy ──
  Future<void> refresh() async {
    try {
      await service.isProUser();
    } catch (e, st) {
      debugPrint('isProProvider(web) refresh failed: $e\n$st');
    }
  }

  // Refresh whenever the signed-in user changes.
  final authSub =
      FirebaseAuth.instance.authStateChanges().listen((_) => refresh());

  // Refresh on app resume.
  final lifecycleListener = _AppLifecycleListener(onResume: refresh);

  // Periodic refresh.
  final timer = Timer.periodic(_webProRefreshInterval, (_) => refresh());

  // Kick off an immediate refresh so the cached value is populated.
  refresh();

  ref.onDispose(() {
    timer.cancel();
    authSub.cancel();
    lifecycleListener.dispose();
  });

  return service.isProStream;
});

/// Lightweight wrapper around [WidgetsBinding] lifecycle callbacks so the
/// provider can react to `AppLifecycleState.resumed` without requiring a
/// surrounding widget.
class _AppLifecycleListener with WidgetsBindingObserver {
  _AppLifecycleListener({required this.onResume}) {
    WidgetsBinding.instance.addObserver(this);
  }

  final Future<void> Function() onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

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
