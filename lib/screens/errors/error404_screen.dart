import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                'assets/images/e404.png',
                fit: BoxFit.none,
              ),
              TextButton(
                onPressed: () {
                  context.go('/');
                },
                child: Text(
                  'Voltar ao início'.toUpperCase(),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          )),
    );
  }
}
