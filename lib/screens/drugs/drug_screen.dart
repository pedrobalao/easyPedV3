import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/dose_calculations.dart';
import 'package:easypedv3/widgets/drug_favourite.dart';
import 'package:easypedv3/widgets/ep_divider.dart';
import 'package:easypedv3/widgets/skeletons/skeleton_drug_detail.dart';
import 'package:easypedv3/widgets/title_value.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class DrugScreen extends ConsumerWidget {
  const DrugScreen({required this.id, super.key});

  final int id;

  /// Returns the icon for a given administration route.
  static IconData _routeIcon(String? route) {
    if (route == null) return Icons.medication;
    final r = route.toUpperCase().trim();
    if (r.contains('IV') || r.contains('INTRAVENOSA') || r.contains('EV')) {
      return Icons.water_drop;
    }
    if (r.contains('IM') || r.contains('INTRAMUSCULAR')) {
      return Icons.vaccines;
    }
    if (r.contains('PO') ||
        r.contains('ORAL') ||
        r.contains('VIA ORAL') ||
        r.contains('PER OS')) {
      return Icons.medication_liquid;
    }
    if (r.contains('SC') || r.contains('SUBCUTÂN')) {
      return Icons.healing;
    }
    if (r.contains('INAL') || r.contains('NEBUL')) {
      return Icons.air;
    }
    if (r.contains('RECT') || r.contains('RETAL')) {
      return Icons.radio_button_checked;
    }
    if (r.contains('TOP') || r.contains('CUTÂN')) {
      return Icons.back_hand;
    }
    return Icons.medication;
  }

  void _shareDrug(Drug drug) {
    final buffer = StringBuffer()..writeln('${drug.name}');

    if (drug.presentation != null && drug.presentation!.isNotEmpty) {
      buffer.writeln('Apresentação: ${drug.presentation}');
    }
    if (drug.comercialBrands != null && drug.comercialBrands!.isNotEmpty) {
      buffer.writeln('Marcas: ${drug.comercialBrands}');
    }
    if (drug.indications != null) {
      for (final ind in drug.indications!) {
        buffer.writeln('\nIndicação: ${ind.indicationText ?? ""}');
        if (ind.doses != null) {
          for (final dose in ind.doses!) {
            buffer.writeln('  Via: ${dose.idVia ?? "-"} | '
                'Dose Pediátrica: ${dose.pediatricDose ?? "-"} '
                '${dose.idUnityPediatricDose ?? ""} | '
                'Dose Adulto: ${dose.adultDose ?? "-"} '
                '${dose.idUnityAdultDose ?? ""}');
          }
        }
      }
    }
    buffer.writeln('\n— easyPed');

    Share.share(buffer.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugAsync = ref.watch(drugDetailProvider(id));

    return drugAsync.when(
      loading: () => const SkeletonDrugDetail(),
      error: (_, __) => const ConnectionError(),
      data: (drug) {
        FirebaseAnalytics.instance.logViewItem(items: [
          AnalyticsEventItem(
            itemCategory: 'drug',
            itemId: id.toString(),
            itemName: drug.name,
          ),
        ]);
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Hero(
                tag: 'drug-name-$id',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    drug.name ?? '',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Partilhar',
                  onPressed: () => _shareDrug(drug),
                ),
                DrugFavourite(drugId: id),
              ],
              bottom: TabBar(
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withValues(alpha: 0.6),
                indicatorColor: Theme.of(context).colorScheme.onPrimary,
                tabs: const [
                  Tab(icon: Icon(Icons.info_outline), text: 'Geral'),
                  Tab(icon: Icon(Icons.calculate), text: 'Dosagem'),
                  Tab(icon: Icon(Icons.notes), text: 'Notas'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _OverviewTab(drug: drug),
                _DosingTab(drug: drug),
                _NotesTab(drug: drug),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Overview tab: name, presentation, brands, contra-indications, indications.
class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.drug});
  final Drug drug;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleValue(title: 'Nome', value: drug.name ?? ''),
          TitleValue(
            title: 'Apresentação',
            value: drug.presentation ?? 'Sem informação',
          ),
          TitleValue(
            title: 'Marcas Comerciais',
            value: drug.comercialBrands ?? 'Sem informação',
          ),
          TitleValue(
            title: 'Contra-Indicações',
            value: drug.conterIndications ?? 'Sem informação',
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.5),
            child: Text(
              'Indicações',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          _IndicationsExpansionList(indications: drug.indications),
        ],
      ),
    );
  }
}

/// Dosing tab: dose calculations + indication dose tables.
class _DosingTab extends StatelessWidget {
  const _DosingTab({required this.drug});
  final Drug drug;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _calculationWidget(context, drug),
          if (drug.indications != null && drug.indications!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(5.5),
              child: Text(
                'Doses por Indicação',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _IndicationDosesList(indications: drug.indications!),
          ],
        ],
      ),
    );
  }

  Widget _calculationWidget(BuildContext context, Drug drug) {
    if (drug.calculations == null || drug.calculations!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sem cálculo de doses disponível para este medicamento.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(5.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.calculate,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Cálculo de Doses',
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          DoseCalculations(drug: drug),
        ],
      ),
    );
  }
}

/// Notes tab: secondary effects, observations.
class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.drug});
  final Drug drug;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleValue(
            title: 'Efeitos Secundários',
            value: drug.secondaryEffects ?? 'Sem informação',
          ),
          TitleValue(
            title: 'Observações',
            value: drug.obs ?? 'Sem informação',
          ),
        ],
      ),
    );
  }
}

/// Expandable indication cards using ExpansionTile.
class _IndicationsExpansionList extends StatelessWidget {
  const _IndicationsExpansionList({this.indications});
  final List<Indications>? indications;

  @override
  Widget build(BuildContext context) {
    if (indications == null || indications!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Sem indicações disponíveis.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: indications!.length,
      itemBuilder: (context, index) {
        final indication = indications![index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            leading: Icon(
              Icons.medical_information,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              indication.indicationText ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            children: [
              if (indication.doses != null)
                ...indication.doses!.map(
                  (dose) => _DoseSummaryTile(dose: dose),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A compact dose summary tile with route icon.
class _DoseSummaryTile extends StatelessWidget {
  const _DoseSummaryTile({required this.dose});
  final Doses dose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            DrugScreen._routeIcon(dose.idVia),
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dose.idVia ?? 'Via não especificada',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                if (dose.pediatricDose != null)
                  Text(
                    'Pediátrica: ${dose.pediatricDose} ${dose.idUnityPediatricDose ?? ""}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                if (dose.adultDose != null)
                  Text(
                    'Adulto: ${dose.adultDose} ${dose.idUnityAdultDose ?? ""}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                if (dose.takesPerDay != null)
                  Text(
                    'Tomas/dia: ${dose.takesPerDay}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Indication doses list for the Dosing tab.
class _IndicationDosesList extends StatelessWidget {
  const _IndicationDosesList({required this.indications});
  final List<Indications> indications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: indications.length,
      itemBuilder: (context, index) {
        final indication = indications[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                tileColor: Theme.of(context).colorScheme.secondary,
                title: Text(
                  indication.indicationText ?? '',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              if (indication.doses != null)
                ...indication.doses!.map(
                  (dose) => _DetailedDoseTile(dose: dose),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Detailed dose tile with all dose fields, shown in the Dosing tab.
class _DetailedDoseTile extends StatelessWidget {
  const _DetailedDoseTile({required this.dose});
  final Doses dose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                DrugScreen._routeIcon(dose.idVia),
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                dose.idVia ?? 'Via não especificada',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Table(
            border: const TableBorder.symmetric(),
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(180),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _doseLineWidget(context, 'Dose Pediátrica',
                  '${dose.pediatricDose ?? "-"} ${dose.idUnityPediatricDose ?? ""}'),
              _doseLineWidget(context, 'Dose Adulto',
                  '${dose.adultDose ?? "-"} ${dose.idUnityAdultDose ?? ""}'),
              _doseLineWidget(context, 'Tomas/dia', dose.takesPerDay),
              _doseLineWidget(context, 'Max. Dose Diária',
                  '${dose.maxDosePerDay ?? "-"} ${dose.idUnityMaxDosePerDay ?? ""}'),
              if (dose.obs != null && dose.obs!.isNotEmpty)
                _doseLineWidget(context, 'Observações', dose.obs),
            ],
          ),
          const EpDivider(),
        ],
      ),
    );
  }

  TableRow _doseLineWidget(BuildContext context, String title, String? value) {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      Text(
        value ?? 'Sem informação',
        textAlign: TextAlign.left,
        overflow: TextOverflow.clip,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ]);
  }
}
