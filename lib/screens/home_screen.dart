import 'package:easypedv3/widgets/congresses_slide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../auth_gate.dart';
import '../widgets/menu.dart';
import '../widgets/news_slide.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
        appBar: AppBar(title: const Text("easyPed"), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              FirebaseUIAuth.signOut(context: context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AuthGate()));
            },
          ),
        ]),
        drawer: const Menu(),
        body: SingleChildScrollView(
          child: Column(children: [
            ListTile(
              tileColor: const Color(0xFF28a745),
              title: Text("Congressos",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline4),
            ),
            CongressesSlide(),
            Gap(10),
            ListTile(
              tileColor: const Color(0xFF28a745),
              title: Text("Novidades",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline4),
            ),
            NewsSlide(),
            Gap(10),
          ]),
        ));
  }
}
