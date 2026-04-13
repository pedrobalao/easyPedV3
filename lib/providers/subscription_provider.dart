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
