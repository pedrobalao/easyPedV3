import 'package:flutter/foundation.dart';

/// Single source of truth for which features are supported on the current
/// platform. Use these constants in place of scattered `kIsWeb` /
/// `Platform.is*` checks so that web builds can reliably skip native-only
/// integrations.
///
/// All constants are `false` on web. Mobile/desktop platforms get the same
/// support as before.

/// Whether RevenueCat (in-app purchases) can be used on this platform.
const bool kSupportsRevenueCat = !kIsWeb;

/// Whether the local biometric / device-credential APIs are available.
const bool kSupportsBiometrics = !kIsWeb;

/// Whether local notifications can be scheduled / displayed.
const bool kSupportsLocalNotifications = !kIsWeb;

/// Whether the Firebase Vertex AI chat experience is supported.
const bool kSupportsAiChat = !kIsWeb;

/// Whether Firebase Cloud Messaging push notifications can be used.
const bool kSupportsPushNotifications = !kIsWeb;
