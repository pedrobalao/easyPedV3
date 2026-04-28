import 'package:easypedv3/utils/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Wraps child routes in an adaptive navigation shell.
///
/// * Compact  (< 600 px)  → [NavigationBar] at the bottom (mobile default).
/// * Medium   (600–1200)  → collapsed [NavigationRail] on the left.
/// * Expanded (> 1200 px) → extended [NavigationRail] with labels on the left.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final windowSize = windowSizeOf(context);

    if (windowSize == WindowSizeClass.compact) {
      // ── Mobile: bottom navigation bar ───────────────────────────────
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication_outlined),
              selectedIcon: Icon(Icons.medication),
              label: 'Medicamentos',
            ),
            NavigationDestination(
              icon: Icon(Icons.coronavirus_outlined),
              selectedIcon: Icon(Icons.coronavirus),
              label: 'Doenças',
            ),
            NavigationDestination(
              icon: Icon(Icons.build_outlined),
              selectedIcon: Icon(Icons.build),
              label: 'Ferramentas',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info),
              label: 'Sobre',
            ),
          ],
        ),
      );
    }

    // ── Tablet / Desktop: side navigation rail ─────────────────────────
    final isExtended = windowSize == WindowSizeClass.expanded;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            extended: isExtended,
            labelType: isExtended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.medication_outlined),
                selectedIcon: Icon(Icons.medication),
                label: Text('Medicamentos'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.coronavirus_outlined),
                selectedIcon: Icon(Icons.coronavirus),
                label: Text('Doenças'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build_outlined),
                selectedIcon: Icon(Icons.build),
                label: Text('Ferramentas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.info_outline),
                selectedIcon: Icon(Icons.info),
                label: Text('Sobre'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
