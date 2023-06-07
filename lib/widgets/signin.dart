import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    String googleClientId =
        "330541011565-p4clgm77d42sbqjrkojro5495pp9kdr4.apps.googleusercontent.com";

    if (Platform.isAndroid) {
      googleClientId =
          "330541011565-uppv3adt8s17h7u3ulj8lv96673j61n2.apps.googleusercontent.com";
      // const String envR = String.fromEnvironment("ENV_R", defaultValue: 'DEV');
      // if (envR == "PROD") {
      //   googleClientId =
      //       "330541011565-o3mqr2n2idgic7t6adb0itlr6grkquup.apps.googleusercontent.com";
      //   //"330541011565-0ekek1brvq39m6c34i8en2tl2jtqj99a.apps.googleusercontent.com";
      // } else {
      //   googleClientId =
      //       "330541011565-qjbf5p75929qd4rtik4sdrs2f8cbm9gm.apps.googleusercontent.com";
      // }
    }

    return AuthStateListener<OAuthController>(
        listener: (oldState, state, controller) {
          if (state is SignedIn) {
            FirebaseAnalytics.instance.logLogin();
            Navigator.of(context).pushReplacementNamed('/');
          } else if (state is AuthFailed) {
            _showMyDialog(context,
                "googleClientId: $googleClientId - ${state.exception}");
          }
        },
        child: Column(children: [
          const Gap(10),
          OAuthProviderButton(
            provider: GoogleProvider(clientId: googleClientId),
            action: AuthAction.signIn,
          ),
          TextButton(
              onPressed: () async {
                await signInWithGoogle();
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 12.0),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ))),
          const Gap(10),
          Platform.isIOS
              ? OAuthProviderButton(provider: AppleProvider())
              : Container()
        ]));
  }
}
