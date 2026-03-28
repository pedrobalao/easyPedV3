import 'dart:convert';

class MapUtils {
  static String toJSON(Map<dynamic, dynamic> map) {
    final jsonStr = json.encode(map);
    return jsonStr;
  }
}
