import 'package:easypedv3/services/auth_service.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';

import '../../models/drug.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/drug_categories_list.dart';
import '../../widgets/drugs_favourites_list.dart';
import 'drug_screen.dart';

class DrugsScreen extends StatefulWidget {
  const DrugsScreen({Key? key}) : super(key: key);

  @override
  _DrugsScreenState createState() => _DrugsScreenState();
}

class _DrugsScreenState extends State<DrugsScreen> {
  Widget appBarTitle = const Text("Medicamentos");
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        IconButton(
            icon: actionIcon,
            onPressed: () {
              showSearch(
                context: context,
                delegate: DrugSearchDelegate(),
              );
            })
      ]),
      body: BasePageLayout(children: [
        Text("Os teus favoritos",
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.headline6),
        DrugsFavouritesList(),
        Text("Explora",
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.headline6),
        DrugsCategoriesList()
      ]),
    );
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
                              DrugScreen(drug: snapshot.data![index])));
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
