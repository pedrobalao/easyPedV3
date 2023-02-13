import 'package:easypedv3/screens/surgeries_referral/surgery_referral_screen.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/surgery_referral.dart';
import '../services/drugs_service.dart';
import 'loading.dart';

class SurgeriesReferralListWidget extends StatelessWidget {
  SurgeriesReferralListWidget({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<SurgeryReferral>> fetchSurgeriesReferral() async {
    var ret = await _drugService
        .fetchSurgeriesReferral(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SurgeryReferral>>(
      future: fetchSurgeriesReferral(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(snapshot.data![index].scope ?? "",
                    style: Theme.of(context).textTheme.headline3),
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
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

