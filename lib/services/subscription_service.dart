import 'dart:async';
import 'dart:io';

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
    final apiKey = Platform.isIOS
        ? dotenv.env['REVENUECAT_APPLE_API_KEY']!
        : dotenv.env['REVENUECAT_GOOGLE_API_KEY']!;

    final configuration = PurchasesConfiguration(apiKey)..appUserID = userId;
    await Purchases.configure(configuration);

    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _isProController.add(
        customerInfo.entitlements.active.containsKey('pro'),
      );
    });
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
