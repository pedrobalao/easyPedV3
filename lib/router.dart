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
import 'package:easypedv3/screens/tools_screen.dart';
import 'package:easypedv3/widgets/scaffold_with_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Custom fade-through page transition for GoRouter.
CustomTransitionPage<T> fadeTransitionPage<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

// Navigator keys for each tab so they preserve their own navigation stack.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _drugsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'drugs');
final _diseasesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'diseases');
final _toolsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'tools');
final _aboutNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'about');

/// GoRouter configuration provider, integrates auth redirect.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EPSignScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          // ── Home tab ──────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // ── Drugs tab ─────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _drugsNavigatorKey,
            routes: [
              GoRoute(
                path: '/drugs',
                builder: (context, state) => const DrugsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return fadeTransitionPage(
                        state: state,
                        child: DrugScreen(id: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // ── Diseases tab ──────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _diseasesNavigatorKey,
            routes: [
              GoRoute(
                path: '/diseases',
                builder: (context, state) => const DiseasesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return fadeTransitionPage(
                        state: state,
                        child: DiseaseScreen(diseaseId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // ── Tools tab ─────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _toolsNavigatorKey,
            routes: [
              GoRoute(
                path: '/tools',
                builder: (context, state) => const ToolsScreen(),
                routes: [
                  GoRoute(
                    path: 'percentiles',
                    builder: (context, state) => const PercentilesScreen(),
                  ),
                  GoRoute(
                    path: 'medical-calculations',
                    builder: (context, state) =>
                        const MedicalCalculationsListScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) {
                          final id = int.parse(state.pathParameters['id']!);
                          return MedicalCalculationScreen(
                            medicalCalculationId: id,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'surgeries-referral',
                    builder: (context, state) =>
                        const SurgeriesReferralListScreen(),
                  ),
                ],
              ),
            ],
          ),
          // ── About tab ─────────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _aboutNavigatorKey,
            routes: [
              GoRoute(
                path: '/about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
