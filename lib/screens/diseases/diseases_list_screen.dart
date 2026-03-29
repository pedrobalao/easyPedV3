import 'package:easypedv3/models/disease.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/repositories/repositories.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/skeletons/skeleton_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiseasesListScreen extends ConsumerWidget {
  const DiseasesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diseasesAsync = ref.watch(diseaseListProvider);

    return diseasesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Doenças')),
        body: const SkeletonList(),
      ),
      error: (_, __) => const ConnectionError(),
      data: (diseases) => Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Doenças'),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: DiseasesSearchDelegate(
                          diseaseRepository:
                              ref.read(diseaseRepositoryProvider),
                        ),
                      );
                    })
              ]),
          body: BasePageLayout(children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(2),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  title: Hero(
                    tag: 'disease-name-${diseases[index].id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(diseases[index].description ?? '',
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                  ),
                  onTap: () {
                    final id = diseases[index].id;
                    context.push('/diseases/$id');
                  },
                ));
              },
              itemCount: diseases.length,
            )
          ])),
    );
  }
}

class DiseasesSearchDelegate extends SearchDelegate<Disease> {
  DiseasesSearchDelegate({required this.diseaseRepository});

  final DiseaseRepository diseaseRepository;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Disease(id: -1, description: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Disease>>(
      future: diseaseRepository.searchDiseases(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].description ?? '',
                    style: Theme.of(context).textTheme.displaySmall),
                onTap: () {
                  final id = snapshot.data![index].id;
                  context.push('/diseases/$id');
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
