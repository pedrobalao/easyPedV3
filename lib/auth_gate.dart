import 'package:easypedv3/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'screens/auth/signin_screen.dart';
import 'widgets/signin.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const EPSignScreen();
          // return SignInScreen(
          //   showAuthActionSwitch: false,
          //   headerBuilder: (context, constraints, _) {
          //     return Padding(
          //         padding: const EdgeInsets.all(20),
          //         child: Center(
          //             child: Column(children: const [
          //           Text('easyPed',
          //               style: TextStyle(
          //                   color: Color(0xFF2963C8),
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 40)),
          //           Text('#makinghealthcareeasier',
          //               style: TextStyle(
          //                   color: Color(0xFF2963C8),
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 10))
          //         ])));
          //   },
          //   footerBuilder: (context, action) {
          //     return const Text(
          //       'Made with ❤️ in Porto',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(color: Colors.grey),
          //     );
          //   },
          // );
        }
        // Render your application if authenticated
        return const HomeScreen();
      },
    );
  }
}

/*

{
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            action == AuthAction.signIn
                                ? 'A informação presente no easyPed pode conter erros. Não nos responsabilizamos por qualquer consequência do uso da mesma. Toda a informação deve ser validada pelo médico. Ao avançar concorda.'
                                : 'A informação presente no easyPed pode conter erros. Não nos responsabilizamos por qualquer consequência do uso da mesma. Toda a informação deve ser validada pelo médico. Ao avançar concorda.',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }*/
