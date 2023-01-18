import 'dart:async';

import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/models/medical_calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/drugs_service.dart';
import '../../services/auth_service.dart';
import '../../utils/string_utils.dart';
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
                        CalculationWidget(medicalCalculation: snapshot.data!),
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

class CalculationWidget extends StatefulWidget {
  const CalculationWidget({Key? key, required this.medicalCalculation})
      : super(key: key);

  final MedicalCalculation medicalCalculation;
  @override
  CalculationState createState() => CalculationState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class CalculationState extends State<CalculationWidget> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> mapOfVariables = {};
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();
  CalculationOutput? _calculationOutput;
  bool _loading = false;

  Timer? _debounce;
  static const nullNumberVal = -99923143898;

  _onVariablesValueChange() {
    if (_calculationOutput != null) {
      setState(() {
        _calculationOutput = null;
      });
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // do something with query
      if (!mapOfVariables.containsValue(null) &&
          !mapOfVariables.containsValue("")) {
        setState(() {
          _loading = true;
        });

        List<CalculationInput> input = [];
        mapOfVariables.forEach((key, value) {
          input.add(CalculationInput(variable: key, value: value));
        });

        var result = await _drugService.executeMedicalCalculation(
            widget.medicalCalculation.id!,
            input,
            await _authenticationService.getUserToken());

        setState(() {
          _loading = false;
          _calculationOutput = result;
        });
      }
    });
  }

  Widget numberVariableWidget(context, Variable variable) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        fillColor: const Color(0xFF2963C8),
        labelText: variable.description! + " (" + variable.idUnit! + ")",
      ),
      onChanged: (String? value) {
        mapOfVariables[variable.variableId!] =
            (value == null || value == "" ? null : double.parse(value));
        _onVariablesValueChange();
        // listVariables[listVariables
        //     .indexWhere((item) => item['id'] == variable.id)]['value'] = value;
      },
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        if (value == null) {
          return "Campo obrigatório";
        }
        if (!StringUtils.isNumeric(value)) {
          return "O campo deve ser numérico";
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
        fillColor: const Color(0xFF2963C8),
        labelText: variable.description! + " (" + variable.idUnit! + ")",
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
      throw Exception("Invalid variable type: " + variable.type!);
    }

    return Padding(padding: const EdgeInsets.all(10.0), child: wid);
  }

  Widget calculationResultsWidget(context) {
    if (_calculationOutput == null) {
      return Container();
    }

    List<Widget> resultWidgets = [];

    var widg = Flexible(
        child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              ListTile(
                tileColor: const Color(0xFF2963C8),
                title: Text("Resultado",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline4),
              ),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            _calculationOutput!.result.toString() +
                                " " +
                                _calculationOutput!.resultIdUnit!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.headline5)),
                    Text(_calculationOutput!.resultDescription ?? "",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.caption)
                  ])),
            ])));
    resultWidgets.add(widg);

    return Row(
      children: resultWidgets,
    );
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

    List<Widget> formFields = [];

    for (var variable in widget.medicalCalculation.variables!) {
      if (mapOfVariables.containsKey(variable.variableId!)) {
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
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _loading ? const Loading() : calculationResultsWidget(context))
    ]);
  }
}