import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/congresses_slide.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/global_search.dart';
import 'package:easypedv3/widgets/news_slide.dart';
import 'package:easypedv3/widgets/quick_access_grid.dart';
import 'package:easypedv3/widgets/skeletons/skeleton_home.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.warning_amber_rounded,
              size: 48, color: colorScheme.error),
          title: Text(
            'Atenção',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          content: const Text(
            'A informação presente no easyPed pode conter erros e destina-se '
            'exclusivamente para fins educacionais. Não nos responsabilizamos '
            'por qualquer consequência do uso da mesma. Toda a informação deve '
            'ser validada pelo médico.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Li e Concordo'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showedDisclaimer = ref.watch(showedDisclaimerProvider);

    if (!showedDisclaimer) {
      Future.delayed(Duration.zero, () {
        ref.read(showedDisclaimerProvider.notifier).state = true;
        _showMyDialog(context);
      });
    }

    final newsAsync = ref.watch(newsProvider);
    final congressesAsync = ref.watch(congressProvider);
    final favouritesAsync = ref.watch(favouritesProvider);
    final recentSearches = ref.watch(recentSearchesNotifierProvider);

    return newsAsync.when(
      loading: () => const SkeletonHome(),
      error: (_, __) => const ConnectionError(),
      data: (news) => congressesAsync.when(
        loading: () => const SkeletonHome(),
        error: (_, __) => const ConnectionError(),
        data: (congresses) => Scaffold(
          appBar: AppBar(title: const Text('easyPed'), actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: GlobalSearchDelegate(
                    drugRepository: ref.read(drugRepositoryProvider),
                    diseaseRepository: ref.read(diseaseRepositoryProvider),
                    calculatorRepository:
                        ref.read(calculatorRepositoryProvider),
                    surgeryReferralRepository:
                        ref.read(surgeryReferralRepositoryProvider),
                    ref: ref,
                  ),
                );
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'sign_out') {
                  FirebaseUIAuth.signOut(context: context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'sign_out',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sair'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ]),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(newsProvider);
              ref.invalidate(congressProvider);
              ref.invalidate(favouritesProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(12),
                  // ── Quick Access Grid ──
                  _SectionHeader(
                    title: 'Acesso Rápido',
                    icon: Icons.grid_view_rounded,
                  ),
                  const QuickAccessGrid(),
                  const Gap(8),
                  // ── Favourites Section ──
                  _SectionHeader(
                    title: 'Favoritos',
                    icon: Icons.favorite,
                  ),
                  _FavouritesSection(favouritesAsync: favouritesAsync),
                  const Gap(8),
                  // ── Recent Searches Section ──
                  if (recentSearches.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Pesquisas Recentes',
                      icon: Icons.history,
                    ),
                    _RecentSearchesSection(
                      searches: recentSearches,
                      onTap: (query) {
                        showSearch(
                          context: context,
                          delegate: GlobalSearchDelegate(
                            drugRepository: ref.read(drugRepositoryProvider),
                            diseaseRepository:
                                ref.read(diseaseRepositoryProvider),
                            calculatorRepository:
                                ref.read(calculatorRepositoryProvider),
                            surgeryReferralRepository:
                                ref.read(surgeryReferralRepositoryProvider),
                            ref: ref,
                          ),
                          query: query,
                        );
                      },
                      onClear: () {
                        ref
                            .read(recentSearchesNotifierProvider.notifier)
                            .clearAll();
                      },
                    ),
                    const Gap(8),
                  ],
                  // ── Congresses Carousel ──
                  _SectionHeader(
                    title: 'Congressos',
                    icon: Icons.event,
                  ),
                  const Gap(4),
                  CongressesSlide(congresses: congresses),
                  const Gap(16),
                  // ── News Carousel ──
                  _SectionHeader(
                    title: 'Novidades',
                    icon: Icons.newspaper,
                  ),
                  const Gap(4),
                  NewsSlide(news: news),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section header with icon and title, used throughout the dashboard.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

/// Favourites section showing bookmarked drugs.
class _FavouritesSection extends StatelessWidget {
  const _FavouritesSection({required this.favouritesAsync});

  final AsyncValue favouritesAsync;

  @override
  Widget build(BuildContext context) {
    return favouritesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Não foi possível carregar os favoritos.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (favourites) {
        final drugs = favourites as List;
        if (drugs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                title: Text(
                  'Ainda não tens favoritos.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: const Text('Adiciona medicamentos aos favoritos.'),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: drugs.length > 5 ? 5 : drugs.length,
          itemBuilder: (context, index) {
            final drug = drugs[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.medication,
                    color: Theme.of(context).colorScheme.primary),
                title: Hero(
                  tag: 'drug-name-${drug.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(drug.name ?? '',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
                subtitle: Text(drug.subcategoryDescription ?? '',
                    style: Theme.of(context).textTheme.bodyMedium),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/drugs/${drug.id}'),
              ),
            );
          },
        );
      },
    );
  }
}

/// Recent searches section with chips.
class _RecentSearchesSection extends StatelessWidget {
  const _RecentSearchesSection({
    required this.searches,
    required this.onTap,
    required this.onClear,
  });

  final List<String> searches;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: searches.map((query) {
              return ActionChip(
                avatar: Icon(Icons.history,
                    size: 18, color: colorScheme.onSurfaceVariant),
                label: Text(query),
                onPressed: () => onTap(query),
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onClear,
              child: const Text('Limpar'),
            ),
          ),
        ],
      ),
    );
  }
}
