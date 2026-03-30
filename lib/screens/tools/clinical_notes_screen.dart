import 'package:easypedv3/models/clinical_note.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Temporary shift notepad for clinical notes with auto-delete after 24 hours.
class ClinicalNotesScreen extends ConsumerStatefulWidget {
  const ClinicalNotesScreen({super.key});

  @override
  ConsumerState<ClinicalNotesScreen> createState() =>
      _ClinicalNotesScreenState();
}

class _ClinicalNotesScreenState extends ConsumerState<ClinicalNotesScreen> {
  final _textController = TextEditingController();
  List<ClinicalNote> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _loadNotes() {
    final repo = ref.read(notesRepositoryProvider);
    setState(() {
      _notes = repo.getNotes();
    });
  }

  Future<void> _addNote() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final repo = ref.read(notesRepositoryProvider);
    await repo.addNote(text);
    _textController.clear();
    _loadNotes();
  }

  Future<void> _deleteNote(String id) async {
    final repo = ref.read(notesRepositoryProvider);
    await repo.deleteNote(id);
    _loadNotes();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String _timeRemaining(DateTime? createdAt) {
    if (createdAt == null) return '';
    final expiry = createdAt.add(const Duration(hours: 24));
    final remaining = expiry.difference(DateTime.now());
    if (remaining.isNegative) return 'Expirada';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    return 'Expira em ${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notas Clínicas'),
      ),
      body: Column(
        children: [
          // Warning banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: colorScheme.error.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'As notas são temporárias e serão eliminadas automaticamente '
                    'após 24 horas. Não guarde identificadores de pacientes. '
                    'Os dados são armazenados apenas localmente.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                  ),
                ),
              ],
            ),
          ),
          // Input area
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escrever nota clínica...',
                    ),
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addNote,
                  tooltip: 'Adicionar nota',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Notes list
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note_alt_outlined,
                            size: 64,
                            color: colorScheme.onSurface.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Sem notas clínicas',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return Dismissible(
                        key: Key(note.id ?? index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: colorScheme.error,
                          child: Icon(Icons.delete,
                              color: colorScheme.onError),
                        ),
                        onDismissed: (_) {
                          if (note.id != null) _deleteNote(note.id!);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.text ?? '',
                                  style:
                                      Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDate(note.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    Text(
                                      _timeRemaining(note.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.error,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
