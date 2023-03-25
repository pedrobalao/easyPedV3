import 'package:easypedv3/widgets/congresses_slide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../auth_gate.dart';
import '../services/auth_service.dart';
import '../services/drugs_service.dart';
import '../widgets/connection_error.dart';
import '../widgets/loading.dart';
import '../widgets/menu.dart';
import '../widgets/news_slide.dart';
import 'drugs/drugs_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<Map<String, dynamic>> fetchData() async {
    var req = <Future>[];

    Map<String, dynamic> result = <String, dynamic>{};

    req.add(_drugService
        .fetchNews(await _authenticationService.getUserToken())
        .then((value) => result['news'] = value));

    req.add(_drugService
        .fetchCongresses(await _authenticationService.getUserToken())
        .then((value) => result['congresses'] = value));

    await Future.wait(req);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasError) {
            return ConnectionError();
          } else if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(title: const Text("easyPed"), actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: DrugSearchDelegate(),
                        );
                      })
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
                    const Gap(5),
                    CongressesSlide(congresses: snapshot.data!['congresses']),
                    const Gap(10),
                    ListTile(
                      tileColor: const Color(0xFF28a745),
                      title: Text("Novidades",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.headline4),
                    ),
                    const Gap(5),
                    NewsSlide(news: snapshot.data!['news']),
                    const Gap(10),
                  ]),
                ));
          } else {
            return const ScreenLoading(title: "easyPed");
          }
        });
  }
}
