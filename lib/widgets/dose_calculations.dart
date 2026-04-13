import 'dart:async';

import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/providers/subscription_provider.dart';
import 'package:easypedv3/services/analytics_service.dart';
import 'package:easypedv3/services/pdf_service.dart';
import 'package:easypedv3/utils/string_utils.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

class DoseCalculations extends ConsumerStatefulWidget {
  const DoseCalculations({required this.drug, super.key});

  final Drug drug;
  @override
  DoseCalculationsState createState() => DoseCalculationsState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class DoseCalculationsState extends ConsumerState<DoseCalculations> {
  final _formKey = GlobalKey<FormState>();
  Map mapOfVariables = {};
  List<DoseCalculationResult> _doseCalculationsResults = [];
  bool _loading = false;
  bool _limitReached = false;

  Timer? _debounce;

  static const int nullNumberVal = -99923143898;

  void _invalidateResult() {
    if (_doseCalculationsResults.isNotEmpty || _limitReached) {
      setState(() {
        _doseCalculationsResults = [];
        _limitReached = false;
      });
    }
  }

  void _onVariablesValueChange() {
    _invalidateResult();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (kDebugMode) {
        print('Running debounce $mapOfVariables');
      }
      if (!mapOfVariables.containsValue(null) &&
          !mapOfVariables.containsValue('')) {
        // Check usage limit for free users.
        final isPro = ref.read(isProProvider).value ?? false;
        final usage = ref.read(doseUsageProvider);

        if (!isPro && usage >= DoseUsageNotifier.freeLimit) {
          AnalyticsService.logFeatureGateHit(feature: 'dose_calc');
          setState(() {
            _loading = false;
            _doseCalculationsResults = [];
            _limitReached = true;
          });
          return;
        }

        setState(() {
          _loading = true;
          _limitReached = false;
        });

        if (kDebugMode) {
          print('Variables: $mapOfVariables');
        }
        final drugRepository = ref.read(drugRepositoryProvider);
        final doseCalculationsResults = await drugRepository.calculateDose(
            widget.drug.id!, mapOfVariables);

        FirebaseAnalytics.instance.logEvent(
          name: 'drug_dose_calculation',
          parameters: {'drug_id': widget.drug.id!},
        );

        // Track usage for free users.
        if (!isPro) {
          ref.read(doseUsageProvider.notifier).increment();
        }

        setState(() {
          _loading = false;
          _doseCalculationsResults = doseCalculationsResults;
        });
      } else {
        if (kDebugMode) {
          print('Contains nulls');
        }
      }
    });
  }

  Widget numberVariableWidget(context, Variables variable) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
      // ],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        fillColor: Theme.of(context).colorScheme.primary,
        labelText: '${variable.description!} (${variable.idUnit!})',
      ),
      onChanged: (String? value) {
        mapOfVariables[variable.id] = (value == null ||
                value == '' ||
                !StringUtils.isNumeric(value.replaceAll(',', '.'))
            ? null
            : double.parse(value.replaceAll(',', '.'))); // );
        if (kDebugMode) {
          print('Value: $mapOfVariables[variable.id]');
        }
        _onVariablesValueChange();

        // listVariables[listVariables
        //     .indexWhere((item) => item['id'] == variable.id)]['value'] = value;
      },
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (String? value) {
        if (value == null) {
          return 'Campo obrigatório';
        }
        if (!StringUtils.isNumeric(value.replaceAll(',', '.'))) {
          return 'O campo deve ser numérico';
        }
        return null;
      },
    );
  }

  Widget selectVariableWidget(context, Variables variable) {
    throw Exception('Not implemented');
    // return DropdownButton<String>(
    //   value: dropdownValue,
    //   elevation: 16,
    //   onChanged: (String? newValue) {
    //     setState(() {
    //       dropdownValue = newValue!;
    //     });
    //   },
    //   items: <String>['One', 'Two', 'Free', 'Four']
    //       .map<DropdownMenuItem<String>>((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(value),
    //     );
    //   }).toList(),
    // );
  }

  Widget variableWidget(context, Variables variable) {
    Widget wid;
    if (variable.type == 'NUMBER') {
      wid = numberVariableWidget(context, variable);
    } else if (variable.type == 'LISTVALUES') {
      wid = selectVariableWidget(context, variable);
    } else {
      throw Exception('Invalid variable type: ${variable.type!}');
    }

    return Padding(padding: const EdgeInsets.all(10), child: wid);
  }

  Widget doseCalculationResultsWidget(context) {
    if (_doseCalculationsResults.isEmpty) {
      return Container();
    }

    final resultWidgets = <Widget>[];
    for (final result in _doseCalculationsResults) {
      final widg = Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            ListTile(
              tileColor: Theme.of(context).colorScheme.secondary,
              title: Text(result.description ?? '',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            Padding(
                padding: const EdgeInsets.all(2),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('${result.result} ${result.resultIdUnit!}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.headlineSmall)),
                  Text(result.resultDescription ?? '',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodySmall)
                ])),
          ]));
      resultWidgets.add(widg);
    }

    return Column(children: [
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(2),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return resultWidgets[index];
        },
        itemCount: resultWidgets.length,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: OutlinedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Exportar PDF'),
          onPressed: () => _exportPdf(context),
        ),
      ),
    ]);
  }

  Future<void> _exportPdf(BuildContext context) async {
    try {
      final pdfBytes = await PdfService.generateDoseCalculationPdf(
        drug: widget.drug,
        results: _doseCalculationsResults,
        variables: mapOfVariables,
      );

      final safeName = (widget.drug.name ?? 'dose')
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '_');
      await Printing.layoutPdf(
        onLayout: (_) async => pdfBytes,
        name: 'easyPed_${safeName}_calculo.pdf',
      );

      FirebaseAnalytics.instance.logEvent(
        name: 'dose_pdf_export',
        parameters: {'drug_id': widget.drug.id ?? 0},
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao gerar PDF')),
        );
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  bool isFirstTimeRunning = true;

  @override
  Widget build(BuildContext context) {
    if (widget.drug.variables == null || widget.drug.variables!.isEmpty) {
      return Container();
    }

    final formFields = <Widget>[];

    for (final variable in widget.drug.variables!) {
      formFields.add(variableWidget(context, variable));
      if (!mapOfVariables.containsKey(variable.id)) {
        mapOfVariables[variable.id] = null;
      }
    }

    isFirstTimeRunning = false;

    return Column(children: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: formFields,
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _loading
              ? const Loading()
              : _limitReached
                  ? _DoseUsageLimitPrompt()
                  : doseCalculationResultsWidget(context))
    ]);
  }
}

// ── Dose usage limit prompt ─────────────────────────────────────────

class _DoseUsageLimitPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calculate_outlined,
                  size: 28,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Limite diário atingido',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Atingiu o limite de ${DoseUsageNotifier.freeLimit} cálculos '
                'gratuitos por dia. Atualize para Pro para cálculos ilimitados.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.push('/subscription'),
                icon: const Icon(Icons.workspace_premium, size: 18),
                label: const Text('Atualizar para Pro'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
