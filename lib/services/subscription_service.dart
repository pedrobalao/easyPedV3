import 'dart:async';
import 'dart:io';

import 'package:easypedv3/services/analytics_service.dart';
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

  // ── Initialisation ──────────────────────────────────────────────────

  /// Configures RevenueCat with the platform API key and associates [userId]
  /// (Firebase UID) as the RevenueCat app user ID.
  ///
  /// Registers a listener that pushes pro-status updates to [isProStream].
  Future<void> init(String userId) async {
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
  }

  /// Sets the Firebase Analytics `subscription_status` user property
  /// based on the current customer info.
  void _updateSubscriptionStatus(CustomerInfo info) {
    final proEntitlement = info.entitlements.active['pro'];
    if (proEntitlement == null) {
      AnalyticsService.setSubscriptionStatus('free');
      return;
    }
    final periodType = proEntitlement.periodType;
    if (periodType == PeriodType.annual) {
      AnalyticsService.setSubscriptionStatus('pro_yearly');
    } else if (periodType == PeriodType.monthly) {
      AnalyticsService.setSubscriptionStatus('pro_monthly');
    } else {
      AnalyticsService.setSubscriptionStatus('pro_monthly');
    }
  }

  // ── Status ──────────────────────────────────────────────────────────

  /// Returns `true` when the user has an active `pro` entitlement.
  Future<bool> isProUser() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }

  /// Returns full customer info including expiry date and plan type.
  Future<CustomerInfo> getCustomerInfo() async {
    return Purchases.getCustomerInfo();
  }

  // ── Offerings ───────────────────────────────────────────────────────

  /// Fetches available packages and their localised store prices.
  Future<Offerings> getOfferings() async {
    return Purchases.getOfferings();
  }

  // ── Purchases ───────────────────────────────────────────────────────

  /// Executes a purchase for [package].
  ///
  /// Returns updated [CustomerInfo] on success, or `null` when the user
  /// cancels the purchase sheet. Re-throws any other error.
  Future<CustomerInfo?> purchasePackage(Package package) async {
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
    return Purchases.restorePurchases();
  }
}
