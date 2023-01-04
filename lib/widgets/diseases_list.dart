import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/disease.dart';
import '../screens/diseases/disease_screen.dart';
import '../services/drugs_service.dart';
import 'loading.dart';

class DiseasesList extends StatelessWidget {
  DiseasesList({Key? key}) : super(key: key);

  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();

  Future<List<Disease>> fetchDiseases() async {
    var ret = await _drugService
        .fetchDiseases(await _authenticationService.getUserToken());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Disease>>(
      future: fetchDiseases(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].description ?? "",
                    style: Theme.of(context).textTheme.headline3),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DiseaseScreen(disease: snapshot.data![index])));
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
}

// Create a corresponding State class.
// This class holds data related to the form.

