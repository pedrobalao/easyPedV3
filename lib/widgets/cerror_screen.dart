import 'package:flutter/foundation.dart'
    show FlutterErrorDetails, kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'loading.dart';

class CErrorScreen extends StatelessWidget {
  const CErrorScreen({super.key, required this.details});

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    // final InternetConnectionChecker customInstance =
    //     InternetConnectionChecker.createInstance(
    //   checkTimeout: const Duration(seconds: 1),
    //   checkInterval: const Duration(seconds: 1),
    // );

    Future<bool> checkConnectivity() async {
      if (kIsWeb) {
        return true;
      }
      return await (InternetConnectionChecker.createInstance().hasConnection);
    }

    // return Column(children: [
    //   Image.asset(
    //     "assets/images/generic_error.png",
    //     fit: BoxFit.cover,
    //   ),
    //   const Text(
    //       "Ups...Algo não correu bem! Os nossos melhores engenheiros já estão a analisar."),
    //   kDebugMode ? Text(details.exceptionAsString()) : Container()
    // ]);

    return FutureBuilder<bool>(
        future: checkConnectivity(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return Column(children: [
                Image.asset(
                  "assets/images/generic_error.png",
                  fit: BoxFit.cover,
                ),
                const Text(
                    "Ups...Algo não correu bem! Os nossos melhores engenheiros já estão a analisar."),
                kDebugMode ? Text(details.exceptionAsString()) : Container()
              ]);
            } else {
              return Column(children: [
                Image.asset(
                  "assets/images/connection.png",
                  fit: BoxFit.cover,
                ),
                const Text(
                    "Ups...Parece que está sem ligação à internet. Verifique a sua ligação por favor e volte a tentar."),
                kDebugMode ? Text(details.exceptionAsString()) : Container()
              ]);
            }
          } else {
            return const Loading();
          }
        });

    // return Column(
    //   children: [
    //     Image.asset(
    //       "assets/images/error_pic.png",
    //       fit: BoxFit.cover,
    //     ),
    //     const Text("Ups...Algo não correu bem!"),
    //     kDebugMode ? Text(details.exceptionAsString()) : Container()
    //   ],
    // );
  }
}
