import 'package:flutter/material.dart';

import '../../models/disease.dart';
import '../../services/auth_service.dart';
import '../../services/drugs_service.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/connection_error.dart';
import '../../widgets/loading.dart';

class DiseasesListScreen extends StatefulWidget {
  const DiseasesListScreen({Key? key}) : super(key: key);

  @override
  _DiseasesListScreenState createState() => _DiseasesListScreenState();
}

class _DiseasesListScreenState extends State<DiseasesListScreen> {
  Widget appBarTitle = const Text("Doenças");
  Icon actionIcon = const Icon(Icons.search);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<Disease>> fetchDiseases() async {
    var ret = await _drugService
        .fetchDiseases(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Disease>>(
      future: fetchDiseases(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ConnectionError();
        }
        if (snapshot.connectionState == ConnectionState.done) {
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
                            delegate: DiseasesSearchDelegate(),
                          );
                        })
                  ]),
              body: BasePageLayout(children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(2.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                      title: Text(snapshot.data![index].description ?? "",
                          style: Theme.of(context).textTheme.headline3),
                      onTap: () {
                        var id = snapshot.data![index].id;
                        Navigator.pushNamed(context, "/diseases/$id");
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             DiseaseScreen(disease: snapshot.data![index])));
                      },
                    ));
                  },
                  itemCount: snapshot.data!.length,
                )
              ]));
        } else {
          return const ScreenLoading(
            title: "Doenças",
          );
        }
      },
    );
  }
}

class DiseasesSearchDelegate extends SearchDelegate<Disease> {
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
        close(context, Disease(id: -1, description: ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Disease>>(
      future: _search(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].description ?? "",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  var id = snapshot.data![index].id;
                  Navigator.pushNamed(context, "/diseases/$id");
                  //close(context, snapshot.data![index]);
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

  Future<List<Disease>> _search() async {
    List<Disease> result = await _drugService.searchDiseases(
        query, await _authService.getUserToken());
    return result;
  }
}
