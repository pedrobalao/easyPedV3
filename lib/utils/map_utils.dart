import 'dart:convert';

class MapUtils {
  static String toJSON(Map<dynamic, dynamic> map) {
    var jsonStr = json.encode(map);
    return jsonStr;
  }
}
