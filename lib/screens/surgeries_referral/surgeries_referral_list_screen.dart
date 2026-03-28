import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/screens/surgeries_referral/surgery_referral_screen.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurgeriesReferralListScreen extends ConsumerWidget {
  const SurgeriesReferralListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralAsync = ref.watch(surgeryReferralListProvider);

    return referralAsync.when(
      loading: () => const ScreenLoading(),
      error: (_, __) => const ConnectionError(),
      data: (referrals) => Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Referenciação Cirúrgica')),
          body: BasePageLayout(children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  title: Text(referrals[index].scope ?? '',
                      style: Theme.of(context).textTheme.displaySmall),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurgeryReferralScreen(
                                surgeryReferral: referrals[index])));
                  },
                ));
              },
              itemCount: referrals.length,
            )
          ])),
    );
  }
}
