import 'dart:developer';
import 'package:easypedv3/providers/biometric_provider.dart';
import 'package:easypedv3/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _Menu {
  _Menu({required this.title, required this.icon, required this.route});

  final String title;
  final Icon icon;
  final String route;
}

class Menu extends ConsumerWidget {
  const Menu({super.key});

  List<_Menu> _menus() {
    return [
      _Menu(title: 'Home', icon: const Icon(Icons.home), route: '/'),
      _Menu(
          title: 'Medicamentos',
          icon: const Icon(Icons.polyline_outlined),
          route: '/drugs'),
      _Menu(
          title: 'Doenças',
          icon: const Icon(Icons.coronavirus),
          route: '/diseases'),
      _Menu(
          title: 'Percentis',
          icon: const Icon(Icons.percent),
          route: '/percentiles'),
      _Menu(
          title: 'Calculos Médicos',
          icon: const Icon(Icons.calculate),
          route: '/medical-calculations'),
      _Menu(
          title: 'Referenciação Cirúrgica',
          icon: const Icon(Icons.meeting_room),
          route: '/surgeries-referral'),
      _Menu(
          title: 'Sobre',
          icon: const Icon(Icons.app_shortcut),
          route: '/about'),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final biometricLockEnabled = ref.watch(biometricEnabledProvider);

    var email = 'your@email.com';
    var name = 'user';
    var photoUrl = '';

    try {
      if (user!.providerData.isNotEmpty) {
        for (final provider in user.providerData) {
          if (provider.displayName != null &&
              provider.displayName!.isNotEmpty) {
            name = provider.displayName!;
          }
          if (provider.photoURL != null && provider.photoURL!.isNotEmpty) {
            photoUrl = provider.photoURL!;
          }
          if (provider.email != null && provider.email!.isNotEmpty) {
            email = provider.email!;
          }
        }
      } else {
        email = user.email!;
        name = user.displayName!;
        photoUrl = user.photoURL!;
      }
    } catch (exc) {
      log('Failed to load user profile data: $exc');
    }

    if (user == null) {
      return Container();
    }
    final header = UserAccountsDrawerHeader(
      // <-- SEE HERE

      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      accountName: Text(
        name, //user.displayName!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        email,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      currentAccountPicture: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(photoUrl),
        backgroundColor: Colors.transparent,
      ),
    );
    final widgets = <Widget>[];
    widgets.add(header);

    for (final item in _menus()) {
      widgets.add(ListTile(
        leading: item.icon,
        title: Text(item.title),
        onTap: () {
          Navigator.pop(context); // Close drawer first
          context.go(item.route);
        },
      ));
    }

    // Theme mode toggle
    final themeMode = ref.watch(themeModeProvider);
    widgets
      ..add(const Divider())
      ..add(ListTile(
        leading: Icon(
          themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.brightness_auto,
        ),
        title: const Text('Tema'),
        subtitle: Text(
          themeMode == ThemeMode.dark
              ? 'Escuro'
              : themeMode == ThemeMode.light
                  ? 'Claro'
                  : 'Sistema',
        ),
        onTap: () {
          final next = switch (themeMode) {
            ThemeMode.system => ThemeMode.light,
            ThemeMode.light => ThemeMode.dark,
            ThemeMode.dark => ThemeMode.system,
          };
          ref.read(themeModeProvider.notifier).setThemeMode(next);
        },
      ))
      ..add(ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sair'),
          onTap: () {
            FirebaseUIAuth.signOut(context: context);
          }));

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF218838)),
            accountName: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(photoUrl),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Biometric lock toggle
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Bloqueio biométrico'),
            subtitle: Text(
              biometricLockEnabled ? 'Ativado' : 'Desativado',
            ),
            value: biometricLockEnabled,
            onChanged: (value) {
              ref
                  .read(biometricEnabledProvider.notifier)
                  .setEnabled(enabled: value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              FirebaseUIAuth.signOut(context: context);
            },
          ),
        ],
      ),
    );
  }
}
