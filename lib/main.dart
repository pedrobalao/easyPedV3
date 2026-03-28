// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:easypedv3/firebase_options.dart';
import 'package:easypedv3/router_navigator.dart';
import 'package:easypedv3/services/app_info_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await dotenv.load();

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppInfoService.initiateAppInfoService();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([
      GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID']!),
      AppleProvider()
    ]);

    final analytics = FirebaseAnalytics.instance;
    // The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  String string = '';
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  @override
  Widget build(BuildContext context) {
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
    ); //ColorScheme(error: negativeColor));

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          navigatorObservers: [observer],
          debugShowCheckedModeBanner: false,
          theme: themeData,
          //home: const AuthGate(),
          initialRoute: '/',
          onGenerateRoute: RouterNavigator.generateRoute,
        ));
  }
}
