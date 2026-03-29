import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// WHO growth chart reference data for weight-for-age (0-60 months).
/// Values are in kg, ages in months.
class _WhoData {
  // Weight-for-age BOYS (kg) - months 0 to 60
  static const List<double> weightBoys3rd = [
    2.5, 3.4, 4.4, 5.1, 5.6, 6.1, 6.4, 6.7, 7.0, 7.2,
    7.5, 7.7, 7.8, 8.0, 8.2, 8.4, 8.5, 8.7, 8.9, 9.0,
    9.2, 9.3, 9.5, 9.7, 9.8, 10.0, 10.1, 10.3, 10.4, 10.6,
    10.7, 10.9, 11.0, 11.2, 11.3, 11.4, 11.6, 11.7, 11.8, 12.0,
    12.1, 12.2, 12.4, 12.5, 12.6, 12.8, 12.9, 13.0, 13.2, 13.3,
    13.4, 13.6, 13.7, 13.8, 14.0, 14.1, 14.2, 14.4, 14.5, 14.7, 14.8,
  ];
  static const List<double> weightBoys15th = [
    2.9, 3.8, 4.9, 5.6, 6.2, 6.7, 7.1, 7.4, 7.7, 8.0,
    8.2, 8.4, 8.6, 8.8, 9.0, 9.2, 9.4, 9.6, 9.8, 9.9,
    10.1, 10.3, 10.5, 10.6, 10.8, 11.0, 11.2, 11.3, 11.5, 11.7,
    11.8, 12.0, 12.1, 12.3, 12.4, 12.6, 12.7, 12.9, 13.0, 13.2,
    13.3, 13.5, 13.6, 13.8, 13.9, 14.1, 14.2, 14.4, 14.5, 14.7,
    14.8, 15.0, 15.2, 15.3, 15.5, 15.6, 15.8, 15.9, 16.1, 16.3, 16.4,
  ];
  static const List<double> weightBoys50th = [
    3.3, 4.5, 5.6, 6.4, 7.0, 7.5, 7.9, 8.3, 8.6, 8.9,
    9.2, 9.4, 9.6, 9.9, 10.1, 10.3, 10.5, 10.7, 10.9, 11.1,
    11.3, 11.5, 11.8, 12.0, 12.2, 12.4, 12.5, 12.7, 12.9, 13.1,
    13.3, 13.5, 13.7, 13.8, 14.0, 14.2, 14.3, 14.5, 14.7, 14.9,
    15.0, 15.2, 15.4, 15.5, 15.7, 15.9, 16.1, 16.2, 16.4, 16.6,
    16.7, 16.9, 17.1, 17.3, 17.5, 17.7, 17.8, 18.0, 18.2, 18.4, 18.6,
  ];
  static const List<double> weightBoys85th = [
    3.9, 5.1, 6.3, 7.2, 7.9, 8.4, 8.9, 9.3, 9.6, 10.0,
    10.3, 10.5, 10.8, 11.0, 11.3, 11.5, 11.7, 12.0, 12.2, 12.4,
    12.6, 12.9, 13.1, 13.3, 13.6, 13.8, 14.0, 14.2, 14.4, 14.7,
    14.9, 15.1, 15.3, 15.5, 15.7, 16.0, 16.2, 16.4, 16.6, 16.8,
    17.0, 17.2, 17.4, 17.6, 17.9, 18.1, 18.3, 18.5, 18.7, 18.9,
    19.1, 19.4, 19.6, 19.8, 20.0, 20.3, 20.5, 20.7, 20.9, 21.2, 21.4,
  ];
  static const List<double> weightBoys97th = [
    4.4, 5.8, 7.1, 8.0, 8.8, 9.3, 9.8, 10.3, 10.7, 11.0,
    11.4, 11.6, 11.9, 12.2, 12.4, 12.7, 12.9, 13.2, 13.4, 13.7,
    13.9, 14.2, 14.4, 14.7, 14.9, 15.2, 15.4, 15.7, 15.9, 16.2,
    16.4, 16.7, 16.9, 17.1, 17.4, 17.6, 17.9, 18.1, 18.4, 18.6,
    18.9, 19.1, 19.4, 19.6, 19.9, 20.1, 20.4, 20.6, 20.9, 21.1,
    21.4, 21.7, 21.9, 22.2, 22.5, 22.7, 23.0, 23.3, 23.5, 23.8, 24.1,
  ];

  // Weight-for-age GIRLS (kg) - months 0 to 60
  static const List<double> weightGirls3rd = [
    2.4, 3.2, 4.0, 4.6, 5.1, 5.5, 5.8, 6.1, 6.3, 6.6,
    6.8, 7.0, 7.1, 7.3, 7.5, 7.7, 7.8, 8.0, 8.2, 8.3,
    8.5, 8.7, 8.9, 9.0, 9.2, 9.4, 9.5, 9.7, 9.9, 10.0,
    10.2, 10.3, 10.5, 10.6, 10.8, 10.9, 11.1, 11.2, 11.4, 11.5,
    11.7, 11.8, 12.0, 12.1, 12.3, 12.4, 12.6, 12.7, 12.9, 13.0,
    13.2, 13.3, 13.5, 13.6, 13.8, 13.9, 14.1, 14.2, 14.4, 14.5, 14.7,
  ];
  static const List<double> weightGirls15th = [
    2.8, 3.6, 4.5, 5.2, 5.7, 6.1, 6.5, 6.7, 7.0, 7.3,
    7.5, 7.7, 7.9, 8.1, 8.3, 8.5, 8.7, 8.9, 9.1, 9.2,
    9.4, 9.6, 9.8, 10.0, 10.2, 10.3, 10.5, 10.7, 10.9, 11.1,
    11.2, 11.4, 11.6, 11.7, 11.9, 12.1, 12.2, 12.4, 12.6, 12.7,
    12.9, 13.1, 13.2, 13.4, 13.6, 13.7, 13.9, 14.1, 14.2, 14.4,
    14.6, 14.7, 14.9, 15.1, 15.2, 15.4, 15.6, 15.7, 15.9, 16.1, 16.2,
  ];
  static const List<double> weightGirls50th = [
    3.2, 4.2, 5.1, 5.8, 6.4, 6.9, 7.3, 7.6, 7.9, 8.2,
    8.5, 8.7, 8.9, 9.2, 9.4, 9.6, 9.8, 10.0, 10.2, 10.4,
    10.6, 10.9, 11.1, 11.3, 11.5, 11.7, 11.9, 12.1, 12.3, 12.5,
    12.7, 12.9, 13.1, 13.3, 13.5, 13.7, 13.9, 14.1, 14.3, 14.5,
    14.7, 14.9, 15.1, 15.3, 15.5, 15.7, 15.9, 16.1, 16.3, 16.5,
    16.7, 16.9, 17.1, 17.3, 17.5, 17.7, 17.9, 18.2, 18.4, 18.6, 18.8,
  ];
  static const List<double> weightGirls85th = [
    3.7, 4.8, 5.9, 6.6, 7.3, 7.8, 8.2, 8.6, 9.0, 9.3,
    9.6, 9.9, 10.1, 10.4, 10.6, 10.9, 11.1, 11.4, 11.6, 11.8,
    12.1, 12.3, 12.5, 12.8, 13.0, 13.3, 13.5, 13.7, 14.0, 14.2,
    14.4, 14.7, 14.9, 15.1, 15.4, 15.6, 15.8, 16.1, 16.3, 16.5,
    16.8, 17.0, 17.3, 17.5, 17.7, 18.0, 18.2, 18.5, 18.7, 19.0,
    19.2, 19.4, 19.7, 19.9, 20.2, 20.4, 20.7, 20.9, 21.2, 21.4, 21.7,
  ];
  static const List<double> weightGirls97th = [
    4.2, 5.5, 6.6, 7.5, 8.2, 8.8, 9.3, 9.8, 10.2, 10.5,
    10.9, 11.2, 11.5, 11.8, 12.1, 12.4, 12.6, 12.9, 13.2, 13.5,
    13.7, 14.0, 14.3, 14.6, 14.8, 15.1, 15.4, 15.7, 15.9, 16.2,
    16.5, 16.8, 17.0, 17.3, 17.6, 17.9, 18.1, 18.4, 18.7, 19.0,
    19.2, 19.5, 19.8, 20.1, 20.4, 20.6, 20.9, 21.2, 21.5, 21.8,
    22.1, 22.4, 22.7, 22.9, 23.2, 23.5, 23.8, 24.1, 24.4, 24.7, 25.0,
  ];

  // Height-for-age BOYS (cm) - months 0 to 60
  static const List<double> heightBoys3rd = [
    46.3, 51.1, 54.7, 57.6, 60.0, 62.0, 63.8, 65.5, 67.0, 68.4,
    69.7, 71.0, 72.2, 73.3, 74.4, 75.5, 76.5, 77.5, 78.4, 79.4,
    80.3, 81.1, 82.0, 82.8, 83.6, 84.6, 85.5, 86.3, 87.1, 87.9,
    88.7, 89.4, 90.1, 90.8, 91.5, 92.2, 92.9, 93.5, 94.1, 94.8,
    95.4, 96.0, 96.6, 97.2, 97.7, 98.3, 98.9, 99.4, 100.0, 100.5,
    101.1, 101.6, 102.2, 102.7, 103.2, 103.7, 104.3, 104.8, 105.3, 105.8, 106.3,
  ];
  static const List<double> heightBoys50th = [
    49.9, 54.7, 58.4, 61.4, 63.9, 65.9, 67.6, 69.2, 70.6, 72.0,
    73.3, 74.5, 75.7, 76.9, 78.0, 79.1, 80.2, 81.2, 82.3, 83.2,
    84.2, 85.1, 86.0, 86.9, 87.8, 88.8, 89.6, 90.4, 91.2, 92.0,
    92.7, 93.5, 94.2, 94.9, 95.6, 96.3, 97.0, 97.7, 98.4, 99.1,
    99.7, 100.4, 101.0, 101.7, 102.3, 102.9, 103.5, 104.1, 104.7, 105.3,
    105.9, 106.5, 107.1, 107.7, 108.2, 108.8, 109.4, 110.0, 110.5, 111.1, 111.7,
  ];
  static const List<double> heightBoys97th = [
    53.4, 58.4, 62.2, 65.3, 67.8, 69.9, 71.6, 73.0, 74.4, 75.8,
    77.1, 78.3, 79.5, 80.7, 81.8, 82.9, 84.0, 85.1, 86.1, 87.1,
    88.1, 89.0, 90.0, 91.0, 91.9, 93.0, 93.8, 94.7, 95.5, 96.3,
    97.0, 97.8, 98.5, 99.3, 100.0, 100.7, 101.4, 102.1, 102.8, 103.5,
    104.2, 104.9, 105.6, 106.2, 106.9, 107.5, 108.2, 108.8, 109.5, 110.1,
    110.7, 111.4, 112.0, 112.6, 113.2, 113.9, 114.5, 115.1, 115.7, 116.3, 116.9,
  ];

  // Height-for-age GIRLS (cm) - months 0 to 60
  static const List<double> heightGirls3rd = [
    45.6, 50.0, 53.2, 55.8, 58.0, 59.9, 61.5, 63.0, 64.4, 65.7,
    67.0, 68.2, 69.4, 70.5, 71.6, 72.6, 73.7, 74.7, 75.6, 76.5,
    77.5, 78.4, 79.3, 80.2, 81.0, 82.0, 82.8, 83.5, 84.3, 85.0,
    85.7, 86.4, 87.0, 87.7, 88.4, 89.0, 89.6, 90.3, 90.9, 91.5,
    92.1, 92.7, 93.3, 93.9, 94.5, 95.1, 95.6, 96.2, 96.8, 97.3,
    97.9, 98.5, 99.0, 99.6, 100.1, 100.7, 101.2, 101.8, 102.3, 102.8, 103.4,
  ];
  static const List<double> heightGirls50th = [
    49.1, 53.7, 57.1, 59.8, 62.1, 64.0, 65.7, 67.3, 68.7, 70.1,
    71.5, 72.8, 74.0, 75.2, 76.4, 77.5, 78.6, 79.7, 80.7, 81.7,
    82.7, 83.7, 84.6, 85.5, 86.5, 87.5, 88.3, 89.1, 89.9, 90.7,
    91.4, 92.1, 92.9, 93.6, 94.3, 95.0, 95.6, 96.3, 97.0, 97.6,
    98.3, 98.9, 99.6, 100.2, 100.8, 101.5, 102.1, 102.7, 103.3, 103.9,
    104.5, 105.1, 105.8, 106.4, 107.0, 107.6, 108.2, 108.8, 109.3, 109.9, 110.5,
  ];
  static const List<double> heightGirls97th = [
    52.7, 57.4, 60.9, 63.8, 66.2, 68.2, 69.8, 71.4, 72.8, 74.2,
    75.6, 76.9, 78.2, 79.4, 80.6, 81.7, 82.9, 84.0, 85.1, 86.1,
    87.2, 88.2, 89.2, 90.2, 91.2, 92.2, 93.1, 93.9, 94.7, 95.5,
    96.3, 97.1, 97.9, 98.6, 99.4, 100.1, 100.8, 101.6, 102.3, 103.0,
    103.7, 104.4, 105.1, 105.8, 106.5, 107.2, 107.8, 108.5, 109.2, 109.8,
    110.5, 111.2, 111.8, 112.5, 113.1, 113.8, 114.4, 115.0, 115.7, 116.3, 117.0,
  ];
}

/// The type of growth chart to display.
enum GrowthChartType {
  weight,
  height,
}

/// Interactive WHO growth chart widget using fl_chart.
class GrowthChart extends StatelessWidget {
  const GrowthChart({
    required this.chartType,
    required this.isMale,
    super.key,
    this.patientAgeMonths,
    this.patientValue,
  });

  final GrowthChartType chartType;
  final bool isMale;
  final double? patientAgeMonths;
  final double? patientValue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 300,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 60,
          minY: _getMinY(),
          maxY: _getMaxY(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: _getInterval(),
            verticalInterval: 12,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: 0.5,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                chartType == GrowthChartType.weight ? 'kg' : 'cm',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: _getInterval(),
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                'Meses',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 12,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
            ),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          lineBarsData: _getLineBars(colorScheme),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} ${chartType == GrowthChartType.weight ? 'kg' : 'cm'}',
                  TextStyle(
                    color: spot.bar.color ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  double _getMinY() {
    if (chartType == GrowthChartType.weight) return 0;
    return 40;
  }

  double _getMaxY() {
    if (chartType == GrowthChartType.weight) return 30;
    return 120;
  }

  double _getInterval() {
    if (chartType == GrowthChartType.weight) return 5;
    return 10;
  }

  List<LineChartBarData> _getLineBars(ColorScheme colorScheme) {
    final lines = <LineChartBarData>[];

    final percentileData = _getPercentileData();

    // 3rd percentile (abnormal zone boundary)
    lines.add(_createLine(
      percentileData['p3']!,
      colorScheme.error.withValues(alpha: 0.5),
      'P3',
    ));

    // 15th percentile (borderline zone)
    lines.add(_createLine(
      percentileData['p15']!,
      Colors.orange.withValues(alpha: 0.5),
      'P15',
    ));

    // 50th percentile (normal)
    lines.add(_createLine(
      percentileData['p50']!,
      colorScheme.secondary,
      'P50',
      strokeWidth: 2.5,
    ));

    // 85th percentile (borderline zone)
    lines.add(_createLine(
      percentileData['p85']!,
      Colors.orange.withValues(alpha: 0.5),
      'P85',
    ));

    // 97th percentile (abnormal zone boundary)
    lines.add(_createLine(
      percentileData['p97']!,
      colorScheme.error.withValues(alpha: 0.5),
      'P97',
    ));

    // Patient data point
    if (patientAgeMonths != null &&
        patientValue != null &&
        patientAgeMonths! >= 0 &&
        patientAgeMonths! <= 60) {
      lines.add(LineChartBarData(
        spots: [FlSpot(patientAgeMonths!, patientValue!)],
        isCurved: false,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) =>
              FlDotCirclePainter(
            radius: 6,
            color: colorScheme.primary,
            strokeWidth: 2,
            strokeColor: colorScheme.onPrimary,
          ),
        ),
        barWidth: 0,
        color: Colors.transparent,
      ));
    }

    return lines;
  }

  LineChartBarData _createLine(
    List<double> data,
    Color color,
    String label, {
    double strokeWidth = 1.5,
  }) {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: strokeWidth,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Map<String, List<double>> _getPercentileData() {
    if (chartType == GrowthChartType.weight) {
      if (isMale) {
        return {
          'p3': _WhoData.weightBoys3rd,
          'p15': _WhoData.weightBoys15th,
          'p50': _WhoData.weightBoys50th,
          'p85': _WhoData.weightBoys85th,
          'p97': _WhoData.weightBoys97th,
        };
      } else {
        return {
          'p3': _WhoData.weightGirls3rd,
          'p15': _WhoData.weightGirls15th,
          'p50': _WhoData.weightGirls50th,
          'p85': _WhoData.weightGirls85th,
          'p97': _WhoData.weightGirls97th,
        };
      }
    } else {
      if (isMale) {
        return {
          'p3': _WhoData.heightBoys3rd,
          'p15': _WhoData.heightBoys3rd, // Approximate: use 3rd for 15th
          'p50': _WhoData.heightBoys50th,
          'p85': _WhoData.heightBoys97th, // Approximate: use 97th for 85th
          'p97': _WhoData.heightBoys97th,
        };
      } else {
        return {
          'p3': _WhoData.heightGirls3rd,
          'p15': _WhoData.heightGirls3rd,
          'p50': _WhoData.heightGirls50th,
          'p85': _WhoData.heightGirls97th,
          'p97': _WhoData.heightGirls97th,
        };
      }
    }
  }
}

/// Chart legend widget.
class GrowthChartLegend extends StatelessWidget {
  const GrowthChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: [
          _legendItem(context, 'P3/P97', colorScheme.error.withValues(alpha: 0.5)),
          _legendItem(context, 'P15/P85', Colors.orange.withValues(alpha: 0.5)),
          _legendItem(context, 'P50', colorScheme.secondary),
          _legendItem(context, 'Paciente', colorScheme.primary),
        ],
      ),
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
