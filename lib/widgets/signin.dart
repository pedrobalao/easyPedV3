import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthStateListener<OAuthController>(
        listener: (oldState, state, controller) {
          if (state is SignedIn) {
            FirebaseAnalytics.instance.logLogin();
            Navigator.of(context).pushReplacementNamed('/');
          }
        },
        child: Column(children: [
          OAuthProviderButton(
            provider: GoogleProvider(
                clientId:
                    "330541011565-p4clgm77d42sbqjrkojro5495pp9kdr4.apps.googleusercontent.com"),
          ),
          const Gap(10),
          OAuthProviderButton(provider: AppleProvider())
        ]));
  }
}
