import 'package:purchases_flutter/purchases_flutter.dart';

/// Web stub for [SubscriptionService].
///
/// `purchases_flutter` does not support the web platform, so this
/// implementation never calls the RevenueCat SDK. All accessors return
/// safe defaults (free tier, empty offerings) until a REST-based
/// implementation is wired in (tracked separately).
///
/// Callers should additionally guard subscription-dependent UI behind the
/// `kSupportsRevenueCat` constant in `lib/utils/platform_support.dart`.
class SubscriptionService {
  SubscriptionService._();

  static final SubscriptionService instance = SubscriptionService._();

  /// Broadcast stream that always emits `false` to every new subscriber and
  /// never completes — matching the always-free behaviour of the web stub.
  Stream<bool> get isProStream =>
      Stream<bool>.multi((controller) => controller.add(false));

  /// Web stub is considered initialised immediately.
  bool get isInitialized => true;

  /// No-op on web.
  Future<void> init(String userId) async {}

  /// No-op on web.
  Future<void> ensureInitialized() async {}

  /// Always returns `false` on the web stub.
  Future<bool> isProUser() async => false;

  /// Throws to signal the operation is not available on the web stub.
  Future<CustomerInfo> getCustomerInfo() async {
    throw UnsupportedError(
      'SubscriptionService.getCustomerInfo is not supported on web.',
    );
  }

  /// Throws to signal the operation is not available on the web stub.
  Future<Offerings> getOfferings() async {
    throw UnsupportedError(
      'SubscriptionService.getOfferings is not supported on web.',
    );
  }

  /// Throws to signal the operation is not available on the web stub.
  Future<CustomerInfo?> purchasePackage(Package package) async {
    throw UnsupportedError(
      'SubscriptionService.purchasePackage is not supported on web.',
    );
  }

  /// Throws to signal the operation is not available on the web stub.
  Future<CustomerInfo> restorePurchases() async {
    throw UnsupportedError(
      'SubscriptionService.restorePurchases is not supported on web.',
    );
  }
}
