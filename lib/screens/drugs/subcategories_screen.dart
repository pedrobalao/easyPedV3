import 'package:flutter/material.dart';

import '../../models/drug.dart';
import '../../services/auth_service.dart';
import '../../services/drugs_service.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/connection_error.dart';
import '../../widgets/drug_subcategories_list.dart';
import '../../widgets/loading.dart';

class DrugsSubCategoriesScreen extends StatelessWidget {
  DrugsSubCategoriesScreen({Key? key, required this.drugCategory})
      : super(key: key);

  final DrugCategory drugCategory;
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<DrugSubCategory>> fetchSubCategories() async {
    var ret = await _drugService.fetchSubCategories(
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
                    title: Text(drugCategory.description ?? "")),
                body: BasePageLayout(children: [
                  DrugsSubCategoriesList(subCategories: snapshot.data!)
                ]));
          } else {
            return ScreenLoading(title: drugCategory.description);
          }
        });
  }
}
