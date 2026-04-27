import 'package:easypedv3/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// A layout helper that renders a master/detail split on medium and expanded
/// screens, and falls back to showing only the master on compact screens.
///
/// On **compact** screens, detail navigation is handled externally (e.g. by
/// a GoRouter push). On wider screens, the detail is rendered in the right
/// pane next to the master list.
class MasterDetailScaffold extends StatelessWidget {
  const MasterDetailScaffold({
    required this.master,
    required this.detail,
    this.masterWidth = 340.0,
    super.key,
  });

  /// The master (list) panel content.
  final Widget master;

  /// The detail panel content. Displayed only on medium/expanded screens.
  final Widget detail;

  /// Width of the master panel on medium/expanded screens.
  final double masterWidth;

  @override
  Widget build(BuildContext context) {
    if (isCompact(context)) {
      return master;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: masterWidth, child: master),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: detail),
      ],
    );
  }
}

/// Default placeholder shown in the detail pane when no item is selected.
class EmptyDetailPane extends StatelessWidget {
  const EmptyDetailPane({
    this.message = 'Seleciona um item para ver os detalhes',
    this.icon = Icons.touch_app_outlined,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
