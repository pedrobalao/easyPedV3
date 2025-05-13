import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../screens/drugs/subcategories_screen.dart';

class DrugsCategoriesList extends StatelessWidget {
  const DrugsCategoriesList({Key? key, required this.categories})
      : super(key: key);

  final List<DrugCategory> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2.0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(categories[index].description ?? "",
              style: Theme.of(context).textTheme.displaySmall),
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

