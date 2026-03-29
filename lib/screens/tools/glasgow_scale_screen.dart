import 'package:flutter/material.dart';

/// Interactive Pediatric Glasgow Coma Scale calculator.
class GlasgowScaleScreen extends StatefulWidget {
  const GlasgowScaleScreen({super.key});

  @override
  State<GlasgowScaleScreen> createState() => _GlasgowScaleScreenState();
}

class _GlasgowScaleScreenState extends State<GlasgowScaleScreen> {
  int _eye = 4;
  int _verbal = 5;
  int _motor = 6;

  int get _total => _eye + _verbal + _motor;

  static const _eyeOptions = <int, String>{
    4: 'Espontânea',
    3: 'À voz',
    2: 'À dor',
    1: 'Nenhuma',
  };

  static const _verbalOptions = <int, String>{
    5: 'Orientada / balbucia',
    4: 'Confusa / choro irritado',
    3: 'Palavras inapropriadas / choro à dor',
    2: 'Sons incompreensíveis / gemido à dor',
    1: 'Nenhuma',
  };

  static const _motorOptions = <int, String>{
    6: 'Obedece ordens / mov. espontâneos',
    5: 'Localiza dor',
    4: 'Retirada inespecífica',
    3: 'Flexão anormal (decorticação)',
    2: 'Extensão anormal (descerebração)',
    1: 'Nenhuma',
  };

  String get _interpretation {
    if (_total >= 13) return 'Traumatismo ligeiro';
    if (_total >= 9) return 'Traumatismo moderado';
    return 'Traumatismo grave';
  }

  Color _interpretationColor(ColorScheme cs) {
    if (_total >= 13) return Colors.green;
    if (_total >= 9) return Colors.orange;
    return cs.error;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Escala de Glasgow'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSection(
            context,
            title: 'Abertura Ocular',
            icon: Icons.visibility,
            options: _eyeOptions,
            selected: _eye,
            onChanged: (v) => setState(() => _eye = v),
          ),
          const SizedBox(height: 12),
          _buildSection(
            context,
            title: 'Resposta Verbal',
            icon: Icons.record_voice_over,
            options: _verbalOptions,
            selected: _verbal,
            onChanged: (v) => setState(() => _verbal = v),
          ),
          const SizedBox(height: 12),
          _buildSection(
            context,
            title: 'Resposta Motora',
            icon: Icons.accessibility_new,
            options: _motorOptions,
            selected: _motor,
            onChanged: (v) => setState(() => _motor = v),
          ),
          const SizedBox(height: 20),
          _buildResultCard(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Map<int, String> options,
    required int selected,
    required ValueChanged<int> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
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
                Icon(icon, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          ...options.entries.map(
            (e) => RadioListTile<int>(
              title: Text('${e.key} – ${e.value}'),
              value: e.key,
              groupValue: selected,
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: cs.onSecondary,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '$_total / 15',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _interpretationColor(cs).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _interpretation,
                    style: TextStyle(
                      color: _interpretationColor(cs),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Olhos: $_eye · Verbal: $_verbal · Motor: $_motor',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
