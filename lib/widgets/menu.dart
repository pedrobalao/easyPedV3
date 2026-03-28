import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

/// Simplified menu widget — the drawer is no longer the primary navigation.
/// Primary navigation is handled by the bottom [NavigationBar].
/// This widget provides user-profile display and sign-out functionality.
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
