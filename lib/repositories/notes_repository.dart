import 'dart:convert';

import 'package:easypedv3/models/clinical_note.dart';
import 'package:hive/hive.dart';

/// Repository for clinical notes stored locally in Hive.
/// Notes are never sent to the server and are auto-deleted after 24 hours.
class NotesRepository {
  NotesRepository();

  static const String _boxName = 'clinical_notes';

  Box get _box => Hive.box(_boxName);

  /// Returns all non-expired notes, removing expired ones in the process.
  List<ClinicalNote> getNotes() {
    _purgeExpired();
    final notes = <ClinicalNote>[];
    for (final key in _box.keys) {
      try {
        final json =
            jsonDecode(_box.get(key) as String) as Map<String, dynamic>;
        notes.add(ClinicalNote.fromJson(json));
      } catch (_) {
        // Skip malformed entries
      }
    }
    // Sort by creation date descending (newest first).
    notes.sort((a, b) =>
        (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    return notes;
  }

  /// Adds a new clinical note.
  Future<ClinicalNote> addNote(String text) async {
    final note = ClinicalNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );
    await _box.put(note.id, jsonEncode(note.toJson()));
    return note;
  }

  /// Deletes a note by its ID.
  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  /// Removes all notes that have exceeded their 24-hour lifetime.
  void _purgeExpired() {
    final keysToRemove = <dynamic>[];
    for (final key in _box.keys) {
      try {
        final json =
            jsonDecode(_box.get(key) as String) as Map<String, dynamic>;
        final note = ClinicalNote.fromJson(json);
        if (note.isExpired) {
          keysToRemove.add(key);
        }
      } catch (_) {
        keysToRemove.add(key);
      }
    }
    if (keysToRemove.isNotEmpty) {
      _box.deleteAll(keysToRemove);
    }
  }

  /// Deletes all notes.
  Future<void> clearAll() async {
    await _box.clear();
  }
}
