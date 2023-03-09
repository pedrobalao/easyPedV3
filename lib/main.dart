// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:catcher/catcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easypedv3/utils/network_connectivity.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'RouterNavigator.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([
      //EmailAuthProvide(),
      GoogleProvider(
          clientId:
              "330541011565-p4clgm77d42sbqjrkojro5495pp9kdr4.apps.googleusercontent.com"),
      AppleProvider()
    ]);

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    // The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    CatcherOptions debugOptions =
        CatcherOptions(DialogReportMode(), [ConsoleHandler(), ToastHandler()]);

    /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
    CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
      EmailManualHandler(["pedrocha@gmail.com"]),
      ToastHandler()
    ]);

    /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
    Catcher(
        rootWidget: MyApp(),
        debugConfig: debugOptions,
        releaseConfig: releaseOptions);
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));

  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   // If we're in debug mode, use the normal error widget which shows the error
  //   // message:
  //   // if (kDebugMode) {
  //   //   return ErrorWidget(details.exception);
  //   // }
  //   // In release builds, show a yellow-on-blue message instead:
  //   return CErrorScreen(details: details);
  // };

  // final talker = Talker(
  //   loggerSettings: TalkerLoggerSettings(
  //     enableColors: !Platform.isIOS,
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Map _source = {ConnectivityResult.none: false};
  // final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  @override
  Widget build(BuildContext context) {
    // _networkConnectivity.initialise();
    // _networkConnectivity.myStream.listen((source) {
    //   _source = source;
    //   print('source $_source');
    //   bool online = false;

    //   switch (_source.keys.toList()[0]) {
    //     case ConnectivityResult.mobile:
    //       online = _source.values.toList()[0] ? true : false;
    //       string =
    //           _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
    //       break;
    //     case ConnectivityResult.wifi:
    //       online = _source.values.toList()[0] ? true : false;
    //       string =
    //           _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
    //       break;
    //     case ConnectivityResult.none:
    //     default:
    //       string = 'Offline';
    //       online = false;
    //   }

    //   print('connectionStatus: $string');
    //   if (!online) {
    //     Navigator.pushNamed(context, "/connection-error");
    //   }

    //   // 1.
    // });

    const primaryColor = const Color(0xFF2963C8);
    const secondaryColor = const Color(0xFF218838);

    const negativeColor = const Color(0xFF651F06);

    ThemeData themeData = ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: primaryColor,
        errorColor: negativeColor,

        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: GoogleFonts.openSans(fontSize: 42.0),
          headline2: GoogleFonts.openSans(fontSize: 42.0, color: primaryColor),
          headline3: GoogleFonts.openSans(fontSize: 18.0, color: primaryColor),
          headline6: GoogleFonts.openSans(fontSize: 22.0, color: primaryColor),
          headline4: GoogleFonts.openSans(
              fontSize: 18.0,
              color: Colors.white,
              backgroundColor: const Color(0xFF28a745)),
          headline5:
              GoogleFonts.openSans(fontSize: 32.0, color: secondaryColor),
          bodyText1: GoogleFonts.openSans(fontSize: 14.0),
          bodyText2:
              GoogleFonts.openSans(fontSize: 12.0, color: secondaryColor),
          caption: GoogleFonts.openSans(fontSize: 14.0, color: primaryColor),
        ),
        cardTheme: const CardTheme(clipBehavior: Clip.none),
        listTileTheme: const ListTileThemeData());

    return MaterialApp(
      navigatorObservers: [observer],
      debugShowCheckedModeBanner: false,
      theme: themeData,
      //home: const AuthGate(),
      initialRoute: '/',
      onGenerateRoute: (settings) => RouterNavigator.generateRoute(settings),
    );
  }
}
