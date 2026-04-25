import 'package:flutter/material.dart';

class AppLayout {
  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context, double pixels) {
    final x = getScreenHeight(context) / pixels;
    return getScreenHeight(context) / x;
  }

  static double getWidth(BuildContext context, double pixels) {
    final x = getScreenWidth(context) / pixels;
    return getScreenWidth(context) / x;
  }
}
