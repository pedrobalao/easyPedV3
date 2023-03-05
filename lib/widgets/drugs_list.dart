import 'package:flutter/material.dart';
import '../models/drug.dart';

class DrugsList extends StatelessWidget {
  DrugsList({Key? key, required this.drugSubCategory, required this.drugs})
      : super(key: key);

  final DrugSubCategory drugSubCategory;
  final List<Drug> drugs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
                title: Text(drugs[index].name ?? "",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  var id = drugs[index].id;
                  Navigator.pushNamed(context, "/drugs/$id");
                }));
      },
      itemCount: drugs.length,
    );
  }
}


// Create a corresponding State class.
// This class holds data related to the form.

