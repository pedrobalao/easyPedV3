import 'package:easypedv3/models/medical_calculation.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../screens/medical_calculations/medical_calculation_screen.dart';
import '../services/drugs_service.dart';
import 'loading.dart';

class MedicalCalculationsList extends StatelessWidget {
  MedicalCalculationsList({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<MedicalCalculation>> fetchList() async {
    var ret = await _drugService
        .fetchMedicalCalculations(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MedicalCalculation>>(
      future: fetchList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].description ?? "",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MedicalCalculationScreen(
                              medicalCalculation: snapshot.data![index])));
                },
              );
            },
            itemCount: snapshot.data!.length,
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
