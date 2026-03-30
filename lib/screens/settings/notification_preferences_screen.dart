import 'package:easypedv3/utils/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for managing notification topic subscriptions.
class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  late bool _newDrugs;
  late bool _guidelineUpdates;
  late bool _appUpdates;

  @override
  void initState() {
    super.initState();
    final service = ref.read(pushNotificationServiceProvider);
    _newDrugs = service.isSubscribed(PushNotificationService.topicNewDrugs);
    _guidelineUpdates =
        service.isSubscribed(PushNotificationService.topicGuidelineUpdates);
    _appUpdates =
        service.isSubscribed(PushNotificationService.topicAppUpdates);
  }

  Future<void> _toggleTopic(String topic, bool value) async {
    final service = ref.read(pushNotificationServiceProvider);
    if (value) {
      await service.subscribeToTopic(topic);
    } else {
      await service.unsubscribeFromTopic(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notificações'),
      ),
      body: ListView(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: colorScheme.primary.withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(Icons.notifications_active, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Escolha os tópicos sobre os quais deseja receber '
                    'notificações push.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Topic toggles
          SwitchListTile(
            secondary: const Icon(Icons.medication),
            title: const Text('Novos Medicamentos'),
            subtitle: const Text(
              'Receba alertas quando novos medicamentos forem adicionados.',
            ),
            value: _newDrugs,
            onChanged: (value) {
              setState(() => _newDrugs = value);
              _toggleTopic(PushNotificationService.topicNewDrugs, value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.menu_book),
            title: const Text('Atualizações de Guidelines'),
            subtitle: const Text(
              'Receba alertas quando guidelines forem atualizadas.',
            ),
            value: _guidelineUpdates,
            onChanged: (value) {
              setState(() => _guidelineUpdates = value);
              _toggleTopic(
                  PushNotificationService.topicGuidelineUpdates, value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.system_update),
            title: const Text('Atualizações da App'),
            subtitle: const Text(
              'Receba alertas sobre novas versões e funcionalidades.',
            ),
            value: _appUpdates,
            onChanged: (value) {
              setState(() => _appUpdates = value);
              _toggleTopic(PushNotificationService.topicAppUpdates, value);
            },
          ),
        ],
      ),
    );
  }
}
