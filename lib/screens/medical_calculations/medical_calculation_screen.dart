import 'dart:async';

import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/models/medical_calculation.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/utils/string_utils.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/title_value.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicalCalculationScreen extends ConsumerWidget {
  const MedicalCalculationScreen(
      {required this.medicalCalculationId, super.key});

  final int medicalCalculationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcAsync = ref.watch(calculatorDetailProvider(medicalCalculationId));

    return calcAsync.when(
      loading: () => const ScreenLoading(),
      error: (_, __) => const ConnectionError(),
      data: (medicalCalculation) {
        FirebaseAnalytics.instance.logViewItem(items: [
          AnalyticsEventItem(
              itemCategory: 'medical_calculation',
              itemId: medicalCalculation.id.toString(),
              itemName: medicalCalculation.description)
        ]);
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(medicalCalculation.description ?? '')),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(5.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleValue(
                        title: 'Cálculo',
                        value: medicalCalculation.description ?? ''),
                    CalculationWidget(
                        medicalCalculation: medicalCalculation),
                    TitleValue(
                        title: 'Observações',
                        value: medicalCalculation.observation ??
                            'Sem informação'),
                  ],
                )));
      },
    );
  }
}

class CalculationWidget extends ConsumerStatefulWidget {
  const CalculationWidget({required this.medicalCalculation, super.key});

  final MedicalCalculation medicalCalculation;
  @override
  CalculationState createState() => CalculationState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class CalculationState extends ConsumerState<CalculationWidget> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> mapOfVariables = {};
  CalculationOutput? _calculationOutput;
  bool _loading = false;

  Timer? _debounce;
  static const int nullNumberVal = -99923143898;

  void _onVariablesValueChange() {
    if (_calculationOutput != null) {
      setState(() {
        _calculationOutput = null;
      });
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // do something with query
      if (!mapOfVariables.containsValue(null) &&
          !mapOfVariables.containsValue('')) {
        setState(() {
          _loading = true;
        });

        final input = <CalculationInput>[];
        mapOfVariables.forEach((key, value) {
          input.add(CalculationInput(variable: key, value: value));
        });

        final calculatorRepository = ref.read(calculatorRepositoryProvider);
        final result = await calculatorRepository.executeMedicalCalculation(
            widget.medicalCalculation.id!,
            input);

        FirebaseAnalytics.instance.logEvent(
          name: 'medical_calculation',
          parameters: {'medical_calculation_id': widget.medicalCalculation.id!},
        );
        setState(() {
          _loading = false;
          _calculationOutput = result;
        });
      }
    });
  }

  Widget numberVariableWidget(context, Variable variable) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        fillColor: Theme.of(context).colorScheme.primary,
        labelText: '${variable.description!} (${variable.idUnit!})',
      ),
      onChanged: (String? value) {
        mapOfVariables[variable.variableId!] = (value == null ||
                value == '' ||
                !StringUtils.isNumeric(value.replaceAll(',', '.'))
            ? null
            : double.parse(value.replaceAll(',', '.')));
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

  Widget selectVariableWidget(context, Variable variable) {
    //throw Exception("Not implemented");
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        fillColor: Theme.of(context).colorScheme.primary,
        labelText: '${variable.description!} (${variable.idUnit!})',
      ),
      isExpanded: true,
      value: mapOfVariables[variable.variableId!],
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          mapOfVariables[variable.variableId!] = newValue;
          _onVariablesValueChange();
        });
      },
      items: variable.values?.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget variableWidget(context, Variable variable) {
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

  Widget calculationResultsWidget(context) {
    if (_calculationOutput == null) {
      return Container();
    }

    final resultWidgets = <Widget>[];

    final widg = Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          ListTile(
            tileColor: Theme.of(context).colorScheme.primary,
            title: Text('Resultado',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
              padding: const EdgeInsets.all(2),
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                        '${_calculationOutput!.result} ${_calculationOutput!.resultIdUnit!}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headlineSmall)),
                Text(_calculationOutput!.resultDescription ?? '',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodySmall)
              ])),
        ]));
    resultWidgets.add(widg);

    return widg;
    // return column(
    //   children: resultWidgets,
    // );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.medicalCalculation.variables == null ||
        widget.medicalCalculation.variables!.isEmpty) {
      return Container();
    }

    final formFields = <Widget>[];

    for (final variable in widget.medicalCalculation.variables!) {
      if (mapOfVariables.containsKey(variable.variableId)) {
      } else {
        if (variable.type == 'LISTVALUES') {
          mapOfVariables[variable.variableId!] = variable.values![0];
        } else {
          mapOfVariables[variable.variableId!] = null;
        }
      }
      formFields.add(variableWidget(context, variable));
    }

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
          child: _loading ? const Loading() : calculationResultsWidget(context))
    ]);
  }
}
