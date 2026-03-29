import 'dart:async';

import 'package:easypedv3/models/percentile.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/utils/app_styles.dart';
import 'package:easypedv3/utils/string_utils.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/date_picker_widget.dart';
import 'package:easypedv3/widgets/growth_chart.dart';
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
class PercentileState extends ConsumerState<PercentilesWidget>
    with SingleTickerProviderStateMixin {
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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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

  /// Calculate the patient's age in months from their birthdate.
  double? _getAgeInMonths() {
    final now = DateTime.now();
    final diff = now.difference(birthdate);
    final months = diff.inDays / 30.44; // Average days per month
    if (months < 0 || months > 60) return null;
    return months;
  }

  bool get _isMale => gender == 'Masculino';

  @override
  Widget build(BuildContext context) {
    if (_onError) return const ConnectionError();

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Percentis')),
        body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(5.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Gender toggle ─────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Text('Sexo: ',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: [
                            ButtonSegment<String>(
                              value: 'Feminino',
                              label: const Text('Feminino'),
                              icon: Icon(Icons.female,
                                  color: gender == 'Feminino'
                                      ? colorScheme.onPrimary
                                      : Colors.pink),
                            ),
                            ButtonSegment<String>(
                              value: 'Masculino',
                              label: const Text('Masculino'),
                              icon: Icon(Icons.male,
                                  color: gender == 'Masculino'
                                      ? colorScheme.onPrimary
                                      : Colors.blue),
                            ),
                          ],
                          selected: {gender},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              gender = newSelection.first;
                              _onVariablesValueChange();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

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

                //PESO
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          fillColor: Theme.of(context).colorScheme.primary,
                          labelText: 'Peso (kg)',
                          prefixIcon: const Icon(Icons.monitor_weight_outlined),
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
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          fillColor: Theme.of(context).colorScheme.primary,
                          labelText: 'Altura (cm)',
                          prefixIcon: const Icon(Icons.height),
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
                  calculationResultsWidget(context),

                // ── Growth Charts ───────────────────────────────
                if (!_loading &&
                    (weight != null || length != null) &&
                    _getAgeInMonths() != null) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Curvas de Crescimento (OMS)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const GrowthChartLegend(),
                  // Tab bar for Weight / Height charts
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Peso'),
                      Tab(text: 'Altura'),
                    ],
                  ),
                  SizedBox(
                    height: 320,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Weight chart
                        GrowthChart(
                          chartType: GrowthChartType.weight,
                          isMale: _isMale,
                          patientAgeMonths: _getAgeInMonths(),
                          patientValue: weight,
                        ),
                        // Height chart
                        GrowthChart(
                          chartType: GrowthChartType.height,
                          isMale: _isMale,
                          patientAgeMonths: _getAgeInMonths(),
                          patientValue: length,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            )));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Widget percentileResult(context, String type, PercentileOutput output) {
    return Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
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
    final colorScheme = Theme.of(context).colorScheme;
    final (Color color, String resultStr) = switch (output.result) {
      'underweight' => (AppColors.warningColor, 'Abaixo do peso'),
      'healthy weight' => (colorScheme.secondary, 'Peso saudável'),
      'overweight' => (AppColors.warningColor, 'Acima do peso'),
      'obesity' => (colorScheme.error, 'Obesidade'),
      _ => (colorScheme.secondary, 'Indefinido'),
    };

    return Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
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
