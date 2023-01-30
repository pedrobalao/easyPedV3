import 'package:flutter/material.dart';

class Error404Screen extends StatelessWidget {
  const Error404Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(
            //fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/e404.png",
                fit: BoxFit.none,
                alignment: Alignment.center,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text(
                  "Voltar ao início".toUpperCase(),
                  style: const TextStyle(color: Color(0xFF2963C8)),
                ),
              ),
            ],
          )),
    );
  }
}
