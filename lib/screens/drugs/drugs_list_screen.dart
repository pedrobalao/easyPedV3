import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/drugs_list.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';

class DrugsListScreen extends StatelessWidget {
  DrugsListScreen({required this.drugSubCategory, super.key});

  final DrugSubCategory drugSubCategory;
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<Drug>> fetchDrugs() async {
    final ret = await _drugService.fetchDrugsBySubCategory(
        drugSubCategory.categoryId!,
        drugSubCategory.id!,
        await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Drug>>(
        future: fetchDrugs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ConnectionError();
          } else if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(drugSubCategory.description ?? '')),
                body: BasePageLayout(children: [
                  DrugsList(
                      drugSubCategory: drugSubCategory, drugs: snapshot.data!)
                ]));
          } else {
            return ScreenLoading(title: drugSubCategory.description);
          }
        });
  }
}
