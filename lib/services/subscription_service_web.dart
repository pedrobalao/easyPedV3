import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Web implementation of [SubscriptionService].
///
/// `purchases_flutter` does not support the web platform, so this
/// implementation talks to the RevenueCat REST API directly using the
/// public platform API key (`REVENUECAT_PUBLIC_API_KEY`) and the Firebase
/// UID as the RevenueCat app user ID. Purchases / restores are not
/// supported on the web — those throw `UnsupportedError`. Pro entitlement
/// is mirrored from mobile so a user who subscribed on iOS/Android sees
/// the Pro features when they sign in on the web.
///
/// Responses are cached for [_cacheTtl] to avoid hitting RevenueCat rate
/// limits on every gated screen.
///
/// Callers should additionally guard subscription-dependent UI behind the
/// `kSupportsRevenueCat` constant in `lib/utils/platform_support.dart`.
class SubscriptionService {
  SubscriptionService._();

  static final SubscriptionService instance = SubscriptionService._();

  /// REST endpoint base URL.
  static const String _baseUrl = 'https://api.revenuecat.com/v1';

  /// How long to cache a successful entitlement response.
  static const Duration _cacheTtl = Duration(minutes: 10);

  /// Entitlement identifier expected to be active for Pro users.
  static const String _proEntitlementId = 'pro';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final StreamController<bool> _isProController =
      StreamController<bool>.broadcast();

  /// Emits the latest known Pro status. Refreshes are driven from the
  /// provider layer (see `subscription_provider.dart`).
  Stream<bool> get isProStream => _isProController.stream;

  String? _userId;
  bool _isInitialized = false;

  bool? _cachedIsPro;
  DateTime? _cachedAt;

  /// Whether [init] has been called with a user ID.
  bool get isInitialized => _isInitialized;

  // ── Initialisation ──────────────────────────────────────────────────

  /// Stores the [userId] (Firebase UID) used for subsequent REST calls.
  /// Resets the entitlement cache so the next [isProUser] call hits the
  /// network. Safe to call multiple times.
  Future<void> init(String userId) async {
    if (_userId != userId) {
      _cachedIsPro = null;
      _cachedAt = null;
    }
    _userId = userId;
    _isInitialized = true;
  }

  /// No-op on web — there is nothing to lazily configure.
  Future<void> ensureInitialized() async {}

  // ── Status ──────────────────────────────────────────────────────────

  /// Returns `true` when the configured user has any active entitlement
  /// in the RevenueCat REST response (defaults to looking up the `pro`
  /// entitlement, falling back to "any active entitlement").
  ///
  /// Returns `false` (and never throws) when the API key is missing, the
  /// user is not configured, or the request fails. Successful responses
  /// are cached for [_cacheTtl] to avoid rate limits.
  Future<bool> isProUser() async {
    final userId = _userId;
    if (userId == null || userId.isEmpty) return false;

    // Serve from cache when fresh.
    final cached = _cachedIsPro;
    final cachedAt = _cachedAt;
    if (cached != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < _cacheTtl) {
      return cached;
    }

    final apiKey = dotenv.env['REVENUECAT_PUBLIC_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint(
        'SubscriptionService(web): REVENUECAT_PUBLIC_API_KEY is missing — '
        'returning free tier.',
      );
      return _updateCache(false);
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/subscribers/${Uri.encodeComponent(userId)}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Accept': 'application/json',
          },
        ),
      );

      final isPro = _hasActiveEntitlement(response.data);
      return _updateCache(isPro);
    } catch (e, st) {
      debugPrint('SubscriptionService(web).isProUser failed: $e\n$st');
      // On failure, prefer last known value (if any) over false to avoid
      // flickering Pro UI off due to transient errors.
      return _cachedIsPro ?? false;
    }
  }

  /// Parses a RevenueCat `/subscribers/{id}` response and returns whether
  /// the subscriber currently has any active entitlement (preferring
  /// the [_proEntitlementId] one).
  bool _hasActiveEntitlement(Map<String, dynamic>? data) {
    if (data == null) return false;
    final subscriber = data['subscriber'];
    if (subscriber is! Map) return false;
    final entitlements = subscriber['entitlements'];
    if (entitlements is! Map || entitlements.isEmpty) return false;

    final now = DateTime.now().toUtc();

    bool isActive(Object? entitlement) {
      if (entitlement is! Map) return false;
      final expires = entitlement['expires_date'];
      if (expires == null) {
        // Lifetime / non-expiring entitlement.
        return true;
      }
      if (expires is String) {
        final parsed = DateTime.tryParse(expires);
        if (parsed == null) return false;
        return parsed.toUtc().isAfter(now);
      }
      return false;
    }

    final pro = entitlements[_proEntitlementId];
    if (pro != null) return isActive(pro);

    return entitlements.values.any(isActive);
  }

  bool _updateCache(bool isPro) {
    _cachedIsPro = isPro;
    _cachedAt = DateTime.now();
    _isProController.add(isPro);
    return isPro;
  }

  // ── Unsupported on web ──────────────────────────────────────────────

  /// Throws to signal the operation is not available on the web stub.
  Future<CustomerInfo> getCustomerInfo() async {
    throw UnsupportedError(
      'SubscriptionService.getCustomerInfo is not supported on web.',
    );
  }

  /// Web cannot present a native paywall — return an empty offerings
  /// object so callers can render a friendly fallback instead of
  /// crashing when reading the `current` offering.
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
