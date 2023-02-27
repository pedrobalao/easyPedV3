import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_styles.dart';

class ConnectionError extends StatelessWidget {
  ConnectionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Erro"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
                child: Center(
                    child: Column(children: [
              Lottie.asset('assets/lotties/error.json'),
              Text(
                "Ups...algo correu mal. Verifique que tem internet e volte a tentar mais tarde. Obrigado.",
                style: Styles.headLineStyle1.copyWith(color: Styles.errorColor),
              ),
              Gap(20),
              GestureDetector(
                child: Text(
                  "Voltar ao início",
                  style: Styles.noteStyle,
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/");
                },
              ),
            ])))));
  }
}
