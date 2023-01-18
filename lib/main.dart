// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_gate.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = const Color(0xFF2963C8);
    const secondaryColor = const Color(0xFF218838);

    const warningColor = const Color(0xFFffc107);
    const negativeColor = const Color(0xFF651F06);
    const successColor = const Color(0xFF28a745);

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
        headline3: GoogleFonts.openSans(fontSize: 14.0, color: primaryColor),
        headline6: GoogleFonts.openSans(fontSize: 22.0, color: primaryColor),
        headline4: GoogleFonts.openSans(
            fontSize: 18.0, color: Colors.white, backgroundColor: primaryColor),
        headline5: GoogleFonts.openSans(fontSize: 32.0, color: secondaryColor),
        bodyText1: GoogleFonts.openSans(fontSize: 14.0),
        bodyText2: GoogleFonts.openSans(fontSize: 12.0, color: secondaryColor),
        caption: GoogleFonts.openSans(fontSize: 14.0, color: primaryColor),
      ),
      cardTheme: const CardTheme(clipBehavior: Clip.none),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const AuthGate(),
    );
  }
}
