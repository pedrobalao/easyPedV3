import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../screens/drugs/drug_screen.dart';
import '../services/drugs_service.dart';
import 'loading.dart';

class DrugsList extends StatelessWidget {
  DrugsList({Key? key, required this.drugSubCategory}) : super(key: key);

  final DrugSubCategory drugSubCategory;
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<Drug>> fetchDrugs() async {
    var ret = await _drugService.fetchDrugsBySubCategory(
        drugSubCategory.categoryId!,
        drugSubCategory.id!,
        await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Drug>>(
      future: fetchDrugs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(snapshot.data![index].name ?? "",
                    style: Theme.of(context).textTheme.headline3),
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

