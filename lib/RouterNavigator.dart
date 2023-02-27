import 'package:easypedv3/auth_gate.dart';
import 'package:easypedv3/screens/diseases/disease_screen.dart';
import 'package:easypedv3/screens/medical_calculations/medical_calculation_screen.dart';
import 'package:easypedv3/widgets/cerror_screen.dart';
import 'package:easypedv3/widgets/connection_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/diseases/diseases_list_screen.dart';
import 'screens/drugs/drug_screen.dart';
import 'screens/drugs/drugs_screen.dart';
import 'screens/errors/error404_screen.dart';
import 'screens/medical_calculations/medical_calculations_list_screen.dart';
import 'screens/percentiles/percentiles_screen.dart';
import 'screens/surgeries_referral/surgeries_referral_list_screen.dart';

class RouterNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // routes: {
    //   // When navigating to the "/" route, build the FirstScreen widget.
    //   '/': (context) => const AuthGate(),
    //   // When navigating to the "/second" route, build the SecondScreen widget.
    //   '/drugs': (context) => const DrugsScreen(),
    //   '/diseases': (context) => const DiseasesListScreen(),
    //   '/percentiles': (context) => const PercentilesScreen(),
    //   '/medical-calculations': (context) =>
    //       const MedicalCalculationsListScreen(),
    //   '/surgeries-referral': (context) => const SurgeriesReferralListScreen()
    // },settings: settings,

    if (FirebaseAuth.instance.currentUser == null) {
      return MaterialPageRoute<AuthGate>(
          settings: settings, builder: (context) => const AuthGate());
    }

    try {
      if (settings.name == null || settings.name == '/') {
        return MaterialPageRoute<AuthGate>(
            settings: settings, builder: (context) => const AuthGate());
      } else if (settings.name == '/drugs' ||
          settings.name!.startsWith('/drugs/')) {
        // Handle '/details/:id'
        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2) {
          var id = int.parse(uri.pathSegments[1]);
          return MaterialPageRoute<DrugScreen>(
              settings: settings, builder: (context) => DrugScreen(id: id));
        } else {
          return MaterialPageRoute<DrugsScreen>(
              settings: settings, builder: (context) => const DrugsScreen());
        }
      } else if (settings.name == '/diseases' ||
          settings.name!.startsWith('/diseases/')) {
        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2) {
          var id = int.parse(uri.pathSegments[1]);
          return MaterialPageRoute<DiseaseScreen>(
              settings: settings,
              builder: (context) => DiseaseScreen(diseaseId: id));
        } else {
          return MaterialPageRoute<DiseasesListScreen>(
              settings: settings,
              builder: (context) => const DiseasesListScreen());
        }
      } else if (settings.name == '/percentiles') {
        return MaterialPageRoute<PercentilesScreen>(
            settings: settings,
            builder: (context) => const PercentilesScreen());
      } else if (settings.name == '/medical-calculations' ||
          settings.name!.startsWith('/medical-calculations/')) {
        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2) {
          var id = int.parse(uri.pathSegments[1]);
          return MaterialPageRoute<MedicalCalculationScreen>(
              settings: settings,
              builder: (context) =>
                  MedicalCalculationScreen(medicalCalculationId: id));
        } else {
          return MaterialPageRoute<MedicalCalculationsListScreen>(
              settings: settings,
              builder: (context) => MedicalCalculationsListScreen());
        }
      } else if (settings.name == '/surgeries-referral') {
        return MaterialPageRoute<SurgeriesReferralListScreen>(
            settings: settings,
            builder: (context) => SurgeriesReferralListScreen());
      } else if (settings.name == '/connection-error') {
        return MaterialPageRoute<ConnectionError>(
            settings: settings, builder: (context) => ConnectionError());
      } else {
        return MaterialPageRoute<Error404Screen>(
            settings: settings, builder: (context) => const Error404Screen());
      }
    } catch (exc) {
      return MaterialPageRoute<Error404Screen>(
          settings: settings, builder: (context) => const Error404Screen());
    }
  }
}
