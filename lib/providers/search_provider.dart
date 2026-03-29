import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Hive box name for persisting recent searches.
const _boxName = 'recent_searches';

/// Key inside the box that stores the list.
const _key = 'queries';

/// Maximum number of recent searches to retain.
const _maxEntries = 10;

/// Notifier that persists recent search queries in Hive (last [_maxEntries]).
class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super(_readFromHive());

  /// Read the stored list from Hive, returning an empty list on failure.
  static List<String> _readFromHive() {
    try {
      final box = Hive.box(_boxName);
      final stored = box.get(_key, defaultValue: <dynamic>[]);
      return List<String>.from(stored as List);
    } catch (_) {
      return <String>[];
    }
  }

  /// Add a query to the front of the list (most recent first).
  /// Duplicates are moved to the front. List is capped at [_maxEntries].
  Future<void> addSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final updated = [
      trimmed,
      ...state.where((q) => q != trimmed),
    ].take(_maxEntries).toList();

    state = updated;
    await _persist(updated);
  }

  /// Remove all recent searches.
  Future<void> clearAll() async {
    state = <String>[];
    await _persist(<String>[]);
  }

  Future<void> _persist(List<String> data) async {
    try {
      final box = Hive.box(_boxName);
      await box.put(_key, data);
    } catch (_) {
      // Hive not initialized — ignore
    }
  }
}

/// Provider for [RecentSearchesNotifier].
final recentSearchesNotifierProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier();
});
