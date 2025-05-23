import 'dart:convert';

import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/models/medical_calculation.dart';
import 'package:easypedv3/models/surgery_referral.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/congress.dart';
import '../models/disease.dart';
import '../models/news.dart';
import '../models/percentile.dart';

class DrugService {
  List<Drug> listDrugFromJson(String str) =>
      List<Drug>.from(json.decode(str).map((x) => Drug.fromJson(x)));

  final String? apiBaseUrl = dotenv.env['API_BASE_URL'];

  Future<List<Drug>> fetchFavourites(String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(
        Uri.parse('$apiBaseUrl/users/me/favourite-drugs'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listDrugFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to search Drug');
    }
  }

  Future<bool> fetchIsFavourite(int drugId, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final responseFav = await http.get(
        Uri.parse('$apiBaseUrl/users/me/favourite-drugs/$drugId'),
        headers: requestHeaders);
    if (responseFav.statusCode >= 200 && responseFav.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addFavourite(int drugId, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final responseFav =
        await http.post(Uri.parse('$apiBaseUrl/users/me/favourite-drugs'),
            headers: requestHeaders,
            body: jsonEncode(<String, int>{
              'drugId': drugId,
            }));

    if (responseFav.statusCode >= 200 && responseFav.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteFavourite(int drugId, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final responseFav = await http.delete(
        Uri.parse('$apiBaseUrl/users/me/favourite-drugs/$drugId'),
        headers: requestHeaders);

    if (responseFav.statusCode >= 200 && responseFav.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

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
      var drug = Drug.fromJson(jsonDecode(response.body));

      var responseFav = await http.get(
          Uri.parse('$apiBaseUrl/users/me/favourite-drugs/$drugId'),
          headers: requestHeaders);
      if (responseFav.statusCode >= 200 && responseFav.statusCode < 300) {
        drug.isFavourite = true;
      } else {
        drug.isFavourite = false;
      }

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
        Uri.parse('$apiBaseUrl/drugs?searchtoken=$searchString'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listDrugFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to search Drug');
    }
  }

  List<DoseCalculationResult> listDoseCalculationResultFromJson(String str) =>
      List<DoseCalculationResult>.from(
          json.decode(str).map((x) => DoseCalculationResult.fromJson(x)));

  Future<List<DoseCalculationResult>> doseCalculation(
      int drugId, Map<dynamic, dynamic> data, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    List<CalculationInput> calInput = [];

    data.forEach((key, value) {
      calInput.add(CalculationInput(variable: key, value: value));
    });

    final response = await http.post(
        Uri.parse('$apiBaseUrl/drugs/$drugId/calculations'),
        headers: requestHeaders,
        body: jsonEncode(calInput));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (kDebugMode) {
        for (var element in calInput) {
          print('Variable: ${element.variable} ${element.value}');
        }
        print('response: ${response.body}');
      }

      return listDoseCalculationResultFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to search Drug');
    }
  }

  List<DrugCategory> listCatorgoriesFromJson(String str) =>
      List<DrugCategory>.from(
          json.decode(str).map((x) => DrugCategory.fromJson(x)));

  Future<List<DrugCategory>> fetchCategories(String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(Uri.parse('$apiBaseUrl/categories'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listCatorgoriesFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchCategories');
    }
  }

  List<DrugSubCategory> listDrugSubCategoryFromJson(String str) =>
      List<DrugSubCategory>.from(
          json.decode(str).map((x) => DrugSubCategory.fromJson(x)));

  Future<List<DrugSubCategory>> fetchSubCategories(
      int categoryId, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(
        Uri.parse('$apiBaseUrl/categories/$categoryId/sub-categories'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listDrugSubCategoryFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchCategories');
    }
  }

  Future<List<Drug>> fetchDrugsBySubCategory(
      int categoryId, int subCategoryId, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(
        Uri.parse(
            '$apiBaseUrl/categories/$categoryId/sub-categories/$subCategoryId/drugs'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listDrugFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchCategories');
    }
  }

  List<SurgeryReferral> listSurgeryReferralFromJson(String str) =>
      List<SurgeryReferral>.from(
          json.decode(str).map((x) => SurgeryReferral.fromJson(x)));

  Future<List<SurgeryReferral>> fetchSurgeriesReferral(String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(Uri.parse('$apiBaseUrl/surgeries-referral'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listSurgeryReferralFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchSurgeriesReferral');
    }
  }

  List<Disease> listDiseaseFromJson(String str) =>
      List<Disease>.from(json.decode(str).map((x) => Disease.fromJson(x)));

  Future<List<Disease>> fetchDiseases(String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(Uri.parse('$apiBaseUrl/diseases'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listDiseaseFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchDiseases');
    }
  }

  Future<List<Disease>> searchDiseases(
      String searchStr, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(
        Uri.parse('$apiBaseUrl/diseases/?search=$searchStr'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listDiseaseFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchDiseases');
    }
  }

  Future<Disease> fetchDisease(int id, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(Uri.parse('$apiBaseUrl/diseases/$id'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var disease = Disease.fromJson(jsonDecode(response.body));

      return disease;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to search disease $id');
    }
  }

  //medical calculations
  List<MedicalCalculation> listMedicalCalculationsFromJson(String str) =>
      List<MedicalCalculation>.from(
          json.decode(str).map((x) => MedicalCalculation.fromJson(x)));

  Future<MedicalCalculation> fetchMedicalCalculation(
      int id, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(
        Uri.parse('$apiBaseUrl/medical-calculations/$id'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var ret = MedicalCalculation.fromJson(jsonDecode(response.body));

      return ret;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to search disease $id');
    }
  }

  Future<List<MedicalCalculation>> fetchMedicalCalculations(
      String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(
        Uri.parse('$apiBaseUrl/medical-calculations'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listMedicalCalculationsFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchDiseases');
    }
  }

  Future<CalculationOutput> executeMedicalCalculation(
      int id, List<CalculationInput> data, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.post(
        Uri.parse('$apiBaseUrl/medical-calculations/$id/calculations'),
        headers: requestHeaders,
        body: json.encode(data));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var ret = CalculationOutput.fromJson(jsonDecode(response.body));

      return ret;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to execute calculation of MedicalCalculation $id');
    }
  }

  Future<PercentileOutput> executeWeightPercentile(
      PercentileInput data, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    var body = json.encode(data);
    final response = await http.post(
        Uri.parse('$apiBaseUrl/percentiles/weight'),
        headers: requestHeaders,
        body: body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var ret = PercentileOutput.fromJson(jsonDecode(response.body));

      return ret;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to execute weight percentile');
    }
  }

  Future<PercentileOutput> executeLengthPercentile(
      PercentileInput data, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.post(
        Uri.parse('$apiBaseUrl/percentiles/length'),
        headers: requestHeaders,
        body: json.encode(data));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var ret = PercentileOutput.fromJson(jsonDecode(response.body));

      return ret;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to execute length percentile');
    }
  }

  Future<BMIOutput> executeBMIPercentile(
      BMIInput data, String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.post(Uri.parse('$apiBaseUrl/percentiles/bmi'),
        headers: requestHeaders, body: json.encode(data));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var ret = BMIOutput.fromJson(jsonDecode(response.body));

      return ret;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to execute bmi percentile');
    }
  }

  List<Congress> listCongressesFromJson(String str) =>
      List<Congress>.from(json.decode(str).map((x) => Congress.fromJson(x)));

  Future<List<Congress>> fetchCongresses(String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response = await http.get(Uri.parse('$apiBaseUrl/congresses'),
        headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listCongressesFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchCongresses');
    }
  }

  List<News> listNewsFromJson(String str) =>
      List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

  Future<List<News>> fetchNews(String authToken) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken
    };

    final response =
        await http.get(Uri.parse('$apiBaseUrl/news'), headers: requestHeaders);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listNewsFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetchNews');
    }
  }
}
