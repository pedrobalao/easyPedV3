import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../services/drugs_service.dart';
import '../../models/disease.dart';
import '../../services/auth_service.dart';
import '../../widgets/connection_error.dart';
import '../../widgets/loading.dart';
import '../../widgets/title_value.dart';

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({Key? key, required this.diseaseId}) : super(key: key);

  final int diseaseId;
  @override
  _DiseaseScreenState createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  Icon actionIcon = const Icon(Icons.favorite);
  @override
  Widget build(BuildContext context) {
    return DiseaseWidget(
      diseaseId: widget.diseaseId,
    );
  }
}

class DiseaseWidget extends StatelessWidget {
  DiseaseWidget({Key? key, required this.diseaseId}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authService = AuthenticationService();
  final int diseaseId;

  Future<Disease> fetchDisease(id) async =>
      _drugService.fetchDisease(id, await _authService.getUserToken());

  @override
  Widget build(context) {
    return FutureBuilder<Disease>(
        future: fetchDisease(diseaseId),
        builder: (context, AsyncSnapshot<Disease> snapshot) {
          if (snapshot.hasError) {
            return ConnectionError();
          } else if (snapshot.hasData) {
            FirebaseAnalytics.instance.logViewItem(items: [
              AnalyticsEventItem(
                  itemCategory: "disease",
                  itemId: snapshot.data?.id.toString(),
                  itemName: snapshot.data?.description)
            ]);
            return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(snapshot.data?.description ?? "")),
                body: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleValue(
                        title: "Doença",
                        value: snapshot.data?.description ?? ""),
                    TitleValue(
                        title: "Autor",
                        value: snapshot.data?.author ?? "Sem informação"),
                    TitleValue(
                        title: "Indicação",
                        value: snapshot.data?.indication ?? "Sem informação"),
                    treatmentWidget(context, snapshot.data),
                    TitleValue(
                        title: "Follow-up",
                        value: snapshot.data?.followup ?? "Sem informação"),
                    TitleValue(
                        title: "Bibliografia",
                        value: snapshot.data?.bibliography ?? "Sem informação"),
                  ],
                )));
          } else {
            return const ScreenLoading();
          }
        });
  }

  Widget treatmentWidget(context, Disease? disease) {
    List<Widget> ret = [];

    if (disease != null &&
        disease.treatment != null &&
        disease.treatment!.conditions!.isNotEmpty) {
      for (var condition in disease.treatment!.conditions!) {
        ret.add(conditionWidget(context, condition));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleValue(title: "Tratamento"),
      (disease?.generalMeasures != null
          ? SubTitleValue(
              title: "Medidas Gerais",
              value: disease?.generalMeasures ?? "Sem informação")
          : Container()),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: ret),
    ]);
  }

  Widget conditionWidget(context, Conditions? condition) {
    if (condition != null) {
      List<Widget> wgs = [];

      wgs.add(ListTile(
        tileColor: const Color(0xFF28a745),
        title: Text(condition.condition ?? "",
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.headline4),
      ));
      if (condition.firstline != null) {
        wgs.add(
            SubTitleValue(title: "1ª Linha", value: condition.firstline ?? ""));
      }
      if (condition.secondline != null) {
        wgs.add(SubTitleValue(
            title: "2ª Linha", value: condition.secondline ?? ""));
      }
      if (condition.thirdline != null) {
        wgs.add(
            SubTitleValue(title: "3ª Linha", value: condition.thirdline ?? ""));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: wgs,
      );
    }
    return Container();
  }
}
