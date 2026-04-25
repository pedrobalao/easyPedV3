import 'package:easypedv3/screens/auth/signin_screen.dart';
import 'package:easypedv3/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const EPSignScreen();
        }
        // Render your application if authenticated
        return const HomeScreen();
      },
    );
  }
}
