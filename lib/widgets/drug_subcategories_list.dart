import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/screens/drugs/drugs_list_screen.dart';
import 'package:flutter/material.dart';

class DrugsSubCategoriesList extends StatelessWidget {
  const DrugsSubCategoriesList({required this.subCategories, super.key});

  final List<DrugSubCategory> subCategories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(subCategories[index].description ?? '',
              style: Theme.of(context).textTheme.displaySmall),
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

