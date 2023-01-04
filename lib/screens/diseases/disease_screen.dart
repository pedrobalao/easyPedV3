import 'package:flutter/material.dart';

import '../../services/drugs_service.dart';
import '../../models/disease.dart';
import '../../services/auth_service.dart';
import '../../widgets/loading.dart';
import '../../widgets/title_value.dart';

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({Key? key, required this.disease}) : super(key: key);

  final Disease disease;
  @override
  _DiseaseScreenState createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  Icon actionIcon = const Icon(Icons.favorite);
  @override
  Widget build(BuildContext context) {
    return DiseaseWidget(
      disease: widget.disease,
    );
  }
}

class DiseaseWidget extends StatelessWidget {
  DiseaseWidget({Key? key, required this.disease}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authService = AuthenticationService();
  final Disease disease;

  Future<Disease> fetchDisease() async => _drugService.fetchDisease(
      disease.id ?? 0, await _authService.getUserToken());

  @override
  Widget build(context) {
    return FutureBuilder<Disease>(
        future: fetchDisease(),
        builder: (context, AsyncSnapshot<Disease> snapshot) {
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
                            title: "Doença",
                            value: snapshot.data?.description ?? ""),
                        TitleValue(
                            title: "Autor",
                            value: snapshot.data?.author ?? "Sem informação"),
                        TitleValue(
                            title: "Indicação",
                            value:
                                snapshot.data?.indication ?? "Sem informação"),
                        treatmentWidget(context, snapshot.data),
                        TitleValue(
                            title: "Follow-up",
                            value: snapshot.data?.followup ?? "Sem informação"),
                        TitleValue(
                            title: "Bibliografia",
                            value: snapshot.data?.bibliography ??
                                "Sem informação"),
                      ],
                    )));
          } else {
            return const Loading();
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

    return Container(
        padding: const EdgeInsets.all(5.5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tratamento",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline6),
              (disease?.generalMeasures != null
                  ? TitleValue(
                      title: "Medidas Gerais",
                      value: disease?.generalMeasures ?? "Sem informação")
                  : Container()),
              Container(
                  padding: const EdgeInsets.all(5.5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: ret)),
            ]));
  }

  Widget conditionWidget(context, Conditions? condition) {
    if (condition != null) {
      List<Widget> wgs = [];

      wgs.add(ListTile(
        tileColor: const Color(0xFF2963C8),
        title: Text(condition.condition ?? "",
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.headline4),
      ));
      if (condition.firstline != null) {
        wgs.add(
            TitleValue(title: "1ª Linha", value: condition.firstline ?? ""));
      }
      if (condition.secondline != null) {
        wgs.add(
            TitleValue(title: "2ª Linha", value: condition.secondline ?? ""));
      }
      if (condition.thirdline != null) {
        wgs.add(
            TitleValue(title: "3ª Linha", value: condition.thirdline ?? ""));
      }

      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: wgs,
            ),
          ));
    }
    return Container();
  }
}
