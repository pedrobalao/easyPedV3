import 'package:easypedv3/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                  clientId:
                      "330541011565-p4clgm77d42sbqjrkojro5495pp9kdr4.apps.googleusercontent.com")
            ],
          );
        }
        // Render your application if authenticated
        return const HomeScreen();
      },
    );
  }
}
