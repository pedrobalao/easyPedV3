import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/dose_calculations.dart';
import 'package:easypedv3/widgets/drug_favourite.dart';
import 'package:easypedv3/widgets/ep_divider.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/title_value.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugScreen extends ConsumerWidget {
  const DrugScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugAsync = ref.watch(drugDetailProvider(id));

    return drugAsync.when(
      loading: () => const ScreenLoading(),
      error: (_, __) => const ConnectionError(),
      data: (drug) {
        FirebaseAnalytics.instance.logViewItem(items: [
          AnalyticsEventItem(
              itemCategory: 'drug',
              itemId: id.toString(),
              itemName: drug.name)
        ]);
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(drug.name ?? ''),
                actions: <Widget>[DrugFavourite(drugId: id)]),
            body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleValue(
                        title: 'Nome', value: drug.name ?? ''),
                    _calculationWidget(context, drug),
                    TitleValue(
                        title: 'Contra-Indicações',
                        value: drug.conterIndications ??
                            'Sem informação'),
                    TitleValue(
                        title: 'Efeitos-Secundários',
                        value: drug.secondaryEffects ??
                            'Sem informação'),
                    TitleValue(
                        title: 'Apresentação',
                        value: drug.presentation ??
                            'Sem informação'),
                    TitleValue(
                        title: 'Marcas Comerciais',
                        value: drug.comercialBrands ??
                            'Sem informação'),
                    Padding(
                        padding: const EdgeInsets.all(5.5),
                        child: Text('Indicações',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.titleLarge)),
                    _indicationsWidget(context, drug.indications)
                  ],
                )));
      },
    );
  }

  Widget _calculationWidget(BuildContext context, Drug drug) {
    if (drug.calculations == null || drug.calculations!.isEmpty) {
      return Container();
    }

    return Container(
        padding: const EdgeInsets.all(5.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cálculo de Doses',
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.titleLarge),
            DoseCalculations(drug: drug),
          ],
        ));
  }

  TableRow _doseLineWidget(BuildContext context, String title, String? value) {
    return TableRow(children: [
      Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.displaySmall)),
      Text(value ?? 'Sem informação',
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.bodyLarge),
    ]);
  }

  List<Widget> _dosesWidget(BuildContext context, List<Doses>? doses) {
    final widgets = <Widget>[];

    if (doses != null) {
      for (final element in doses) {
        widgets.add(Column(children: [
          Table(
              border: const TableBorder.symmetric(),
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(200),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _doseLineWidget(context, 'Via', element.idVia),
                _doseLineWidget(context, 'Dose Pediátrica',
                    '${element.pediatricDose} ${element.idUnityPediatricDose}'),
                _doseLineWidget(context, 'Dose Adulto',
                    '${element.adultDose} ${element.idUnityAdultDose}'),
                _doseLineWidget(context, 'Tomas', element.takesPerDay),
                _doseLineWidget(context, 'Max. Dose Diária',
                    '${element.maxDosePerDay} ${element.idUnityMaxDosePerDay}'),
                _doseLineWidget(context, 'Observações', element.obs)
              ]),
          const EpDivider()
        ]));
      }
    }

    return widgets;
  }

  Widget _indicationsWidget(
      BuildContext context, List<Indications>? indications) {
    final ret = <Widget>[];

    if (indications != null && indications.isNotEmpty) {
      for (final indication in indications) {
        ret.add(_indicationWidget(context, indication));
      }
    }
    return Column(
      children: ret,
    );
  }

  Widget _indicationWidget(BuildContext context, Indications? indication) {
    if (indication != null) {
      return Column(
        children: [
          ListTile(
            tileColor: const Color(0xFF28a745),
            title: Text(indication.indicationText ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: _dosesWidget(context, indication.doses),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
