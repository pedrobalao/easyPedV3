import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MedicalCalculationsListScreen extends ConsumerWidget {
  const MedicalCalculationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcAsync = ref.watch(calculatorListProvider);

    return calcAsync.when(
      loading: () => const ScreenLoading(title: 'Cálculos Médicos'),
      error: (_, __) => const ConnectionError(),
      data: (calculations) => Scaffold(
          appBar: AppBar(
              centerTitle: true, title: const Text('Cálculos Médicos')),
          body: BasePageLayout(children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  title: Text(calculations[index].description ?? '',
                      style: Theme.of(context).textTheme.displaySmall),
                  onTap: () {
                    final id = calculations[index].id;
                    context.push('/medical-calculations/$id');
                  },
                ));
              },
              itemCount: calculations.length,
            )
          ])),
    );
  }
}
