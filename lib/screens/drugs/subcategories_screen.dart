import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/drug_subcategories_list.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';

class DrugsSubCategoriesScreen extends StatelessWidget {
  DrugsSubCategoriesScreen({required this.drugCategory, super.key});

  final DrugCategory drugCategory;
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<DrugSubCategory>> fetchSubCategories() async {
    final ret = await _drugService.fetchSubCategories(
        drugCategory.id!, await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DrugSubCategory>>(
        future: fetchSubCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ConnectionError();
          } else if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(drugCategory.description ?? '')),
                body: BasePageLayout(children: [
                  DrugsSubCategoriesList(subCategories: snapshot.data!)
                ]));
          } else {
            return ScreenLoading(title: drugCategory.description);
          }
        });
  }
}
