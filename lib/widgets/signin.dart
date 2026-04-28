import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  Future<void> _showMyDialog(BuildContext context, String message) {
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
    var googleClientId =
        '330541011565-p4clgm77d42sbqjrkojro5495pp9kdr4.apps.googleusercontent.com';

    // On Android and on the web the Firebase UI Google provider needs the
    // OAuth web client ID supplied via `.env` (`GOOGLE_CLIENT_ID`). On iOS
    // the bundled `GoogleService-Info.plist` client ID is used instead.
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      googleClientId = dotenv.env['GOOGLE_CLIENT_ID']!;
    }

    // Apple sign-in is available on iOS natively and on the web via the
    // Apple JS SDK (loaded in `web/index.html`).
    final showAppleButton =
        defaultTargetPlatform == TargetPlatform.iOS || kIsWeb;

    return AuthStateListener<OAuthController>(
        listener: (oldState, state, controller) {
          if (state is SignedIn) {
            FirebaseAnalytics.instance.logLogin();
            Navigator.of(context).pushReplacementNamed('/');
          } else if (state is AuthFailed) {
            _showMyDialog(context, 'Falhou a autenticação');
          }
          return null;
        },
        child: Column(children: [
          const Gap(10),
          OAuthProviderButton(
            provider: GoogleProvider(clientId: googleClientId),
          ),
          const Gap(10),
          if (showAppleButton)
            OAuthProviderButton(provider: AppleProvider())
          else
            Container()
        ]));
  }
}
