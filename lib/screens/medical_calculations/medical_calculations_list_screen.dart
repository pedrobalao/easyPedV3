import 'package:flutter/material.dart';

import '../../widgets/base_page_layout.dart';
import '../../widgets/medical_calculations_list.dart';

class MedicalCalculationsListScreen extends StatefulWidget {
  const MedicalCalculationsListScreen({Key? key}) : super(key: key);

  @override
  _MedicalCalculationsListScreenState createState() =>
      _MedicalCalculationsListScreenState();
}

class _MedicalCalculationsListScreenState
    extends State<MedicalCalculationsListScreen> {
  Widget appBarTitle = const Text("Cálculos Médicos");
  //Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: appBarTitle),
      body: BasePageLayout(children: [MedicalCalculationsList()]),
    );
  }
}
