import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../screens/drugs/subcategories_screen.dart';
import '../services/drugs_service.dart';

class DrugsCategoriesList extends StatelessWidget {
  DrugsCategoriesList({Key? key, required this.categories}) : super(key: key);

  final List<DrugCategory> categories;
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<DrugCategory>> fetchCategories() async {
    var ret = await _drugService
        .fetchCategories(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(categories[index].description ?? "",
              style: Theme.of(context).textTheme.headline3),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DrugsSubCategoriesScreen(
                        drugCategory: categories[index])));
          },
        ));
      },
      itemCount: categories.length,
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

