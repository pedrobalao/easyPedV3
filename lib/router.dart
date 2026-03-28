import 'package:easypedv3/providers/providers.dart';
import 'package:easypedv3/screens/about/about_screen.dart';
import 'package:easypedv3/screens/auth/signin_screen.dart';
import 'package:easypedv3/screens/diseases/disease_screen.dart';
import 'package:easypedv3/screens/diseases/diseases_list_screen.dart';
import 'package:easypedv3/screens/drugs/drug_screen.dart';
import 'package:easypedv3/screens/drugs/drugs_screen.dart';
import 'package:easypedv3/screens/errors/error404_screen.dart';
import 'package:easypedv3/screens/home_screen.dart';
import 'package:easypedv3/screens/medical_calculations/medical_calculation_screen.dart';
import 'package:easypedv3/screens/medical_calculations/medical_calculations_list_screen.dart';
import 'package:easypedv3/screens/percentiles/percentiles_screen.dart';
import 'package:easypedv3/screens/surgeries_referral/surgeries_referral_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// GoRouter configuration provider, integrates auth redirect.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isOnSignIn = state.matchedLocation == '/sign-in';

      if (!isAuthenticated && !isOnSignIn) {
        return '/sign-in';
      }
      if (isAuthenticated && isOnSignIn) {
        return '/';
      }
      return null;
    },
    errorBuilder: (context, state) => const Error404Screen(),
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const EPSignScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/drugs',
        builder: (context, state) => const DrugsScreen(),
      ),
      GoRoute(
        path: '/drugs/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DrugScreen(id: id);
        },
      ),
      GoRoute(
        path: '/diseases',
        builder: (context, state) => const DiseasesListScreen(),
      ),
      GoRoute(
        path: '/diseases/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DiseaseScreen(diseaseId: id);
        },
      ),
      GoRoute(
        path: '/percentiles',
        builder: (context, state) => const PercentilesScreen(),
      ),
      GoRoute(
        path: '/medical-calculations',
        builder: (context, state) => const MedicalCalculationsListScreen(),
      ),
      GoRoute(
        path: '/medical-calculations/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MedicalCalculationScreen(medicalCalculationId: id);
        },
      ),
      GoRoute(
        path: '/surgeries-referral',
        builder: (context, state) => const SurgeriesReferralListScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});
