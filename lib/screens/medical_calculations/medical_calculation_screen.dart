import 'package:easypedv3/models/medical_calculation.dart';
import 'package:flutter/material.dart';

import '../../services/drugs_service.dart';
import '../../models/disease.dart';
import '../../services/auth_service.dart';
import '../../widgets/loading.dart';
import '../../widgets/title_value.dart';

class MedicalCalculationScreen extends StatefulWidget {
  const MedicalCalculationScreen({Key? key, required this.medicalCalculation})
      : super(key: key);

  final MedicalCalculation medicalCalculation;
  @override
  _MedicalCalculationScreenState createState() =>
      _MedicalCalculationScreenState();
}

class _MedicalCalculationScreenState extends State<MedicalCalculationScreen> {
  Icon actionIcon = const Icon(Icons.favorite);
  @override
  Widget build(BuildContext context) {
    return MedicalCalculationWidget(
      medicalCalculation: widget.medicalCalculation,
    );
  }
}

class MedicalCalculationWidget extends StatelessWidget {
  MedicalCalculationWidget({Key? key, required this.medicalCalculation})
      : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authService = AuthenticationService();
  final MedicalCalculation medicalCalculation;

  Future<MedicalCalculation> fetchItem() async =>
      _drugService.fetchMedicalCalculation(
          medicalCalculation.id ?? 0, await _authService.getUserToken());

  @override
  Widget build(context) {
    return FutureBuilder<MedicalCalculation>(
        future: fetchItem(),
        builder: (context, AsyncSnapshot<MedicalCalculation> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(snapshot.data?.description ?? "")),
                body: SingleChildScrollView(
                    padding: const EdgeInsets.all(5.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleValue(
                            title: "Cálculo",
                            value: snapshot.data?.description ?? ""),
                        TitleValue(
                            title: "Observações",
                            value:
                                snapshot.data?.observation ?? "Sem informação"),
                      ],
                    )));
          } else {
            return const Loading();
          }
        });
  }
}
