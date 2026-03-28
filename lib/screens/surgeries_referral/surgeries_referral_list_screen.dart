import 'package:easypedv3/models/surgery_referral.dart';
import 'package:easypedv3/screens/surgeries_referral/surgery_referral_screen.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:easypedv3/widgets/base_page_layout.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:easypedv3/widgets/loading.dart';
import 'package:flutter/material.dart';

// class SurgeriesReferralListScreen extends StatefulWidget {
//   const SurgeriesReferralListScreen({Key? key}) : super(key: key);

//   @override
//   _SurgeriesReferralListScreenState createState() =>
//       _SurgeriesReferralListScreenState();
// }

// class _SurgeriesReferralListScreenState
//     extends State<SurgeriesReferralListScreen> {
//   Icon actionIcon = const Icon(Icons.search);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           centerTitle: true, title: const Text("Referenciação Cirúrgica")),
//       body: BasePageLayout(children: [SurgeriesReferralListWidget()]),
//     );
//   }
// }

class SurgeriesReferralListScreen extends StatelessWidget {
  SurgeriesReferralListScreen({super.key});

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<SurgeryReferral>> fetchSurgeriesReferral() async {
    final ret = await _drugService
        .fetchSurgeriesReferral(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SurgeryReferral>>(
      future: fetchSurgeriesReferral(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ConnectionError();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
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
                      title: Text(snapshot.data![index].scope ?? '',
                          style: Theme.of(context).textTheme.displaySmall),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurgeryReferralScreen(
                                    surgeryReferral: snapshot.data![index])));
                      },
                    ));
                  },
                  itemCount: snapshot.data!.length,
                )
              ]));
        } else {
          return const ScreenLoading();
        }
      },
    );
  }
}
