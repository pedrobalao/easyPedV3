import 'package:flutter/material.dart';

/// Quick-reference card showing normal vital-sign ranges by age group.
class VitalSignsScreen extends StatelessWidget {
  const VitalSignsScreen({super.key});

  static const _columns = <String>[
    'Idade',
    'FC (bpm)',
    'FR (cpm)',
    'PAS (mmHg)',
    'PAD (mmHg)',
    'Temp (°C)',
  ];

  static const _rows = <List<String>>[
    ['Recém-nascido', '120–160', '30–60', '60–76', '30–45', '36.5–37.5'],
    ['1–12 meses', '100–160', '30–60', '72–104', '37–56', '36.5–37.5'],
    ['1–3 anos', '90–150', '24–40', '86–106', '42–63', '36.5–37.5'],
    ['4–5 anos', '80–140', '22–34', '89–112', '46–72', '36.5–37.5'],
    ['6–12 anos', '70–120', '18–30', '97–120', '57–80', '36.5–37.5'],
    ['13–18 anos', '60–100', '12–20', '110–131', '64–83', '36.5–37.5'],
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sinais Vitais por Idade'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valores Normais Pediátricos',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FC – Frequência Cardíaca · FR – Frequência Respiratória\n'
                      'PAS – Pressão Arterial Sistólica · PAD – Pressão Arterial Diastólica',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStatePropertyAll(
                  colorScheme.primaryContainer,
                ),
                columnSpacing: 16,
                columns: _columns
                    .map(
                      (c) => DataColumn(
                        label: Text(
                          c,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                rows: _rows
                    .map(
                      (row) => DataRow(
                        cells: row.map((cell) => DataCell(Text(cell))).toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: colorScheme.onTertiaryContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Os valores são intervalos de referência aproximados. '
                        'Avalie sempre no contexto clínico do doente.',
                        style: TextStyle(
                          color: colorScheme.onTertiaryContainer,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
