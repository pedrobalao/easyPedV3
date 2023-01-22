import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../screens/drugs/drug_screen.dart';
import '../services/drugs_service.dart';
import 'loading.dart';

class DrugsFavouritesList extends StatelessWidget {
  DrugsFavouritesList({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<Drug>> fetchFavourites() async {
    var ret = await _drugService
        .fetchFavourites(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Drug>>(
      future: fetchFavourites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(child:ListTile(
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
              ));
            },
            itemCount: snapshot.data!.length,
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

