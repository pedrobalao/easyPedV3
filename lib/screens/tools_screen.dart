import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/pro_feature_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Parent screen for the Tools tab that combines calculators, percentiles,
/// and surgery referral into a single entry point.
class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  /// Routes that are gated behind Pro.
  static const _proRoutes = <String>{
    '/tools/ai-assistant',
    '/tools/clinical-notes',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(isProProvider).value ?? false;

    final items = <_ToolItem>[
      const _ToolItem(
        title: 'Assistente IA',
        icon: Icons.smart_toy,
        route: '/tools/ai-assistant',
      ),
      const _ToolItem(
        title: 'Percentis',
        icon: Icons.percent,
        route: '/tools/percentiles',
      ),
      const _ToolItem(
        title: 'Cálculos Médicos',
        icon: Icons.calculate,
        route: '/tools/medical-calculations',
      ),
      const _ToolItem(
        title: 'Referenciação Cirúrgica',
        icon: Icons.meeting_room,
        route: '/tools/surgeries-referral',
      ),
      const _ToolItem(
        title: 'Sinais Vitais por Idade',
        icon: Icons.monitor_heart,
        route: '/tools/vital-signs',
      ),
      const _ToolItem(
        title: 'Escala de Glasgow',
        icon: Icons.psychology,
        route: '/tools/glasgow-scale',
      ),
      const _ToolItem(
        title: 'Score de APGAR',
        icon: Icons.child_care,
        route: '/tools/apgar-score',
      ),
      const _ToolItem(
        title: 'Fluidoterapia',
        icon: Icons.water_drop,
        route: '/tools/fluid-resuscitation',
      ),
      const _ToolItem(
        title: 'Notas Clínicas',
        icon: Icons.note_alt,
        route: '/tools/clinical-notes',
      ),
    ];

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Ferramentas')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isGated = !isPro && _proRoutes.contains(item.route);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: Icon(item.icon, color: const Color(0xFF2963C8)),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  if (isGated) ...[
                    const SizedBox(width: 8),
                    const ProBadge(),
                  ],
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(item.route),
            ),
          );
        },
      ),
    );
  }
}

class _ToolItem {
  const _ToolItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final IconData icon;
  final String route;
}
