import 'package:easypedv3/screens/drugs/drugs_list_screen.dart';
import 'package:flutter/material.dart';

import '../models/drug.dart';

class DrugsSubCategoriesList extends StatelessWidget {
  DrugsSubCategoriesList({Key? key, required this.subCategories})
      : super(key: key);

  final List<DrugSubCategory> subCategories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(subCategories[index].description ?? "",
              style: Theme.of(context).textTheme.headline3),
          onTap: () {
            //close(context, subCategories[index]);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DrugsListScreen(
                          drugSubCategory: subCategories[index],
                        )));
          },
        ));
      },
      itemCount: subCategories.length,
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

