import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/repositories/repositories.dart';
import 'package:easypedv3/screens/drugs/drug_screen.dart';
import 'package:easypedv3/utils/breakpoints.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/drug_categories_list.dart';
import 'package:easypedv3/widgets/drugs_favourites_list.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/master_detail_scaffold.dart';
import 'package:easypedv3/widgets/skeletons/skeleton_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DrugsScreen extends ConsumerWidget {
  const DrugsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesAsync = ref.watch(favouritesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final wide = !isCompact(context);

    // Read selected drug id from URL query param for deep-linking.
    final selectedIdStr =
        GoRouterState.of(context).uri.queryParameters['selected'];
    final selectedId =
        selectedIdStr != null ? int.tryParse(selectedIdStr) : null;

    return favouritesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Medicamentos')),
        body: const SkeletonList(),
      ),
      error: (_, __) => const ConnectionError(),
      data: (favourites) => categoriesAsync.when(
        loading: () => Scaffold(
          appBar: AppBar(centerTitle: true, title: const Text('Medicamentos')),
          body: const SkeletonList(),
        ),
        error: (_, __) => const ConnectionError(),
        data: (categories) => Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Medicamentos'),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: DrugSearchDelegate(
                          drugRepository: ref.read(drugRepositoryProvider),
                          wide: wide,
                          onWideSelect: wide
                              ? (id) => context.go('/drugs?selected=$id')
                              : null,
                        ),
                      );
                    })
              ]),
          body: MasterDetailScaffold(
            master: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        tileColor: Theme.of(context).colorScheme.secondary,
                        title: Text('Os teus favoritos',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headlineMedium),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(2),
                          child: DrugsFavouritesList(
                            drugs: favourites,
                            selectedId: wide ? selectedId : null,
                            onSelect: wide
                                ? (id) =>
                                    context.go('/drugs?selected=$id')
                                : null,
                          )),
                      ListTile(
                        tileColor: Theme.of(context).colorScheme.secondary,
                        title: Text('Explora',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headlineMedium),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(2),
                          child: Column(children: [
                            DrugsCategoriesList(categories: categories),
                          ]))
                    ])),
            detail: selectedId != null
                ? DrugScreen(id: selectedId)
                : const EmptyDetailPane(),
          ),
        ),
      ),
    );
  }
}

class DrugSearchDelegate extends SearchDelegate<Drug> {
  DrugSearchDelegate({
    required this.drugRepository,
    this.wide = false,
    this.onWideSelect,
  });

  final DrugRepository drugRepository;
  final bool wide;
  final ValueChanged<int>? onWideSelect;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Drug(id: -1, name: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Drug>>(
      future: drugRepository.searchDrugs(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].name ?? '',
                    style: Theme.of(context).textTheme.displaySmall),
                subtitle: Text(
                    snapshot.data![index].subcategoryDescription ?? '',
                    style: Theme.of(context).textTheme.bodyMedium),
                onTap: () {
                  final id = snapshot.data![index].id!;
                  if (wide && onWideSelect != null) {
                    close(context, snapshot.data![index]);
                    onWideSelect!(id);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrugScreen(id: id)));
                  }
                },
              );
            },
            itemCount: snapshot.data!.length,
          );
        } else {
          return const Loading();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
