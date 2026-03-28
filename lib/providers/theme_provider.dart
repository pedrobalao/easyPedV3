import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const _boxName = 'theme_preferences';
const _key = 'theme_mode';

/// Persisted theme-mode provider backed by Hive.
///
/// Possible stored values: `system`, `light`, `dark`.
/// Default is [ThemeMode.system].
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_readFromHive());

  static ThemeMode _readFromHive() {
    final box = Hive.box(_boxName);
    final stored = box.get(_key, defaultValue: 'system') as String;
    return _fromString(stored);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final box = Hive.box(_boxName);
    await box.put(_key, _toString(mode));
  }

  static ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
