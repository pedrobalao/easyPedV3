import 'package:easypedv3/services/drugs_service.dart';
import 'package:easypedv3/widgets/dose_calculations.dart';
import 'package:flutter/material.dart';

import '../../models/drug.dart';
import '../../services/auth_service.dart';
import '../../widgets/ep_divider.dart';
import '../../widgets/loading.dart';
import '../../widgets/title_value.dart';

class DrugScreen extends StatefulWidget {
  const DrugScreen({Key? key, required this.drug}) : super(key: key);

  final Drug drug;
  @override
  _DrugScreenState createState() => _DrugScreenState();
}

class _DrugScreenState extends State<DrugScreen> {
  Icon actionIcon = const Icon(Icons.favorite);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(widget.drug.name ?? ""),
            actions: <Widget>[IconButton(icon: actionIcon, onPressed: () {})]),
        body: SingleChildScrollView(
          child: DrugWidget(
            drug: widget.drug,
          ),
        ));
  }
}

class DrugWidget extends StatelessWidget {
  DrugWidget({Key? key, required this.drug}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authService = AuthenticationService();
  final Drug drug;

  Future<Drug> fetchDrug() async =>
      _drugService.fetchDrug(drug.id ?? 0, await _authService.getUserToken());

  @override
  Widget build(context) {
    return FutureBuilder<Drug>(
        future: fetchDrug(),
        builder: (context, AsyncSnapshot<Drug> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleValue(title: "Nome", value: snapshot.data?.name ?? ""),
                calculationWidget(context, snapshot.data!),
                TitleValue(
                    title: "Contra-Indicações",
                    value:
                        snapshot.data?.conterIndications ?? "Sem informação"),
                TitleValue(
                    title: "Efeitos-Secundários",
                    value: snapshot.data?.secondaryEffects ?? "Sem informação"),
                TitleValue(
                    title: "Apresentação",
                    value: snapshot.data?.presentation ?? "Sem informação"),
                TitleValue(
                    title: "Marcas Comerciais",
                    value: snapshot.data?.comercialBrands ?? "Sem informação"),
                Container(
                    child: Text("Indicações",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline6),
                    padding: const EdgeInsets.all(5.5)),
                indicationsWidget(context, snapshot.data?.indications)
              ],
            );
          } else {
            return const Loading();
          }
        });
  }

  Widget calculationWidget(context, Drug drug) {
    if (drug.calculations == null || drug.calculations!.isEmpty) {
      return Container();
    }

    return Container(
        padding: const EdgeInsets.all(5.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Cálculo de Doses",
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.headline6),
            DoseCalculations(drug: drug),
          ],
        ));
  }

  TableRow doseLineWidget(context, String title, String? value) {
    return TableRow(children: [
      Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.headline3)),
      Text(value ?? "Sem informação",
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.bodyText1),
    ]);
  }

  List<Widget> dosesWidget(context, List<Doses>? doses) {
    var widgets = <Widget>[];

    if (doses != null) {
      for (var element in doses) {
        widgets.add(Column(children: [
          Table(
              border: TableBorder.symmetric(),
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(200),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                doseLineWidget(context, "Via", element.idVia),
                doseLineWidget(
                    context, "Dose Pediátrica", element.pediatricDose),
                doseLineWidget(context, "Dose Adulto", element.adultDose),
                doseLineWidget(context, "Tomas", element.takesPerDay),
                doseLineWidget(
                    context, "Max. Dose Diária", element.maxDosePerDay),
                doseLineWidget(context, "Observações", element.obs)
              ]),
          const EpDivider()
        ]));
      }
    }

    return widgets;
  }

  Widget indicationsWidget(context, List<Indications>? indications) {
    List<Widget> ret = [];

    if (indications != null && indications.isNotEmpty) {
      for (var indication in indications) {
        ret.add(indicationWidget(context, indication));
      }
    }
    return Column(
      children: ret,
    );
  }

  Widget indicationWidget(context, Indications? indication) {
    if (indication != null) {
      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  tileColor: const Color(0xFF2963C8),
                  title: Text(indication.indicationText ?? "",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline4),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: dosesWidget(context, indication.doses),
                  ),
                ),
              ],
            ),
          ));
    }
    return Container();
  }
}
