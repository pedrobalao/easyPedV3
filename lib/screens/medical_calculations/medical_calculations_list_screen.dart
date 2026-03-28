import 'package:easypedv3/models/medical_calculation.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';

// class MedicalCalculationsListScreen extends StatefulWidget {
//   const MedicalCalculationsListScreen({Key? key}) : super(key: key);

//   @override
//   _MedicalCalculationsListScreenState createState() =>
//       _MedicalCalculationsListScreenState();
// }

// class _MedicalCalculationsListScreenState
//     extends State<MedicalCalculationsListScreen> {
//   Widget appBarTitle = const Text("Cálculos Médicos");
//   //Icon actionIcon = const Icon(Icons.search);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true, title: appBarTitle),
//       body: BasePageLayout(children: [MedicalCalculationsList()]),
//     );
//   }
// }

class MedicalCalculationsListScreen extends StatelessWidget {
  MedicalCalculationsListScreen({super.key});

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<MedicalCalculation>> fetchList() async {
    final ret = await _drugService
        .fetchMedicalCalculations(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MedicalCalculation>>(
      future: fetchList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ConnectionError();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                  centerTitle: true, title: const Text('Cálculos Médicos')),
              body: BasePageLayout(children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                      title: Text(snapshot.data![index].description ?? '',
                          style: Theme.of(context).textTheme.displaySmall),
                      onTap: () {
                        final id = snapshot.data![index].id;
                        Navigator.pushNamed(
                            context, '/medical-calculations/$id');
                      },
                    ));
                  },
                  itemCount: snapshot.data!.length,
                )
              ]));
        } else {
          return const ScreenLoading(title: 'Cálculos Médicos');
        }
      },
    );
  }
}
