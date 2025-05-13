import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  _showMyDialog(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro de Autenticação'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String googleClientId =
        "330541011565-p4clgm77d42sbqjrkojro5495pp9kdr4.apps.googleusercontent.com";

    if (Platform.isAndroid) {
      googleClientId = dotenv.env['GOOGLE_CLIENT_ID']!;
    }

    return AuthStateListener<OAuthController>(
        listener: (oldState, state, controller) {
          if (state is SignedIn) {
            FirebaseAnalytics.instance.logLogin();
            Navigator.of(context).pushReplacementNamed('/');
          } else if (state is AuthFailed) {
            _showMyDialog(context, "Falhou a autenticação");
          }
          return null;
        },
        child: Column(children: [
          const Gap(10),
          OAuthProviderButton(
            provider: GoogleProvider(clientId: googleClientId),
          ),
          const Gap(10),
          Platform.isIOS
              ? OAuthProviderButton(provider: AppleProvider())
              : Container()
        ]));
  }
}
