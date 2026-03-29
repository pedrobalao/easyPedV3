import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Parent screen for the Tools tab that combines calculators, percentiles,
/// and surgery referral into a single entry point.
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ToolItem>[
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
    ];

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Ferramentas')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: Icon(item.icon, color: const Color(0xFF2963C8)),
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.displaySmall,
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
