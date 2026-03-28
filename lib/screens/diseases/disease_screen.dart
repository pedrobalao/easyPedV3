import 'package:easypedv3/models/disease.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/title_value.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiseaseScreen extends ConsumerWidget {
  const DiseaseScreen({required this.diseaseId, super.key});

  final int diseaseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diseaseAsync = ref.watch(diseaseDetailProvider(diseaseId));

    return diseaseAsync.when(
      loading: () => const ScreenLoading(),
      error: (_, __) => const ConnectionError(),
      data: (disease) {
        FirebaseAnalytics.instance.logViewItem(items: [
          AnalyticsEventItem(
              itemCategory: 'disease',
              itemId: disease.id.toString(),
              itemName: disease.description)
        ]);
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(disease.description ?? '')),
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleValue(
                    title: 'Doença',
                    value: disease.description ?? ''),
                TitleValue(
                    title: 'Autor',
                    value: disease.author ?? 'Sem informação'),
                TitleValue(
                    title: 'Indicação',
                    value: disease.indication ?? 'Sem informação'),
                _treatmentWidget(context, disease),
                TitleValue(
                    title: 'Follow-up',
                    value: disease.followup ?? 'Sem informação'),
                TitleValue(
                    title: 'Bibliografia',
                    value: disease.bibliography ?? 'Sem informação'),
              ],
            )));
      },
    );
  }

  Widget _treatmentWidget(BuildContext context, Disease? disease) {
    final ret = <Widget>[];

    if (disease != null &&
        disease.treatment != null &&
        disease.treatment!.conditions!.isNotEmpty) {
      for (final condition in disease.treatment!.conditions!) {
        ret.add(_conditionWidget(context, condition));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleValue(title: 'Tratamento'),
      (disease?.generalMeasures != null
          ? SubTitleValue(
              title: 'Medidas Gerais',
              value: disease?.generalMeasures ?? 'Sem informação')
          : Container()),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: ret),
    ]);
  }

  Widget _conditionWidget(BuildContext context, Conditions? condition) {
    if (condition != null) {
      final wgs = <Widget>[];

      wgs.add(ListTile(
        tileColor: Theme.of(context).colorScheme.primary,
        title: Text(condition.condition ?? '',
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.headlineMedium),
      ));
      if (condition.firstline != null) {
        wgs.add(
            SubTitleValue(title: '1ª Linha', value: condition.firstline ?? ''));
      }
      if (condition.secondline != null) {
        wgs.add(SubTitleValue(
            title: '2ª Linha', value: condition.secondline ?? ''));
      }
      if (condition.thirdline != null) {
        wgs.add(
            SubTitleValue(title: '3ª Linha', value: condition.thirdline ?? ''));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: wgs,
      );
    }
    return Container();
  }
}
