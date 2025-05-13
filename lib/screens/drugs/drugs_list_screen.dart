import 'package:flutter/material.dart';
import '../../models/drug.dart';
import '../../services/auth_service.dart';
import '../../services/drugs_service.dart';
import '../../widgets/base_page_layout.dart';
import '../../widgets/connection_error.dart';
import '../../widgets/drugs_list.dart';
import '../../widgets/loading.dart';

class DrugsListScreen extends StatelessWidget {
  DrugsListScreen({Key? key, required this.drugSubCategory}) : super(key: key);

  final DrugSubCategory drugSubCategory;
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<Drug>> fetchDrugs() async {
    var ret = await _drugService.fetchDrugsBySubCategory(
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
                    title: Text(drugSubCategory.description ?? "")),
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
