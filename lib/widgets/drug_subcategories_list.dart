import 'package:easypedv3/screens/drugs/drugs_list_screen.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../services/drugs_service.dart';
import 'loading.dart';

class DrugsSubCategoriesList extends StatelessWidget {
  DrugsSubCategoriesList({Key? key, required this.drugCategory})
      : super(key: key);

  final DrugCategory drugCategory;
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<DrugSubCategory>> fetchSubCategories() async {
    var ret = await _drugService.fetchSubCategories(
        drugCategory.id!, await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DrugSubCategory>>(
      future: fetchSubCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(snapshot.data![index].description ?? "",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  //close(context, snapshot.data![index]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrugsListScreen(
                                drugSubCategory: snapshot.data![index],
                              )));
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

