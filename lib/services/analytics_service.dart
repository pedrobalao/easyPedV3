import 'package:firebase_analytics/firebase_analytics.dart';

/// Centralised analytics helper for the subscription conversion funnel.
///
/// All events follow the naming convention from Issue #71 and can be
/// visualised as a funnel in Firebase Analytics.
class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ── Paywall events ──────────────────────────────────────────────────

  /// Logged when the paywall screen opens.
  static Future<void> logPaywallViewed({required String source}) {
    return _analytics.logEvent(
      name: 'paywall_viewed',
      parameters: {'source': source},
    );
  }

  /// Logged when the user taps a plan card.
  static Future<void> logPaywallPlanSelected({required String plan}) {
    return _analytics.logEvent(
      name: 'paywall_plan_selected',
      parameters: {'plan': plan},
    );
  }

  /// Logged when the purchase flow begins.
  static Future<void> logPurchaseStarted({required String plan}) {
    return _analytics.logEvent(
      name: 'purchase_started',
      parameters: {'plan': plan},
    );
  }

  /// Logged on a successful purchase.
  static Future<void> logPurchaseCompleted({
    required String plan,
    required String price,
  }) {
    return _analytics.logEvent(
      name: 'purchase_completed',
      parameters: {'plan': plan, 'price': price},
    );
  }

  /// Logged when the user dismisses the purchase sheet.
  static Future<void> logPurchaseCancelled() {
    return _analytics.logEvent(name: 'purchase_cancelled');
  }

  /// Logged on a purchase error.
  static Future<void> logPurchaseFailed({required String errorCode}) {
    return _analytics.logEvent(
      name: 'purchase_failed',
      parameters: {'error_code': errorCode},
    );
  }

  /// Logged when the restore-purchases button is tapped.
  static Future<void> logRestorePurchasesTapped() {
    return _analytics.logEvent(name: 'restore_purchases_tapped');
  }

  // ── Feature gate events ─────────────────────────────────────────────

  /// Logged when a free user hits a feature gate.
  static Future<void> logFeatureGateHit({required String feature}) {
    return _analytics.logEvent(
      name: 'feature_gate_hit',
      parameters: {'feature': feature},
    );
  }

  // ── User property ───────────────────────────────────────────────────

  /// Sets the `subscription_status` user property.
  ///
  /// Possible values: `free`, `pro_monthly`, `pro_yearly`.
  static Future<void> setSubscriptionStatus(String status) {
    return _analytics.setUserProperty(
      name: 'subscription_status',
      value: status,
    );
  }
}
