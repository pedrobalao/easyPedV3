import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/drug_subcategories_list.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsSubCategoriesScreen extends ConsumerWidget {
  const DrugsSubCategoriesScreen({required this.drugCategory, super.key});

  final DrugCategory drugCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subCatsAsync = ref.watch(subCategoriesProvider(drugCategory.id!));

    return subCatsAsync.when(
      loading: () => ScreenLoading(title: drugCategory.description),
      error: (_, __) => const ConnectionError(),
      data: (subCategories) => Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(drugCategory.description ?? '')),
          body: BasePageLayout(children: [
            DrugsSubCategoriesList(subCategories: subCategories)
          ])),
    );
  }
}
