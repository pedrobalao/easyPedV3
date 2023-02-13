import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primary = const Color(0xFF2963C8);

class Styles {
  static Color primaryColor = primary;
  static Color textColor = const Color(0xFF3B3B3B);
  static Color bgColor = const Color(0xFFEEEDF2);
  static Color orangeColor = const Color(0xFFF37B67);
  static Color kakiColor = const Color(0xFFD2BDB6);

  static TextStyle title = GoogleFonts.openSans(
      fontSize: 42.0, color: bgColor, fontWeight: FontWeight.w500);

  static TextStyle textStyle =
      TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500);

  static TextStyle noteStyle = GoogleFonts.openSans(
      fontSize: 12.0, color: bgColor, fontWeight: FontWeight.w500);

  static TextStyle headLineStyle1 =
      GoogleFonts.openSans(fontSize: 18.0, color: Colors.white);
  static TextStyle headLineStyle2 =
      TextStyle(fontSize: 21, color: textColor, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle3 =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle4 =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle5 =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
}
