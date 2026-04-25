import 'package:flutter/material.dart';

/// APGAR score calculator with scoring at 1 and 5 minutes.
class ApgarScoreScreen extends StatefulWidget {
  const ApgarScoreScreen({super.key});

  @override
  State<ApgarScoreScreen> createState() => _ApgarScoreScreenState();
}

class _ApgarScoreScreenState extends State<ApgarScoreScreen> {
  /// Scores for 1-minute evaluation (index 0–4 maps to each criterion).
  final List<int> _scores1 = List.filled(5, 0);

  /// Scores for 5-minute evaluation.
  final List<int> _scores5 = List.filled(5, 0);

  static const _criteria = <_ApgarCriterion>[
    _ApgarCriterion(
      name: 'Aparência (cor)',
      icon: Icons.palette,
      labels: ['Cianose / palidez', 'Acrocianose', 'Rosado'],
    ),
    _ApgarCriterion(
      name: 'Pulso (FC)',
      icon: Icons.favorite,
      labels: ['Ausente', '< 100 bpm', '≥ 100 bpm'],
    ),
    _ApgarCriterion(
      name: 'Gesticulação (irritabilidade reflexa)',
      icon: Icons.sentiment_satisfied,
      labels: ['Sem resposta', 'Careta', 'Choro vigoroso'],
    ),
    _ApgarCriterion(
      name: 'Atividade (tónus muscular)',
      icon: Icons.fitness_center,
      labels: ['Flácido', 'Alguma flexão', 'Mov. ativos'],
    ),
    _ApgarCriterion(
      name: 'Respiração',
      icon: Icons.air,
      labels: ['Ausente', 'Irregular / fraca', 'Choro forte'],
    ),
  ];

  int get _total1 => _scores1.reduce((a, b) => a + b);
  int get _total5 => _scores5.reduce((a, b) => a + b);

  String _interpretScore(int score) {
    if (score >= 7) return 'Normal';
    if (score >= 4) return 'Depressão moderada';
    return 'Depressão grave';
  }

  Color _scoreColor(int score) {
    if (score >= 7) return Colors.green;
    if (score >= 4) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Score de APGAR'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Avalie cada critério com 0, 1 ou 2 pontos ao '
                '1.º e ao 5.º minuto de vida.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ..._criteria.asMap().entries.map(
                (entry) => _buildCriterionCard(context, entry.key, entry.value),
              ),
          const SizedBox(height: 16),
          _buildResultCard(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildCriterionCard(
    BuildContext context,
    int index,
    _ApgarCriterion criterion,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(criterion.icon, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    criterion.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    const SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('1 min',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('5 min',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          )),
                    ),
                  ],
                ),
                for (int score = 0; score < 3; score++)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('$score – ${criterion.labels[score]}'),
                      ),
                      Radio<int>(
                        value: score,
                        groupValue: _scores1[index],
                        onChanged: (v) =>
                            setState(() => _scores1[index] = v ?? 0),
                      ),
                      Radio<int>(
                        value: score,
                        groupValue: _scores5[index],
                        onChanged: (v) =>
                            setState(() => _scores5[index] = v ?? 0),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, ColorScheme cs) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            tileColor: cs.secondary,
            title: Text(
              'Resultado',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: cs.onSecondary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _scoreColumn(context, '1 minuto', _total1)),
                Container(width: 1, height: 80, color: cs.outlineVariant),
                Expanded(child: _scoreColumn(context, '5 minutos', _total5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreColumn(BuildContext context, String label, int score) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Text(
          '$score / 10',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _scoreColor(score).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _interpretScore(score),
            style: TextStyle(
              color: _scoreColor(score),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _ApgarCriterion {
  const _ApgarCriterion({
    required this.name,
    required this.icon,
    required this.labels,
  });

  final String name;
  final IconData icon;
  final List<String> labels;
}
