import 'package:flutter/material.dart';

import '../../models/drug.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/drug_subcategories_list.dart';

class DrugsSubCategoriesScreen extends StatefulWidget {
  const DrugsSubCategoriesScreen({Key? key, required this.drugCategory})
      : super(key: key);

  final DrugCategory drugCategory;
  @override
  _DrugsSubCategoriesScreenState createState() =>
      _DrugsSubCategoriesScreenState();
}

class _DrugsSubCategoriesScreenState extends State<DrugsSubCategoriesScreen> {
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.drugCategory.description ?? "")),
      body: BasePageLayout(children: [
        DrugsSubCategoriesList(drugCategory: widget.drugCategory)
      ]),
    );
  }
}
