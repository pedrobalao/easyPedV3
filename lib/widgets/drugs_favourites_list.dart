import 'package:flutter/material.dart';
import '../models/drug.dart';

class DrugsFavouritesList extends StatelessWidget {
  DrugsFavouritesList({Key? key, required this.drugs}) : super(key: key);

  final List<Drug> drugs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2.0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(drugs[index].name ?? "",
              style: Theme.of(context).textTheme.headline3),
          subtitle: Text(drugs[index].subcategoryDescription ?? "",
              style: Theme.of(context).textTheme.bodyText2),
          onTap: () {
            var id = drugs[index].id;
            Navigator.pushNamed(context, "/drugs/$id");
          },
        ));
      },
      itemCount: drugs.length,
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

