import 'package:easypedv3/providers/search_provider.dart';
import 'package:easypedv3/repositories/repositories.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A unified search result entry with type metadata.
class _SearchResult {
  const _SearchResult({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.route,
    required this.type,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String route;
  final String type;
}

/// Global [SearchDelegate] that searches across drugs, diseases,
/// medical calculators and surgery referrals.
class GlobalSearchDelegate extends SearchDelegate<String> {
  GlobalSearchDelegate({
    required this.drugRepository,
    required this.diseaseRepository,
    required this.calculatorRepository,
    required this.surgeryReferralRepository,
    required this.ref,
  }) : super(searchFieldLabel: 'Pesquisar...');

  final DrugRepository drugRepository;
  final DiseaseRepository diseaseRepository;
  final CalculatorRepository calculatorRepository;
  final SurgeryReferralRepository surgeryReferralRepository;
  final WidgetRef ref;

  // ── SearchDelegate overrides ─────────────────────────────────────

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return _buildRecentSearches(context);
    }

    // Store the query
    ref.read(recentSearchesNotifierProvider.notifier).addSearch(trimmed);

    return _SearchResultsView(
      query: trimmed,
      drugRepository: drugRepository,
      diseaseRepository: diseaseRepository,
      calculatorRepository: calculatorRepository,
      surgeryReferralRepository: surgeryReferralRepository,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return _buildRecentSearches(context);
    }

    // Live search as user types (debounced via Flutter's SearchDelegate)
    return _SearchResultsView(
      query: query.trim(),
      drugRepository: drugRepository,
      diseaseRepository: diseaseRepository,
      calculatorRepository: calculatorRepository,
      surgeryReferralRepository: surgeryReferralRepository,
    );
  }

  // ── Recent searches on empty state ───────────────────────────────

  Widget _buildRecentSearches(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final recent = ref.watch(recentSearchesNotifierProvider);

        if (recent.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(
                  'Pesquise medicamentos, doenças,\ncalculadoras e mais...',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          );
        }

        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pesquisas Recentes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(recentSearchesNotifierProvider.notifier)
                          .clearAll();
                    },
                    child: const Text('Limpar'),
                  ),
                ],
              ),
            ),
            ...recent.map((q) => ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(q),
                  onTap: () {
                    query = q;
                    showResults(context);
                  },
                )),
          ],
        );
      },
    );
  }
}

// ── Stateful widget that executes parallel searches ─────────────────

class _SearchResultsView extends StatefulWidget {
  const _SearchResultsView({
    required this.query,
    required this.drugRepository,
    required this.diseaseRepository,
    required this.calculatorRepository,
    required this.surgeryReferralRepository,
  });

  final String query;
  final DrugRepository drugRepository;
  final DiseaseRepository diseaseRepository;
  final CalculatorRepository calculatorRepository;
  final SurgeryReferralRepository surgeryReferralRepository;

  @override
  State<_SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<_SearchResultsView> {
  late Future<List<_SearchResult>> _searchFuture;

  @override
  void initState() {
    super.initState();
    _searchFuture = _performSearch();
  }

  @override
  void didUpdateWidget(covariant _SearchResultsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _searchFuture = _performSearch();
    }
  }

  /// Normalises a string for fuzzy comparison by lowering case and removing
  /// diacritical marks (accents).
  static String _normalise(String input) {
    const accented =
        'àáâãäåæçèéêëìíîïðñòóôõöùúûüýÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝ';
    const plain =
        'aaaaaaeceeeeiiiidnoooooouuuuyAAAAAAECEEEEIIIIDNOOOOOUUUUY';
    var s = input.toLowerCase();
    for (var i = 0; i < accented.length; i++) {
      s = s.replaceAll(accented[i], plain[i]);
    }
    return s;
  }

  /// Returns true if [text] contains all words in [queryWords] in any order.
  static bool _fuzzyMatch(String text, List<String> queryWords) {
    final normalised = _normalise(text);
    return queryWords.every((w) => normalised.contains(w));
  }

  Future<List<_SearchResult>> _performSearch() async {
    final words = _normalise(widget.query).split(RegExp(r'\s+'));
    final queryWords = words.where((w) => w.isNotEmpty).toList();
    if (queryWords.isEmpty) return [];

    // Run API searches and local filtering in parallel.
    final results = await Future.wait([
      _searchDrugs(queryWords),
      _searchDiseases(queryWords),
      _searchCalculators(queryWords),
      _searchSurgeryReferrals(queryWords),
    ]);

    return [
      ...results[0],
      ...results[1],
      ...results[2],
      ...results[3],
    ];
  }

  Future<List<_SearchResult>> _searchDrugs(List<String> queryWords) async {
    try {
      final drugs = await widget.drugRepository.searchDrugs(widget.query);
      return drugs
          .where((d) => d.name != null && d.id != null)
          .map((d) => _SearchResult(
                title: d.name!,
                subtitle: d.subcategoryDescription,
                icon: Icons.medication,
                route: '/drugs/${d.id}',
                type: 'Medicamentos',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<_SearchResult>> _searchDiseases(List<String> queryWords) async {
    try {
      final diseases =
          await widget.diseaseRepository.searchDiseases(widget.query);
      return diseases
          .where((d) => d.description != null && d.id != null)
          .map((d) => _SearchResult(
                title: d.description!,
                icon: Icons.coronavirus,
                route: '/diseases/${d.id}',
                type: 'Doenças',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<_SearchResult>> _searchCalculators(
      List<String> queryWords) async {
    try {
      final calcs =
          await widget.calculatorRepository.getMedicalCalculations();
      return calcs
          .where((c) =>
              c.description != null &&
              c.id != null &&
              _fuzzyMatch(c.description!, queryWords))
          .map((c) => _SearchResult(
                title: c.description!,
                icon: Icons.calculate,
                route: '/tools/medical-calculations/${c.id}',
                type: 'Calculadoras',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<_SearchResult>> _searchSurgeryReferrals(
      List<String> queryWords) async {
    try {
      final referrals =
          await widget.surgeryReferralRepository.getSurgeriesReferral();
      return referrals
          .where((r) =>
              r.scope != null && _fuzzyMatch(r.scope!, queryWords))
          .map((r) => _SearchResult(
                title: r.scope!,
                icon: Icons.local_hospital,
                route: '/tools/surgeries-referral',
                type: 'Ref. Cirúrgica',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_SearchResult>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Loading();
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(
                  'Sem resultados para "${widget.query}"',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        // Group results by type, preserving order.
        final grouped = <String, List<_SearchResult>>{};
        for (final r in results) {
          grouped.putIfAbsent(r.type, () => []).add(r);
        }

        return ListView(
          children: [
            for (final entry in grouped.entries) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ...entry.value.map((r) => ListTile(
                    leading: Icon(r.icon,
                        color: Theme.of(context).colorScheme.primary),
                    title: Text(r.title,
                        style: Theme.of(context).textTheme.displaySmall),
                    subtitle: r.subtitle != null
                        ? Text(r.subtitle!,
                            style: Theme.of(context).textTheme.bodyMedium)
                        : null,
                    onTap: () {
                      context.push(r.route);
                    },
                  )),
              const Divider(height: 1),
            ],
          ],
        );
      },
    );
  }
}
