import 'dart:async';

import 'package:easypedv3/services/auth_service.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/drug.dart';
import '../services/drugs_service.dart';
import '../utils/string_utils.dart';

class DoseCalculations extends StatefulWidget {
  const DoseCalculations({Key? key, required this.drug}) : super(key: key);

  final Drug drug;
  @override
  DoseCalculationsState createState() => DoseCalculationsState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class DoseCalculationsState extends State<DoseCalculations> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var mapOfVariables = {};
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();
  List<DoseCalculationResult> _doseCalculationsResults = [];
  bool _loading = false;

  Timer? _debounce;

  static const nullNumberVal = -99923143898;

  _onVariablesValueChange() {
    if (_doseCalculationsResults.isNotEmpty) {
      setState(() {
        _doseCalculationsResults = [];
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

        var doseCalculationsResults = await _drugService.doseCalculation(
            widget.drug.id!,
            mapOfVariables,
            await _authenticationService.getUserToken());

        setState(() {
          _loading = false;
          _doseCalculationsResults = doseCalculationsResults;
        });
      }
    });
  }

  Widget numberVariableWidget(context, Variables variable) {
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
        mapOfVariables[variable.id] =
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
          return "Campo obrigat??rio";
        }
        if (!StringUtils.isNumeric(value)) {
          return "O campo deve ser num??rico";
        }
        return null;
      },
    );
  }

  Widget selectVariableWidget(context, Variables variable) {
    throw Exception("Not implemented");
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
      throw Exception("Invalid variable type: " + variable.type!);
    }

    return Padding(padding: const EdgeInsets.all(10.0), child: wid);
  }

  Widget doseCalculationResultsWidget(context) {
    if (_doseCalculationsResults.isEmpty) {
      return Container();
    }

    List<Widget> resultWidgets = [];
    for (var result in _doseCalculationsResults) {
      var widg = Flexible(
          child: Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                ListTile(
                  tileColor: const Color(0xFF2963C8),
                  title: Text(result.description ?? "",
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
                              result.result.toString() +
                                  " " +
                                  result.resultIdUnit!,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: Theme.of(context).textTheme.headline5)),
                      Text(result.resultDescription ?? "",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.caption)
                    ])),
              ])));
      resultWidgets.add(widg);
    }

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
    if (widget.drug.variables == null || widget.drug.variables!.isEmpty) {
      return Container();
    }

    List<Widget> formFields = [];

    for (var variable in widget.drug.variables!) {
      formFields.add(variableWidget(context, variable));
      mapOfVariables[variable.id] = null;
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
          child: _loading
              ? const Loading()
              : doseCalculationResultsWidget(context))
    ]);
  }
}
