import 'package:easypedv3/services/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ── Service ─────────────────────────────────────────────────────────

/// Singleton [SubscriptionService] provider.
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService.instance;
});

// ── Pro status ──────────────────────────────────────────────────────

/// Stream of whether the current user has an active `pro` entitlement.
///
/// Seeds with the current status from the RevenueCat cache, then emits
/// real-time updates whenever customer info changes.
final isProProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(subscriptionServiceProvider);

  // Seed with the latest known status.
  try {
    yield await service.isProUser();
  } catch (_) {
    yield false;
  }

  // Continue with real-time updates from the RevenueCat listener.
  yield* service.isProStream;
});

// ── Offerings ───────────────────────────────────────────────────────

/// Available packages and localised prices from RevenueCat.
final offeringsProvider = FutureProvider<Offerings>((ref) async {
  final service = ref.watch(subscriptionServiceProvider);
  return service.getOfferings();
});
