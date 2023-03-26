class LocalState {
  static final LocalState _instance = LocalState._internal();

  bool showedDisclaimerMessage = false;

  factory LocalState() {
    return _instance;
  }

  LocalState._internal() {
    // initialization logic
    showedDisclaimerMessage = false;
  }
}
