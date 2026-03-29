import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A grid of quick-access feature tiles for the home screen dashboard.
class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const _items = <_QuickAccessItem>[
    _QuickAccessItem(
      title: 'Medicamentos',
      icon: Icons.medication,
      route: '/drugs',
    ),
    _QuickAccessItem(
      title: 'Doenças',
      icon: Icons.coronavirus,
      route: '/diseases',
    ),
    _QuickAccessItem(
      title: 'Cálculos',
      icon: Icons.calculate,
      route: '/tools/medical-calculations',
    ),
    _QuickAccessItem(
      title: 'Percentis',
      icon: Icons.percent,
      route: '/tools/percentiles',
    ),
    _QuickAccessItem(
      title: 'Ref. Cirúrgica',
      icon: Icons.meeting_room,
      route: '/tools/surgeries-referral',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: _items
          .map((item) => _QuickAccessTile(item: item, colorScheme: colorScheme))
          .toList(),
    );
  }
}

class _QuickAccessItem {
  const _QuickAccessItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final IconData icon;
  final String route;
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({
    required this.item,
    required this.colorScheme,
  });

  final _QuickAccessItem item;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go(item.route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 32, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
