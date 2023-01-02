import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../screens/drugs/subcategories_screen.dart';
import '../services/drugs_service.dart';
import 'loading.dart';

class DrugsCategoriesList extends StatelessWidget {
  DrugsCategoriesList({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<DrugCategory>> fetchCategories() async {
    var ret = await _drugService
        .fetchCategories(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DrugCategory>>(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].description ?? "",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrugsSubCategoriesScreen(
                              drugCategory: snapshot.data![index])));
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
}

// Create a corresponding State class.
// This class holds data related to the form.

