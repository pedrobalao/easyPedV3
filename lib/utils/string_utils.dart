class StringUtils {
  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }

    try {
      double.parse(s);
      return true;
    } on FormatException {
      return false;
    }
  }
}
