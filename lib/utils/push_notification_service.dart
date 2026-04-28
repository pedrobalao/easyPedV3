import 'package:easypedv3/utils/platform_support.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

/// Handles background messages when the app is terminated or in background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background message received: ${message.messageId}');
  }
}

/// Service for managing Firebase Cloud Messaging with topic-based subscriptions.
class PushNotificationService {
  PushNotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  static const String _boxName = 'notification_preferences';

  // Topic constants
  static const String topicNewDrugs = 'new_drugs';
  static const String topicGuidelineUpdates = 'guideline_updates';
  static const String topicAppUpdates = 'app_updates';

  /// All available topics with their display names.
  static const Map<String, String> availableTopics = {
    topicNewDrugs: 'Novos Medicamentos',
    topicGuidelineUpdates: 'Atualizações de Guidelines',
    topicAppUpdates: 'Atualizações da App',
  };

  Box get _box => Hive.box(_boxName);

  /// Initialise the push notification service:
  /// - Request permissions on iOS
  /// - Get and log the FCM token
  /// - Set up message handlers
  /// - Restore topic subscriptions
  ///
  /// On web (where FCM is not wired up here) this is a no-op.
  Future<void> initialise() async {
    if (!kSupportsPushNotifications) return;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _messaging.requestPermission();
    }

    final token = await _messaging.getToken();
    if (kDebugMode) {
      print('FirebaseMessaging token: $token');
    }

    // Set up foreground message handler.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Set up handler for when user taps a notification (app was in background).
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a notification while terminated.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // Set up background message handler.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Restore saved topic subscriptions.
    await _restoreSubscriptions();
  }

  /// Subscribe to a notification topic.
  Future<void> subscribeToTopic(String topic) async {
    if (!kSupportsPushNotifications) {
      await _box.put(topic, true);
      return;
    }
    await _messaging.subscribeToTopic(topic);
    await _box.put(topic, true);
  }

  /// Unsubscribe from a notification topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!kSupportsPushNotifications) {
      await _box.put(topic, false);
      return;
    }
    await _messaging.unsubscribeFromTopic(topic);
    await _box.put(topic, false);
  }

  /// Whether the user is currently subscribed to a topic.
  bool isSubscribed(String topic) {
    return _box.get(topic, defaultValue: false) as bool;
  }

  /// Re-subscribe to all previously selected topics.
  Future<void> _restoreSubscriptions() async {
    if (!kSupportsPushNotifications) return;
    for (final topic in availableTopics.keys) {
      if (isSubscribed(topic)) {
        await _messaging.subscribeToTopic(topic);
      }
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Foreground message: ${message.notification?.title}');
    }
  }

  /// Deep-link navigation based on notification data payload.
  ///
  /// Call this from the app-level where the [GoRouter] instance is accessible,
  /// e.g. after consuming a pending notification message via
  /// [consumePendingMessage].
  static void handleDeepLink(
    RemoteMessage message,
    GoRouter router,
  ) {
    final data = message.data;
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    switch (type) {
      case 'drug':
        if (id != null) router.go('/drugs/$id');
      case 'disease':
        if (id != null) router.go('/diseases/$id');
      case 'calculator':
        if (id != null) router.go('/tools/medical-calculations/$id');
      case 'guideline':
        router.go('/');
      default:
        router.go('/');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tapped: ${message.data}');
    }
    // Deep linking is handled via GoRouter from the app level,
    // where the router instance is accessible. Store the pending
    // message so the app can navigate when ready.
    _pendingMessage = message;
  }

  /// Pending notification message for deep linking.
  RemoteMessage? _pendingMessage;

  /// Consume the pending notification message for deep linking.
  RemoteMessage? consumePendingMessage() {
    final message = _pendingMessage;
    _pendingMessage = null;
    return message;
  }
}

/// Riverpod provider for the push notification service.
final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});
