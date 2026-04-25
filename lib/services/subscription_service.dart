import 'dart:async';
import 'dart:io';

import 'package:easypedv3/services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Wraps the RevenueCat SDK for cross-platform subscription management.
///
/// Use [instance] to access the singleton. Call [init] once the Firebase
/// user ID is available to configure RevenueCat and associate the user.
class SubscriptionService {
  SubscriptionService._();

  static final SubscriptionService instance = SubscriptionService._();

  final StreamController<bool> _isProController =
      StreamController<bool>.broadcast();

  /// Emits the pro-status in real-time whenever customer info changes.
  Stream<bool> get isProStream => _isProController.stream;

  /// Set once [init] has successfully configured the RevenueCat SDK.
  bool _isInitialized = false;

  /// In-flight init future used to coalesce concurrent callers.
  Future<void>? _initFuture;

  /// Whether RevenueCat has been configured for this session.
  bool get isInitialized => _isInitialized;

  // ── Initialisation ──────────────────────────────────────────────────

  /// Configures RevenueCat with the platform API key and associates [userId]
  /// (Firebase UID) as the RevenueCat app user ID.
  ///
  /// Safe to call multiple times: subsequent calls with the same [userId] are
  /// no-ops, while a different [userId] triggers `Purchases.logIn`.
  ///
  /// Registers a listener that pushes pro-status updates to [isProStream].
  Future<void> init(String userId) async {
    if (_isInitialized) {
      try {
        await Purchases.logIn(userId);
      } catch (e, st) {
        debugPrint('SubscriptionService.logIn failed: $e\n$st');
      }
      return;
    }
    final existing = _initFuture;
    if (existing != null) {
      return existing;
    }
    final future = _doInit(userId);
    _initFuture = future;
    try {
      await future;
    } finally {
      _initFuture = null;
    }
  }

  Future<void> _doInit(String userId) async {
    final appleKey = dotenv.env['REVENUECAT_APPLE_API_KEY'];
    final googleKey = dotenv.env['REVENUECAT_GOOGLE_API_KEY'];

    assert(
      appleKey != null && appleKey.isNotEmpty,
      'REVENUECAT_APPLE_API_KEY is missing from .env',
    );
    assert(
      googleKey != null && googleKey.isNotEmpty,
      'REVENUECAT_GOOGLE_API_KEY is missing from .env',
    );

    final apiKey = Platform.isIOS
        ? appleKey ?? (throw StateError('REVENUECAT_APPLE_API_KEY not set'))
        : googleKey ?? (throw StateError('REVENUECAT_GOOGLE_API_KEY not set'));

    final configuration = PurchasesConfiguration(apiKey)..appUserID = userId;
    await Purchases.configure(configuration);

    // Emit the current status immediately, then track future changes.
    final initial = await Purchases.getCustomerInfo();
    _isProController.add(initial.entitlements.active.containsKey('pro'));
    _updateSubscriptionStatus(initial);

    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _isProController.add(
        customerInfo.entitlements.active.containsKey('pro'),
      );
      _updateSubscriptionStatus(customerInfo);
    });

    _isInitialized = true;
  }

  /// Ensures RevenueCat has been configured for the currently signed-in
  /// Firebase user before performing any SDK call.
  ///
  /// This is a defensive safety net for code paths that try to fetch
  /// offerings/customer info before [init] has been called from `main.dart`
  /// (e.g. when the user signs in after app startup).
  Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError(
        'RevenueCat is not initialised: no Firebase user is signed in.',
      );
    }
    await init(user.uid);
  }

  /// Sets the Firebase Analytics `subscription_status` user property
  /// based on the current customer info.
  void _updateSubscriptionStatus(CustomerInfo info) {
    final proEntitlement = info.entitlements.active['pro'];
    if (proEntitlement == null) {
      AnalyticsService.setSubscriptionStatus('free');
      return;
    }
    final id = (proEntitlement.productPlanIdentifier ??
            proEntitlement.productIdentifier)
        .toLowerCase();
    if (id.contains('annual') || id.contains('year')) {
      AnalyticsService.setSubscriptionStatus('pro_yearly');
    } else {
      AnalyticsService.setSubscriptionStatus('pro_monthly');
    }
  }

  // ── Status ──────────────────────────────────────────────────────────

  /// Returns `true` when the user has an active `pro` entitlement.
  Future<bool> isProUser() async {
    try {
      await ensureInitialized();
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }

  /// Returns full customer info including expiry date and plan type.
  Future<CustomerInfo> getCustomerInfo() async {
    await ensureInitialized();
    return Purchases.getCustomerInfo();
  }

  // ── Offerings ───────────────────────────────────────────────────────

  /// Fetches available packages and their localised store prices.
  Future<Offerings> getOfferings() async {
    await ensureInitialized();
    return Purchases.getOfferings();
  }

  // ── Purchases ───────────────────────────────────────────────────────

  /// Executes a purchase for [package].
  ///
  /// Returns updated [CustomerInfo] on success, or `null` when the user
  /// cancels the purchase sheet. Re-throws any other error.
  Future<CustomerInfo?> purchasePackage(Package package) async {
    await ensureInitialized();
    try {
      return await Purchases.purchasePackage(package);
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) ==
          PurchasesErrorCode.purchaseCancelledError) {
        return null;
      }
      rethrow;
    }
  }

  /// Restores previous purchases and re-links them to the current user.
  Future<CustomerInfo> restorePurchases() async {
    await ensureInitialized();
    return Purchases.restorePurchases();
  }
}
