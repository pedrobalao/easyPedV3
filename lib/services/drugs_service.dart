import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easypedv3/models/congress.dart';
import 'package:easypedv3/models/disease.dart';
import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/models/medical_calculation.dart';
import 'package:easypedv3/models/news.dart';
import 'package:easypedv3/models/percentile.dart';
import 'package:easypedv3/models/surgery_referral.dart';
import 'package:easypedv3/services/api_client.dart';

class DrugService {
  DrugService({Dio? dio}) : _dio = dio ?? createApiClient();

  final Dio _dio;

  // ── Drug helpers ──────────────────────────────────────────────────

  List<Drug> _listDrugFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list.map((x) => Drug.fromJson(x as Map<String, dynamic>)).toList();
  }

  // ── Favourites ────────────────────────────────────────────────────

  Future<List<Drug>> fetchFavourites() async {
    try {
      final response = await _dio.get('/users/me/favourite-drugs');
      return _listDrugFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<bool> fetchIsFavourite(int drugId) async {
    try {
      final response =
          await _dio.get('/users/me/favourite-drugs/$drugId');
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } on DioException {
      return false;
    }
  }

  Future<bool> addFavourite(int drugId) async {
    try {
      final response = await _dio.post(
        '/users/me/favourite-drugs',
        data: {'drugId': drugId},
      );
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } on DioException {
      return false;
    }
  }

  Future<bool> deleteFavourite(int drugId) async {
    try {
      final response =
          await _dio.delete('/users/me/favourite-drugs/$drugId');
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } on DioException {
      return false;
    }
  }

  // ── Drugs ─────────────────────────────────────────────────────────

  Future<Drug> fetchDrug(int drugId) async {
    try {
      final response = await _dio.get('/drugs/$drugId');
      final drug = Drug.fromJson(response.data as Map<String, dynamic>);

      // Check favourite status
      drug.isFavourite = await fetchIsFavourite(drugId);

      return drug;
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<List<Drug>> searchDrug(String searchString) async {
    try {
      final response = await _dio.get(
        '/drugs',
        queryParameters: {'searchtoken': searchString},
      );
      return _listDrugFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Dose calculation ──────────────────────────────────────────────

  List<DoseCalculationResult> _listDoseCalcFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list
        .map((x) => DoseCalculationResult.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<List<DoseCalculationResult>> doseCalculation(
    int drugId,
    Map<dynamic, dynamic> data,
  ) async {
    final calInput = <CalculationInput>[];
    data.forEach((key, value) {
      calInput.add(CalculationInput(variable: key as String?, value: value));
    });

    try {
      final response = await _dio.post(
        '/drugs/$drugId/calculations',
        data: calInput.map((e) => e.toJson()).toList(),
      );
      return _listDoseCalcFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Categories ────────────────────────────────────────────────────

  List<DrugCategory> _listCategoriesFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list
        .map((x) => DrugCategory.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<List<DrugCategory>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      return _listCategoriesFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Sub-Categories ────────────────────────────────────────────────

  List<DrugSubCategory> _listSubCategoriesFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list
        .map((x) => DrugSubCategory.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<List<DrugSubCategory>> fetchSubCategories(int categoryId) async {
    try {
      final response =
          await _dio.get('/categories/$categoryId/sub-categories');
      return _listSubCategoriesFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<List<Drug>> fetchDrugsBySubCategory(
    int categoryId,
    int subCategoryId,
  ) async {
    try {
      final response = await _dio.get(
        '/categories/$categoryId/sub-categories/$subCategoryId/drugs',
      );
      return _listDrugFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Surgery referral ──────────────────────────────────────────────

  List<SurgeryReferral> _listSurgeryReferralFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list
        .map((x) => SurgeryReferral.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<List<SurgeryReferral>> fetchSurgeriesReferral() async {
    try {
      final response = await _dio.get('/surgeries-referral');
      return _listSurgeryReferralFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Diseases ──────────────────────────────────────────────────────

  List<Disease> _listDiseaseFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list
        .map((x) => Disease.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<List<Disease>> fetchDiseases() async {
    try {
      final response = await _dio.get('/diseases');
      return _listDiseaseFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<List<Disease>> searchDiseases(String searchStr) async {
    try {
      final response = await _dio.get(
        '/diseases/',
        queryParameters: {'search': searchStr},
      );
      return _listDiseaseFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<Disease> fetchDisease(int id) async {
    try {
      final response = await _dio.get('/diseases/$id');
      return Disease.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Medical calculations ──────────────────────────────────────────

  List<MedicalCalculation> _listMedCalcFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list
        .map((x) => MedicalCalculation.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<MedicalCalculation> fetchMedicalCalculation(int id) async {
    try {
      final response = await _dio.get('/medical-calculations/$id');
      return MedicalCalculation.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<List<MedicalCalculation>> fetchMedicalCalculations() async {
    try {
      final response = await _dio.get('/medical-calculations');
      return _listMedCalcFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<CalculationOutput> executeMedicalCalculation(
    int id,
    List<CalculationInput> data,
  ) async {
    try {
      final response = await _dio.post(
        '/medical-calculations/$id/calculations',
        data: data.map((e) => e.toJson()).toList(),
      );
      return CalculationOutput.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Percentiles ───────────────────────────────────────────────────

  Future<PercentileOutput> executeWeightPercentile(
    PercentileInput data,
  ) async {
    try {
      final response = await _dio.post(
        '/percentiles/weight',
        data: data.toJson(),
      );
      return PercentileOutput.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<PercentileOutput> executeLengthPercentile(
    PercentileInput data,
  ) async {
    try {
      final response = await _dio.post(
        '/percentiles/length',
        data: data.toJson(),
      );
      return PercentileOutput.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  Future<BMIOutput> executeBMIPercentile(BMIInput data) async {
    try {
      final response = await _dio.post(
        '/percentiles/bmi',
        data: data.toJson(),
      );
      return BMIOutput.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  // ── Congresses & News ─────────────────────────────────────────────

  List<Congress> _listCongressesFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list
        .map((x) => Congress.fromJson(x as Map<String, dynamic>))
        .toList();
  }

  Future<List<Congress>> fetchCongresses() async {
    try {
      final response = await _dio.get('/congresses');
      return _listCongressesFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }

  List<News> _listNewsFromJson(dynamic data) {
    final list = data is String ? json.decode(data) as List : data as List;
    return list.map((x) => News.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<List<News>> fetchNews() async {
    try {
      final response = await _dio.get('/news');
      return _listNewsFromJson(response.data);
    } on DioException catch (e) {
      throwTypedException(e);
    }
  }
}
