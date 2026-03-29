import 'dart:async';

import 'package:easypedv3/firebase_options.dart';
import 'package:easypedv3/providers/theme_provider.dart';
import 'package:easypedv3/router.dart';
import 'package:easypedv3/services/app_info_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await dotenv.load();

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive for local caching and preferences
    await Hive.initFlutter();
    await Hive.openBox('cache_timestamps');
    await Hive.openBox('theme_preferences');
    await Hive.openBox('recent_searches');

    await AppInfoService.initiateAppInfoService();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([
      GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID']!),
      AppleProvider()
    ]);

    // The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2963C8),
      secondary: const Color(0xFF28a745),
      onSecondary: Colors.white,
      error: const Color(0xFF651F06),
    );

    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
        displayLarge: GoogleFonts.openSans(fontSize: 42),
        displayMedium:
            GoogleFonts.openSans(fontSize: 42, color: colorScheme.primary),
        displaySmall:
            GoogleFonts.openSans(fontSize: 18, color: colorScheme.primary),
        titleLarge:
            GoogleFonts.openSans(fontSize: 22, color: colorScheme.primary),
        headlineMedium: GoogleFonts.openSans(
            fontSize: 18,
            color: colorScheme.onSecondary,
            backgroundColor: colorScheme.secondary),
        headlineSmall:
            GoogleFonts.openSans(fontSize: 32, color: colorScheme.secondary),
        bodyLarge: GoogleFonts.openSans(fontSize: 14),
        bodyMedium:
            GoogleFonts.openSans(fontSize: 12, color: colorScheme.secondary),
        bodySmall:
            GoogleFonts.openSans(fontSize: 14, color: colorScheme.primary),
      ),
      cardTheme: const CardTheme(clipBehavior: Clip.none),
      listTileTheme: const ListTileThemeData(),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        titleTextStyle:
            GoogleFonts.openSans(fontSize: 20, color: colorScheme.onPrimary),
      ),
    );

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: themeData,
          darkTheme: themeData.copyWith(
            colorScheme: themeData.colorScheme.copyWith(
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeMode,
        ));
  }
}
