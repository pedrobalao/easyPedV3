import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-specific colors that don't map to standard Material 3 ColorScheme tokens.
class AppColors {
  static const Color warningColor = Color(0xFFffc107);
  static const Color facebookBlue = Color(0xFF3b5998);
}

class Styles {
  static TextStyle title(BuildContext context) => GoogleFonts.openSans(
      fontSize: 42,
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w500);

  static TextStyle textStyle(BuildContext context) => TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.w500);

  static TextStyle noteStyle(BuildContext context) => GoogleFonts.openSans(
      fontSize: 12,
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w500);

  static TextStyle headLineStyle1(BuildContext context) =>
      GoogleFonts.openSans(
          fontSize: 18, color: Theme.of(context).colorScheme.onPrimary);
  static TextStyle headLineStyle2(BuildContext context) => TextStyle(
      fontSize: 21,
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.bold);
  static TextStyle headLineStyle3 =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle4 =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle5 =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle normalText(BuildContext context) => TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface);
}
