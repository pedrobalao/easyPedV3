/// Re-exports the platform-appropriate `SubscriptionService` implementation.
///
/// On native platforms (iOS/Android/macOS/desktop) this resolves to the
/// RevenueCat-backed implementation in `subscription_service_io.dart`.
/// On the web — where `purchases_flutter` is not supported — it resolves to
/// a stub in `subscription_service_web.dart` that no-ops gracefully until a
/// REST-based implementation is wired in.
export 'subscription_service_io.dart'
    if (dart.library.html) 'subscription_service_web.dart';
