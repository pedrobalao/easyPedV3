import 'package:flutter/material.dart';

/// Fluid resuscitation calculator: bolus volumes (20 mL/kg) and
/// maintenance rates using the 4-2-1 (Holliday–Segar) rule.
class FluidResuscitationScreen extends StatefulWidget {
  const FluidResuscitationScreen({super.key});

  @override
  State<FluidResuscitationScreen> createState() =>
      _FluidResuscitationScreenState();
}

class _FluidResuscitationScreenState extends State<FluidResuscitationScreen> {
  final _controller = TextEditingController();
  double? _weight;

  // Bolus: 20 mL/kg isotonic crystalloid.
  double get _bolusVolume => (_weight ?? 0) * 20;

  // Maintenance rate (Holliday–Segar / 4-2-1 rule):
  //   First 10 kg  → 4 mL/kg/h
  //   Next  10 kg  → 2 mL/kg/h
  //   Each kg > 20 → 1 mL/kg/h
  double get _maintenanceRate {
    final w = _weight ?? 0;
    if (w <= 0) return 0;
    if (w <= 10) return w * 4;
    if (w <= 20) return 40 + (w - 10) * 2;
    return 40 + 20 + (w - 20) * 1;
  }

  double get _dailyMaintenance => _maintenanceRate * 24;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onWeightChanged(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    setState(() {
      _weight = (parsed != null && parsed > 0) ? parsed : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fluidoterapia'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Peso do doente',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Peso (kg)',
                      suffixText: 'kg',
                      fillColor: colorScheme.primary,
                    ),
                    onChanged: _onWeightChanged,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final v = double.tryParse(value.replaceAll(',', '.'));
                      if (v == null || v <= 0) {
                        return 'Introduza um peso válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_weight != null) ...[
            _buildResultSection(context, colorScheme),
            const SizedBox(height: 12),
            _buildFormulaCard(context, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildResultSection(BuildContext context, ColorScheme cs) {
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
            child: Column(
              children: [
                _resultRow(
                  context,
                  icon: Icons.water_drop,
                  label: 'Bólus (20 mL/kg)',
                  value: '${_bolusVolume.toStringAsFixed(1)} mL',
                ),
                const Divider(height: 24),
                _resultRow(
                  context,
                  icon: Icons.speed,
                  label: 'Manutenção (regra 4-2-1)',
                  value: '${_maintenanceRate.toStringAsFixed(1)} mL/h',
                ),
                const SizedBox(height: 8),
                _resultRow(
                  context,
                  icon: Icons.schedule,
                  label: 'Manutenção diária (24 h)',
                  value: '${_dailyMaintenance.toStringAsFixed(0)} mL/dia',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaCard(BuildContext context, ColorScheme cs) {
    return Card(
      color: cs.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: cs.onTertiaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Fórmulas utilizadas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cs.onTertiaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Bólus de ressuscitação:\n'
              '  20 mL/kg de cristalóide isotónico\n\n'
              'Manutenção (Holliday–Segar / 4-2-1):\n'
              '  Primeiros 10 kg → 4 mL/kg/h\n'
              '  10–20 kg → 2 mL/kg/h\n'
              '  > 20 kg → 1 mL/kg/h',
              style: TextStyle(
                color: cs.onTertiaryContainer,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
