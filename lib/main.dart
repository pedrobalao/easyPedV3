// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:easypedv3/firebase_options.dart';
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

    // Initialize Hive for local caching
    await Hive.initFlutter();
    await Hive.openBox('cache_timestamps');

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
    const primaryColor = const Color(0xFF2963C8);
    const secondaryColor = const Color(0xFF218838);

    const negativeColor = const Color(0xFF651F06);

    final themeData = ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: primaryColor,

      // Define the default font family.
      fontFamily: 'Montserrat',

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        displayLarge: GoogleFonts.openSans(fontSize: 42),
        displayMedium: GoogleFonts.openSans(fontSize: 42, color: primaryColor),
        displaySmall: GoogleFonts.openSans(fontSize: 18, color: primaryColor),
        titleLarge: GoogleFonts.openSans(fontSize: 22, color: primaryColor),
        headlineMedium: GoogleFonts.openSans(
            fontSize: 18,
            color: Colors.white,
            backgroundColor: const Color(0xFF28a745)),
        headlineSmall:
            GoogleFonts.openSans(fontSize: 32, color: secondaryColor),
        bodyLarge: GoogleFonts.openSans(fontSize: 14),
        bodyMedium: GoogleFonts.openSans(fontSize: 12, color: secondaryColor),
        bodySmall: GoogleFonts.openSans(fontSize: 14, color: primaryColor),
      ),
      cardTheme: const CardTheme(clipBehavior: Clip.none),
      listTileTheme: const ListTileThemeData(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        // ···
        error: negativeColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.openSans(fontSize: 20, color: Colors.white),
      ),
    );

    final router = ref.watch(routerProvider);

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: themeData,
        ));
  }
}
