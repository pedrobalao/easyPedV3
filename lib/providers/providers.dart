import 'package:easypedv3/models/congress.dart';
import 'package:easypedv3/models/disease.dart';
import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/models/medical_calculation.dart';
import 'package:easypedv3/models/news.dart';
import 'package:easypedv3/models/surgery_referral.dart';
import 'package:easypedv3/repositories/notes_repository.dart';
import 'package:easypedv3/repositories/repositories.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:easypedv3/providers/ai_chat_provider.dart'
    show
        aiChatServiceProvider,
        aiDisclaimerAcceptedProvider,
        chatLoadingProvider,
        chatMessagesProvider;
export 'package:easypedv3/providers/search_provider.dart'
    show recentSearchesNotifierProvider;
export 'package:easypedv3/providers/subscription_provider.dart'
    show isProProvider, offeringsProvider, subscriptionServiceProvider;

// ── Auth ────────────────────────────────────────────────────────────

/// Stream of Firebase auth state changes.
final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ── Service ─────────────────────────────────────────────────────────

/// Singleton DrugService provider.
final drugServiceProvider = Provider<DrugService>((ref) {
  return DrugService();
});

// ── Repositories ────────────────────────────────────────────────────

final drugRepositoryProvider = Provider<DrugRepository>((ref) {
  return DrugRepository(drugService: ref.watch(drugServiceProvider));
});

final diseaseRepositoryProvider = Provider<DiseaseRepository>((ref) {
  return DiseaseRepository(drugService: ref.watch(drugServiceProvider));
});

final calculatorRepositoryProvider = Provider<CalculatorRepository>((ref) {
  return CalculatorRepository(drugService: ref.watch(drugServiceProvider));
});

final percentileRepositoryProvider = Provider<PercentileRepository>((ref) {
  return PercentileRepository(drugService: ref.watch(drugServiceProvider));
});

final surgeryReferralRepositoryProvider =
    Provider<SurgeryReferralRepository>((ref) {
  return SurgeryReferralRepository(drugService: ref.watch(drugServiceProvider));
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(drugService: ref.watch(drugServiceProvider));
});

// ── Drug data providers ─────────────────────────────────────────────

/// Async list of user favourites.
final favouritesProvider = FutureProvider<List<Drug>>((ref) async {
  final repo = ref.watch(drugRepositoryProvider);
  return repo.getFavourites();
});

/// Async list of drug categories.
final categoriesProvider = FutureProvider<List<DrugCategory>>((ref) async {
  final repo = ref.watch(drugRepositoryProvider);
  return repo.getCategories();
});

/// Single drug by ID.
final drugDetailProvider = FutureProvider.family<Drug, int>((ref, id) async {
  final repo = ref.watch(drugRepositoryProvider);
  return repo.getDrug(id);
});

/// Sub-categories for a given category.
final subCategoriesProvider =
    FutureProvider.family<List<DrugSubCategory>, int>((ref, categoryId) async {
  final repo = ref.watch(drugRepositoryProvider);
  return repo.getSubCategories(categoryId);
});

/// Drugs for a given sub-category.
final drugsBySubCategoryProvider =
    FutureProvider.family<List<Drug>, ({int categoryId, int subCategoryId})>(
        (ref, params) async {
  final repo = ref.watch(drugRepositoryProvider);
  return repo.getDrugsBySubCategory(params.categoryId, params.subCategoryId);
});

// ── Disease data providers ──────────────────────────────────────────

/// Async list of diseases.
final diseaseListProvider = FutureProvider<List<Disease>>((ref) async {
  final repo = ref.watch(diseaseRepositoryProvider);
  return repo.getDiseases();
});

/// Single disease by ID.
final diseaseDetailProvider =
    FutureProvider.family<Disease, int>((ref, id) async {
  final repo = ref.watch(diseaseRepositoryProvider);
  return repo.getDisease(id);
});

// ── Calculator data providers ───────────────────────────────────────

/// Async list of medical calculators.
final calculatorListProvider =
    FutureProvider<List<MedicalCalculation>>((ref) async {
  final repo = ref.watch(calculatorRepositoryProvider);
  return repo.getMedicalCalculations();
});

/// Single medical calculation by ID.
final calculatorDetailProvider =
    FutureProvider.family<MedicalCalculation, int>((ref, id) async {
  final repo = ref.watch(calculatorRepositoryProvider);
  return repo.getMedicalCalculation(id);
});

// ── Surgery referral data providers ─────────────────────────────────

/// Async list of surgery referrals.
final surgeryReferralListProvider =
    FutureProvider<List<SurgeryReferral>>((ref) async {
  final repo = ref.watch(surgeryReferralRepositoryProvider);
  return repo.getSurgeriesReferral();
});

// ── News & Congress data providers ──────────────────────────────────

/// Async news feed.
final newsProvider = FutureProvider<List<News>>((ref) async {
  final repo = ref.watch(newsRepositoryProvider);
  return repo.getNews();
});

/// Async congress feed.
final congressProvider = FutureProvider<List<Congress>>((ref) async {
  final repo = ref.watch(newsRepositoryProvider);
  return repo.getCongresses();
});

// ── App state providers ─────────────────────────────────────────────

/// Replaces LocalState singleton — tracks whether disclaimer was shown.
final showedDisclaimerProvider = StateProvider<bool>((ref) => false);

// ── Notes repository ────────────────────────────────────────────────

/// Singleton NotesRepository provider for clinical notes.
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository();
});
