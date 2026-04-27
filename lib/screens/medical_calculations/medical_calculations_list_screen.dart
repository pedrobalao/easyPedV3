import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/screens/medical_calculations/medical_calculation_screen.dart';
import 'package:easypedv3/utils/breakpoints.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/master_detail_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MedicalCalculationsListScreen extends ConsumerWidget {
  const MedicalCalculationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcAsync = ref.watch(calculatorListProvider);
    final wide = !isCompact(context);

    // Read selected calculation id from URL query param for deep-linking.
    final selectedIdStr =
        GoRouterState.of(context).uri.queryParameters['selected'];
    final selectedId =
        selectedIdStr != null ? int.tryParse(selectedIdStr) : null;

    return calcAsync.when(
      loading: () => const ScreenLoading(title: 'Cálculos Médicos'),
      error: (_, __) => const ConnectionError(),
      data: (calculations) => Scaffold(
          appBar: AppBar(
              centerTitle: true, title: const Text('Cálculos Médicos')),
          body: MasterDetailScaffold(
            master: BasePageLayout(children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final calc = calculations[index];
                  final isSelected = wide && calc.id == selectedId;
                  return Card(
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                          : null,
                      child: ListTile(
                        title: Text(calc.description ?? '',
                            style:
                                Theme.of(context).textTheme.displaySmall),
                        onTap: () {
                          final id = calc.id;
                          if (wide) {
                            context.go(
                                '/tools/medical-calculations?selected=$id');
                          } else {
                            context
                                .push('/tools/medical-calculations/$id');
                          }
                        },
                      ));
                },
                itemCount: calculations.length,
              )
            ]),
            detail: selectedId != null
                ? MedicalCalculationScreen(
                    medicalCalculationId: selectedId)
                : const EmptyDetailPane(),
          )),
    );
  }
}
