import 'dart:async';

import 'package:easypedv3/models/percentile.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/utils/string_utils.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/date_picker_widget.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PercentilesScreen extends ConsumerStatefulWidget {
  const PercentilesScreen({super.key});

  @override
  ConsumerState<PercentilesScreen> createState() => _PercentilesScreenState();
}

class _PercentilesScreenState extends ConsumerState<PercentilesScreen> {
  Icon actionIcon = const Icon(Icons.favorite);
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logViewItem(items: [
      AnalyticsEventItem(
          itemCategory: 'percentiles', itemId: '1', itemName: 'percentiles')
    ]);

    return const PercentilesWidget();
  }
}

class PercentilesWidget extends ConsumerStatefulWidget {
  const PercentilesWidget({super.key});

  @override
  PercentileState createState() => PercentileState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class PercentileState extends ConsumerState<PercentilesWidget> {
  final _formKey = GlobalKey<FormState>();

  Timer? _debounce;
  static const int nullNumberVal = -99923143898;

  DateTime birthdate = DateTime.now();
  String gender = 'Feminino';
  double? weight;
  double? length;

  List<String> genderOptions = ['Feminino', 'Masculino'];

  PercentileOutput? _weightPercentileResult;
  PercentileOutput? _lengthPercentileResult;
  BMIOutput? _bmiPercentileResult;

  bool _loading = false;
  bool _onError = false;

  void _onVariablesValueChange() {
    setState(() {
      _weightPercentileResult = null;
      _lengthPercentileResult = null;
      _bmiPercentileResult = null;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // do something with query
      if (gender != '' && (weight != null || length != null)) {
        setState(() {
          _loading = true;
        });
        try {
          final percentileRepository = ref.read(percentileRepositoryProvider);
          final req = <Future>[];

          final stdGender = gender == 'Masculino' ? 'male' : 'female';

          if (weight != null) {
            final wInput = PercentileInput(
                gender: stdGender,
                birthdate: birthdate.toUtc().toIso8601String(),
                value: weight);
            req.add(percentileRepository
                .calculateWeightPercentile(wInput)
                .then((value) => _weightPercentileResult = value));
          }

          if (length != null) {
            final lInput = PercentileInput(
                gender: stdGender,
                birthdate: birthdate.toUtc().toIso8601String(),
                value: length);
            req.add(percentileRepository
                .calculateLengthPercentile(lInput)
                .then((value) => _lengthPercentileResult = value));
          }

          if (weight != null && length != null) {
            final bmiInput = BMIInput(
                gender: stdGender,
                birthdate: birthdate.toUtc().toIso8601String(),
                length: length,
                weight: weight);
            req.add(percentileRepository
                .calculateBMIPercentile(bmiInput)
                .then((value) => _bmiPercentileResult = value));
          }

          await Future.wait(req);

          FirebaseAnalytics.instance.logEvent(
            name: 'percentiles_calculation',
            parameters: {'gender': stdGender},
          );

          setState(() {
            _loading = false;
            _onError = false;
          });
        } catch (exc) {
          setState(() {
            _loading = false;
            _onError = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_onError) return const ConnectionError();

    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Percentis')),
        body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(5.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: DatePickerWidget(
                        label: 'Data de Nascimento',
                        initialDate: DateTime.now(),
                        minDate:
                            DateTime.now().subtract(const Duration(days: 6570)),
                        maxDate: DateTime.now(),
                        onDateSelected: (date) {
                          setState(() {
                            birthdate = date;
                            _onVariablesValueChange();
                          });
                        })),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFF2963C8),
                        labelText: 'Sexo',
                      ),
                      isExpanded: true,
                      value: gender,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue ?? 'Feminino';
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
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFF2963C8),
                          labelText: 'Peso (kg)',
                        ),
                        onChanged: (String? value) {
                          weight = (value == null ||
                                  value == '' ||
                                  !StringUtils.isNumeric(
                                      value.replaceAll(',', '.'))
                              ? null
                              : double.parse(value.replaceAll(',', '.')));
                          _onVariablesValueChange();
                        },
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value == null) {
                            return null;
                          }
                          if (!StringUtils.isNumeric(
                              value.replaceAll(',', '.'))) {
                            return 'O campo deve ser numérico';
                          }
                          return null;
                        })),

                //ALTURA
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,3}')),
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFF2963C8),
                          labelText: 'Altura (cm)',
                        ),
                        onChanged: (String? value) {
                          length = (value == null || value == ''
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
                            return 'O campo deve ser numérico';
                          }
                          return null;
                        })),

                if (_loading)
                  const Loading()
                else
                  calculationResultsWidget(context)
              ],
            )));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget percentileResult(context, String type, PercentileOutput output) {
    return Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          ListTile(
            tileColor: const Color(0xFF28a745),
            title: Text('Percentil $type',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
              padding: const EdgeInsets.all(2),
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(output.percentile.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headlineSmall)),
              ])),
        ]));
  }

  Widget bmiResult(context, BMIOutput output) {
    final (Color color, String resultStr) = switch (output.result) {
      'underweight' => (const Color(0xFFffc107), 'Abaixo do peso'),
      'healthy weight' => (const Color(0xFF28a745), 'Peso saudável'),
      'overweight' => (const Color(0xFFffc107), 'Acima do peso'),
      'obesity' => (const Color(0xFF651F06), 'Obesidade'),
      _ => (const Color(0xFF28a745), 'Indefinido'),
    };

    return Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          ListTile(
            tileColor: const Color(0xFF28a745),
            title: Text('IMC',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
              padding: const EdgeInsets.all(2),
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child:
                        //
                        Text(output.percentile.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.merge(TextStyle(color: color)))),
                Text(resultStr,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.merge(TextStyle(color: color)))
              ]))
        ]));
  }

  Widget calculationResultsWidget(context) {
    if (_weightPercentileResult == null &&
        _lengthPercentileResult == null &&
        _bmiPercentileResult == null) {
      return Container();
    }

    final resultWidgets = <Widget>[];

    if (_weightPercentileResult != null) {
      resultWidgets
          .add(percentileResult(context, 'Peso', _weightPercentileResult!));
    }

    if (_lengthPercentileResult != null) {
      resultWidgets
          .add(percentileResult(context, 'Altura', _lengthPercentileResult!));
    }

    if (_bmiPercentileResult != null) {
      resultWidgets.add(percentileResult(
          context,
          'IMC',
          PercentileOutput(
              percentile: _bmiPercentileResult?.percentile, description: '')));
      resultWidgets.add(bmiResult(context, _bmiPercentileResult!));
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return resultWidgets[index];
      },
      itemCount: resultWidgets.length,
    );
  }
}
