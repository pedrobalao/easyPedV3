import 'package:flutter/material.dart';

import '../../models/drug.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/drug_subcategories_list.dart';
import '../../widgets/drugs_list.dart';

class DrugsListScreen extends StatefulWidget {
  const DrugsListScreen({Key? key, required this.drugSubCategory})
      : super(key: key);

  final DrugSubCategory drugSubCategory;
  @override
  _DrugsListScreenState createState() => _DrugsListScreenState();
}

class _DrugsListScreenState extends State<DrugsListScreen> {
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.drugSubCategory.description ?? "")),
      body: BasePageLayout(
          children: [DrugsList(drugSubCategory: widget.drugSubCategory)]),
    );
  }
}
