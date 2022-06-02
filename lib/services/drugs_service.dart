import 'dart:convert';

import 'package:easypedv3/models/drug.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DrugService {
  List<Drug> listDrugFromJson(String str) =>
      List<Drug>.from(json.decode(str).map((x) => Drug.fromJson(x)));

  final String? apiBaseUrl = dotenv.env['API_BASE_URL'];

  Future<Drug> fetchDrug(int drugId, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(Uri.parse('$apiBaseUrl/drugs/$drugId'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String resp = response.body.replaceFirst("{\"drug\":", "");
      resp = resp.replaceRange(resp.length - 1, resp.length, "");

      var drug = Drug.fromJson(jsonDecode(resp));

      return drug;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to search Drug');
    }
  }

  Future<List<Drug>> searchDrug(String searchString, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(
        Uri.parse('$apiBaseUrl/drugs/search?drugname=$searchString'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String resp = response.body.replaceFirst("{\"drugs\":", "");
      resp = resp.replaceRange(resp.length - 1, resp.length, "");

      return listDrugFromJson(resp);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to search Drug');
    }
  }
}
