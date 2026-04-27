import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/screens/surgeries_referral/surgery_referral_screen.dart';
import 'package:easypedv3/utils/breakpoints.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:easypedv3/widgets/master_detail_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SurgeriesReferralListScreen extends ConsumerWidget {
  const SurgeriesReferralListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralAsync = ref.watch(surgeryReferralListProvider);
    final wide = !isCompact(context);

    // SurgeryReferral has no ID; use the list index as selector.
    final selectedIndexStr =
        GoRouterState.of(context).uri.queryParameters['selected'];
    final selectedIndex =
        selectedIndexStr != null ? int.tryParse(selectedIndexStr) : null;

    return referralAsync.when(
      loading: () => const ScreenLoading(),
      error: (_, __) => const ConnectionError(),
      data: (referrals) => Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Referenciação Cirúrgica')),
          body: MasterDetailScaffold(
            master: BasePageLayout(children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final isSelected = wide && index == selectedIndex;
                  return Card(
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                          : null,
                      child: ListTile(
                        title: Text(referrals[index].scope ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall),
                        onTap: () {
                          if (wide) {
                            context.go(
                                '/tools/surgeries-referral?selected=$index');
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SurgeryReferralScreen(
                                            surgeryReferral:
                                                referrals[index])));
                          }
                        },
                      ));
                },
                itemCount: referrals.length,
              )
            ]),
            detail: (selectedIndex != null &&
                    selectedIndex >= 0 &&
                    selectedIndex < referrals.length)
                ? SurgeryReferralScreen(
                    surgeryReferral: referrals[selectedIndex])
                : const EmptyDetailPane(),
          )),
    );
  }
}
