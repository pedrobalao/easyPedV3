import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/drugs_list.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugsListScreen extends ConsumerWidget {
  const DrugsListScreen({required this.drugSubCategory, super.key});

  final DrugSubCategory drugSubCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugsAsync = ref.watch(drugsBySubCategoryProvider((
      categoryId: drugSubCategory.categoryId!,
      subCategoryId: drugSubCategory.id!,
    )));

    return drugsAsync.when(
      loading: () => ScreenLoading(title: drugSubCategory.description),
      error: (_, __) => const ConnectionError(),
      data: (drugs) => Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(drugSubCategory.description ?? '')),
          body: BasePageLayout(children: [
            DrugsList(drugSubCategory: drugSubCategory, drugs: drugs)
          ])),
    );
  }
}
