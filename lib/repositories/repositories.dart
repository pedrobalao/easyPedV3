import 'package:easypedv3/models/congress.dart';
import 'package:easypedv3/models/disease.dart';
import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/models/medical_calculation.dart';
import 'package:easypedv3/models/news.dart';
import 'package:easypedv3/models/percentile.dart';
import 'package:easypedv3/models/surgery_referral.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:hive/hive.dart';

/// Cache entry with TTL support.
class _CacheEntry<T> {
  _CacheEntry(this.data, this.timestamp);
  final T data;
  final DateTime timestamp;

  bool get isExpired =>
      DateTime.now().difference(timestamp) > const Duration(hours: 24);
}

/// Repository for drug-related data. Wraps [DrugService] and provides
/// caching, error mapping, and data transformation.
class DrugRepository {
  DrugRepository({required DrugService drugService})
      : _drugService = drugService;

  final DrugService _drugService;

  // In-memory caches
  _CacheEntry<List<Drug>>? _favouritesCache;
  _CacheEntry<List<DrugCategory>>? _categoriesCache;
  final Map<int, _CacheEntry<Drug>> _drugCache = {};
  final Map<String, _CacheEntry<List<DrugSubCategory>>> _subCategoriesCache =
      {};
  final Map<String, _CacheEntry<List<Drug>>> _drugsBySubCategoryCache = {};

  Future<List<Drug>> getFavourites({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _favouritesCache != null &&
        !_favouritesCache!.isExpired) {
      return _favouritesCache!.data;
    }
    final data = await _drugService.fetchFavourites();
    _favouritesCache = _CacheEntry(data, DateTime.now());
    _saveCacheTimestamp('favourites');
    return data;
  }

  Future<Drug> getDrug(int id, {bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _drugCache.containsKey(id) &&
        !_drugCache[id]!.isExpired) {
      return _drugCache[id]!.data;
    }
    final data = await _drugService.fetchDrug(id);
    _drugCache[id] = _CacheEntry(data, DateTime.now());
    return data;
  }

  Future<List<Drug>> searchDrugs(String query) async {
    return _drugService.searchDrug(query);
  }

  Future<List<DoseCalculationResult>> calculateDose(
    int drugId,
    Map<dynamic, dynamic> data,
  ) async {
    return _drugService.doseCalculation(drugId, data);
  }

  Future<List<DrugCategory>> getCategories(
      {bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _categoriesCache != null &&
        !_categoriesCache!.isExpired) {
      return _categoriesCache!.data;
    }
    final data = await _drugService.fetchCategories();
    _categoriesCache = _CacheEntry(data, DateTime.now());
    _saveCacheTimestamp('categories');
    return data;
  }

  Future<List<DrugSubCategory>> getSubCategories(
    int categoryId, {
    bool forceRefresh = false,
  }) async {
    final key = categoryId.toString();
    if (!forceRefresh &&
        _subCategoriesCache.containsKey(key) &&
        !_subCategoriesCache[key]!.isExpired) {
      return _subCategoriesCache[key]!.data;
    }
    final data = await _drugService.fetchSubCategories(categoryId);
    _subCategoriesCache[key] = _CacheEntry(data, DateTime.now());
    return data;
  }

  Future<List<Drug>> getDrugsBySubCategory(
    int categoryId,
    int subCategoryId, {
    bool forceRefresh = false,
  }) async {
    final key = '$categoryId-$subCategoryId';
    if (!forceRefresh &&
        _drugsBySubCategoryCache.containsKey(key) &&
        !_drugsBySubCategoryCache[key]!.isExpired) {
      return _drugsBySubCategoryCache[key]!.data;
    }
    final data =
        await _drugService.fetchDrugsBySubCategory(categoryId, subCategoryId);
    _drugsBySubCategoryCache[key] = _CacheEntry(data, DateTime.now());
    return data;
  }

  Future<bool> isFavourite(int drugId) async {
    return _drugService.fetchIsFavourite(drugId);
  }

  Future<bool> addFavourite(int drugId) async {
    final result = await _drugService.addFavourite(drugId);
    if (result) _favouritesCache = null; // Invalidate cache
    return result;
  }

  Future<bool> removeFavourite(int drugId) async {
    final result = await _drugService.deleteFavourite(drugId);
    if (result) _favouritesCache = null; // Invalidate cache
    return result;
  }

  void invalidateCache(String type) {
    switch (type) {
      case 'favourites':
        _favouritesCache = null;
      case 'categories':
        _categoriesCache = null;
      case 'drugs':
        _drugCache.clear();
      case 'all':
        _favouritesCache = null;
        _categoriesCache = null;
        _drugCache.clear();
        _subCategoriesCache.clear();
        _drugsBySubCategoryCache.clear();
    }
  }

  void _saveCacheTimestamp(String type) {
    try {
      final box = Hive.box('cache_timestamps');
      box.put('drug_$type', DateTime.now().toIso8601String());
    } catch (_) {
      // Hive not initialized — ignore
    }
  }
}

/// Repository for disease-related data.
class DiseaseRepository {
  DiseaseRepository({required DrugService drugService})
      : _drugService = drugService;

  final DrugService _drugService;

  _CacheEntry<List<Disease>>? _diseasesCache;
  final Map<int, _CacheEntry<Disease>> _diseaseCache = {};

  Future<List<Disease>> getDiseases({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _diseasesCache != null &&
        !_diseasesCache!.isExpired) {
      return _diseasesCache!.data;
    }
    final data = await _drugService.fetchDiseases();
    _diseasesCache = _CacheEntry(data, DateTime.now());
    _saveCacheTimestamp('diseases');
    return data;
  }

  Future<Disease> getDisease(int id, {bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _diseaseCache.containsKey(id) &&
        !_diseaseCache[id]!.isExpired) {
      return _diseaseCache[id]!.data;
    }
    final data = await _drugService.fetchDisease(id);
    _diseaseCache[id] = _CacheEntry(data, DateTime.now());
    return data;
  }

  Future<List<Disease>> searchDiseases(String query) async {
    return _drugService.searchDiseases(query);
  }

  void invalidateCache() {
    _diseasesCache = null;
    _diseaseCache.clear();
  }

  void _saveCacheTimestamp(String type) {
    try {
      final box = Hive.box('cache_timestamps');
      box.put('disease_$type', DateTime.now().toIso8601String());
    } catch (_) {
      // Hive not initialized — ignore
    }
  }
}

/// Repository for medical calculation data.
class CalculatorRepository {
  CalculatorRepository({required DrugService drugService})
      : _drugService = drugService;

  final DrugService _drugService;

  _CacheEntry<List<MedicalCalculation>>? _listCache;
  final Map<int, _CacheEntry<MedicalCalculation>> _detailCache = {};

  Future<List<MedicalCalculation>> getMedicalCalculations({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _listCache != null && !_listCache!.isExpired) {
      return _listCache!.data;
    }
    final data = await _drugService.fetchMedicalCalculations();
    _listCache = _CacheEntry(data, DateTime.now());
    _saveCacheTimestamp('calculations');
    return data;
  }

  Future<MedicalCalculation> getMedicalCalculation(
    int id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _detailCache.containsKey(id) &&
        !_detailCache[id]!.isExpired) {
      return _detailCache[id]!.data;
    }
    final data = await _drugService.fetchMedicalCalculation(id);
    _detailCache[id] = _CacheEntry(data, DateTime.now());
    return data;
  }

  Future<CalculationOutput> executeMedicalCalculation(
    int id,
    List<CalculationInput> data,
  ) async {
    return _drugService.executeMedicalCalculation(id, data);
  }

  void invalidateCache() {
    _listCache = null;
    _detailCache.clear();
  }

  void _saveCacheTimestamp(String type) {
    try {
      final box = Hive.box('cache_timestamps');
      box.put('calculator_$type', DateTime.now().toIso8601String());
    } catch (_) {
      // Hive not initialized — ignore
    }
  }
}

/// Repository for percentile calculations.
class PercentileRepository {
  PercentileRepository({required DrugService drugService})
      : _drugService = drugService;

  final DrugService _drugService;

  Future<PercentileOutput> calculateWeightPercentile(
    PercentileInput input,
  ) async {
    return _drugService.executeWeightPercentile(input);
  }

  Future<PercentileOutput> calculateLengthPercentile(
    PercentileInput input,
  ) async {
    return _drugService.executeLengthPercentile(input);
  }

  Future<BMIOutput> calculateBMIPercentile(BMIInput input) async {
    return _drugService.executeBMIPercentile(input);
  }
}

/// Repository for surgery referral data.
class SurgeryReferralRepository {
  SurgeryReferralRepository({required DrugService drugService})
      : _drugService = drugService;

  final DrugService _drugService;

  _CacheEntry<List<SurgeryReferral>>? _cache;

  Future<List<SurgeryReferral>> getSurgeriesReferral({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache != null && !_cache!.isExpired) {
      return _cache!.data;
    }
    final data = await _drugService.fetchSurgeriesReferral();
    _cache = _CacheEntry(data, DateTime.now());
    _saveCacheTimestamp('surgeries');
    return data;
  }

  void invalidateCache() {
    _cache = null;
  }

  void _saveCacheTimestamp(String type) {
    try {
      final box = Hive.box('cache_timestamps');
      box.put('surgery_$type', DateTime.now().toIso8601String());
    } catch (_) {
      // Hive not initialized — ignore
    }
  }
}

/// Repository for news and congress data.
class NewsRepository {
  NewsRepository({required DrugService drugService})
      : _drugService = drugService;

  final DrugService _drugService;

  _CacheEntry<List<News>>? _newsCache;
  _CacheEntry<List<Congress>>? _congressesCache;

  Future<List<News>> getNews({bool forceRefresh = false}) async {
    if (!forceRefresh && _newsCache != null && !_newsCache!.isExpired) {
      return _newsCache!.data;
    }
    final data = await _drugService.fetchNews();
    _newsCache = _CacheEntry(data, DateTime.now());
    _saveCacheTimestamp('news');
    return data;
  }

  Future<List<Congress>> getCongresses({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _congressesCache != null &&
        !_congressesCache!.isExpired) {
      return _congressesCache!.data;
    }
    final data = await _drugService.fetchCongresses();
    _congressesCache = _CacheEntry(data, DateTime.now());
    _saveCacheTimestamp('congresses');
    return data;
  }

  void invalidateCache() {
    _newsCache = null;
    _congressesCache = null;
  }

  void _saveCacheTimestamp(String type) {
    try {
      final box = Hive.box('cache_timestamps');
      box.put('news_$type', DateTime.now().toIso8601String());
    } catch (_) {
      // Hive not initialized — ignore
    }
  }
}
