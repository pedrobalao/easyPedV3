import 'package:easypedv3/services/auth_service.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../models/drug.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/connection_error.dart';
import '../../widgets/drug_categories_list.dart';
import '../../widgets/drugs_favourites_list.dart';
import 'drug_screen.dart';

class DrugsScreen extends StatefulWidget {
  const DrugsScreen({Key? key}) : super(key: key);

  @override
  _DrugsScreenState createState() => _DrugsScreenState();
}

class _DrugsScreenState extends State<DrugsScreen> {
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<Map<String, dynamic>> fetchData() async {
    var req = <Future>[];

    Map<String, dynamic> result = <String, dynamic>{};

    req.add(_drugService
        .fetchFavourites(await _authenticationService.getUserToken())
        .then((value) => result['favourites'] = value));

    req.add(_drugService
        .fetchCategories(await _authenticationService.getUserToken())
        .then((value) => result['categories'] = value));

    await Future.wait(req);

    return result;
  }

  Widget appBarTitle = const Text("Medicamentos");
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ConnectionError();
          } else if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: appBarTitle,
                  actions: <Widget>[
                    IconButton(
                        icon: actionIcon,
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: DrugSearchDelegate(),
                          );
                        })
                  ]),
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    ListTile(
                      tileColor: const Color(0xFF28a745),
                      title: Text("Os teus favoritos",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.headline4),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: DrugsFavouritesList(
                            drugs: snapshot.data!['favourites'])),
                    ListTile(
                      tileColor: const Color(0xFF28a745),
                      title: Text("Explora",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.headline4),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(children: [
                          DrugsCategoriesList(
                              categories: snapshot.data!['categories']),
                        ]))
                  ])),
              //const Gap(10)
            );
          } else {
            return const ScreenLoading(title: "Medicamentos");
          }
        });
  }
}

class DrugSearchDelegate extends SearchDelegate<Drug> {
  final DrugService _drugService = DrugService();
  final AuthenticationService _authService = AuthenticationService();
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Drug(id: -1, name: ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Drug>>(
      future: _search(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].name ?? "",
                    style: Theme.of(context).textTheme.headline3),
                subtitle: Text(
                    snapshot.data![index].subcategoryDescription ?? "",
                    style: Theme.of(context).textTheme.bodyText2),
                onTap: () {
                  //close(context, snapshot.data![index]);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DrugScreen(id: snapshot.data![index].id!)));
                },
              );
            },
            itemCount: snapshot.data!.length,
          );
        } else {
          return const Loading();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Future<List<Drug>> _search() async {
    List<Drug> result =
        await _drugService.searchDrug(query, await _authService.getUserToken());
    return result;
  }
}
