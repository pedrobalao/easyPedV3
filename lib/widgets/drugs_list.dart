import 'package:easypedv3/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrugsList extends StatelessWidget {
  const DrugsList(
      {required this.drugSubCategory, required this.drugs, super.key});

  final DrugSubCategory drugSubCategory;
  final List<Drug> drugs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
                title: Text(drugs[index].name ?? '',
                    style: Theme.of(context).textTheme.displaySmall),
                onTap: () {
                  final id = drugs[index].id;
                  context.push('/drugs/$id');
                }));
      },
      itemCount: drugs.length,
    );
  }
}
