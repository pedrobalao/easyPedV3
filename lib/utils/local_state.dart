/// Deprecated: Use [showedDisclaimerProvider] from providers.dart instead.
/// Kept for backward compatibility during migration.
class LocalState {

  factory LocalState() {
    return _instance;
  }

  LocalState._internal() {
    // initialization logic
    showedDisclaimerMessage = false;
  }
  static final LocalState _instance = LocalState._internal();

  bool showedDisclaimerMessage = false;
}
