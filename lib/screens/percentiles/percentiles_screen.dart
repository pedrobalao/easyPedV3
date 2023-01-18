import 'dart:async';

import 'package:easypedv3/models/percentile.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/drugs_service.dart';
import '../../services/auth_service.dart';
import '../../utils/string_utils.dart';
import '../../widgets/title_value.dart';
import 'package:date_time_picker/date_time_picker.dart';

class PercentilesScreen extends StatefulWidget {
  const PercentilesScreen({Key? key}) : super(key: key);

  @override
  _PercentilesScreenState createState() => _PercentilesScreenState();
}

class _PercentilesScreenState extends State<PercentilesScreen> {
  Icon actionIcon = const Icon(Icons.favorite);
  @override
  Widget build(BuildContext context) {
    return PercentilesWidget();
  }
}

class PercentilesWidget extends StatefulWidget {
  const PercentilesWidget({Key? key}) : super(key: key);

  @override
  PercentileState createState() => PercentileState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class PercentileState extends State<PercentilesWidget> {
  final _formKey = GlobalKey<FormState>();

  Timer? _debounce;
  static const nullNumberVal = -99923143898;

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  DateTime birthdate = DateTime.now();
  String gender = "Feminino";
  double? weight;
  double? length;

  var genderOptions = ["Feminino", "Masculino"];

  PercentileOutput? _weightPercentileResult;
  PercentileOutput? _lengthPercentileResult;
  BMIOutput? _bmiPercentileResult;

  bool _loading = false;

  _onVariablesValueChange() {
    setState(() {
      _weightPercentileResult = null;
      _lengthPercentileResult = null;
      _bmiPercentileResult = null;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // do something with query
      if (birthdate != null &&
          gender != "" &&
          (weight != null || length != null)) {
        setState(() {
          _loading = true;
        });

        var authToken = await _authenticationService.getUserToken();
        var req = <Future>[];

        var stdGender = gender == "Masculino" ? "male" : "female";

        if (weight != null) {
          var wInput = PercentileInput(
              gender: stdGender,
              birthdate: birthdate.toIso8601String(),
              value: weight);
          req.add(_drugService
              .executeWeightPercentile(wInput, authToken)
              .then((value) => _weightPercentileResult = value));
        }

        if (length != null) {
          var lInput = PercentileInput(
              gender: stdGender,
              birthdate: birthdate.toIso8601String(),
              value: length);
          req.add(_drugService
              .executeLengthPercentile(lInput, authToken)
              .then((value) => _lengthPercentileResult = value));
        }

        if (weight != null && length != null) {
          var bmiInput = BMIInput(
              gender: stdGender,
              birthdate: birthdate.toIso8601String(),
              length: length,
              weight: weight);
          req.add(_drugService
              .executeBMIPercentile(bmiInput, authToken)
              .then((value) => _bmiPercentileResult = value));
        }

        await Future.wait(req);

        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Percentis")),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(5.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DateTimePicker(
                      dateMask: 'yyyy-MM-dd',
                      initialValue: birthdate.toString(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 6574)),
                      lastDate: DateTime.now(),
                      dateLabelText: 'Data de Nascimento',
                      onChanged: (String val) {
                        setState(() {
                          birthdate = DateTime.parse(val);
                          _onVariablesValueChange();
                        });
                      },
                      validator: (val) {
                        if (val == null) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                      onSaved: (val) => {},
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFF2963C8),
                        labelText: "Sexo",
                      ),
                      isExpanded: true,
                      value: gender,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue ?? "Feminino";
                          _onVariablesValueChange();
                        });
                      },
                      items: genderOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),

                //PESO
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFF2963C8),
                          labelText: "Peso (kg)",
                        ),
                        onChanged: (String? value) {
                          weight = (value == null || value == ""
                              ? null
                              : double.parse(value));
                          _onVariablesValueChange();
                        },
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          if (!StringUtils.isNumeric(value)) {
                            return "O campo deve ser numérico";
                          }
                          return null;
                        })),

                //ALTURA
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFF2963C8),
                          labelText: "Altura (cm)",
                        ),
                        onChanged: (String? value) {
                          length = (value == null || value == ""
                              ? null
                              : double.parse(value));
                          _onVariablesValueChange();
                        },
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          if (!StringUtils.isNumeric(value)) {
                            return "O campo deve ser numérico";
                          }
                          return null;
                        })),
                _loading ? const Loading() : calculationResultsWidget(context)
              ],
            )));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget percentileResult(context, String type, PercentileOutput output) {
    return Flexible(
        child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              ListTile(
                tileColor: const Color(0xFF2963C8),
                title: Text("Percentil " + type,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline4),
              ),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(output.percentile.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.headline5)),
                  ])),
            ])));
  }

  Widget bmiResult(context, BMIOutput output) {
    Color color;
    String resultStr;
    switch (output.result) {
      case "underweight":
        color = const Color(0xFFffc107);
        resultStr = "Abaixo do peso";
        break;
      case "healthy weight":
        color = const Color(0xFF28a745);
        resultStr = "Peso saudável";
        break;
      case "overweight":
        color = const Color(0xFFffc107);
        resultStr = "Acima do peso";
        break;
      case "obesity":
        color = const Color(0xFF651F06);
        resultStr = "Obesidade";
        break;
      default:
        color = const Color(0xFF28a745);
        resultStr = "Indefinido";
        break;
    }

    return Flexible(
        child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              ListTile(
                tileColor: const Color(0xFF2963C8),
                title: Text("IMC",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline4),
              ),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child:
                            //
                            Text(output.percentile.toString(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.merge(TextStyle(color: color)))),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(resultStr,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.merge(TextStyle(color: color))))
                  ]))
            ])));
  }

  Widget calculationResultsWidget(context) {
    if (_weightPercentileResult == null &&
        _lengthPercentileResult == null &&
        _bmiPercentileResult == null) {
      return Container();
    }

    List<Widget> resultWidgets = [];

    if (_weightPercentileResult != null) {
      resultWidgets
          .add(percentileResult(context, "Peso", _weightPercentileResult!));
    }

    if (_lengthPercentileResult != null) {
      resultWidgets
          .add(percentileResult(context, "Altura", _lengthPercentileResult!));
    }

    if (_bmiPercentileResult != null) {
      resultWidgets.add(percentileResult(
          context,
          "IMC",
          PercentileOutput(
              percentile: _bmiPercentileResult?.percentile, description: "")));
      resultWidgets.add(bmiResult(context, _bmiPercentileResult!));
    }
    return Row(
      children: resultWidgets,
    );
  }
}