import 'package:flutter/material.dart';

const appMainFont = 'Poppins';

TextStyle displayLarge = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w600,
    fontSize: 28.0,
    height: 1.43);

TextStyle displayMedium = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    height: 1.4);

TextStyle displaySmall = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w600,
    fontSize: 15.0,
    height: 2.2);

TextStyle headlineMedium = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w600,
    fontSize: 14.0,
    height: 3);

TextStyle headlineSmall = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    height: 3);

TextStyle titleLarge = const TextStyle(
    fontFamily: appMainFont, fontWeight: FontWeight.w600, fontSize: 16.0);

TextStyle bodyMedium = const TextStyle(
    fontFamily: appMainFont, fontWeight: FontWeight.w400, fontSize: 14.0);

TextStyle bodyLarge = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w600,
    fontSize: 19.0,
    height: 3);

TextStyle bodySmall = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    height: 1.6);

TextStyle labelSmall = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    height: 1.6,
    letterSpacing: -.5);

TextStyle button = const TextStyle(
    fontFamily: appMainFont,
    fontWeight: FontWeight.w600,
    fontSize: 10.0,
    height: 1.8);

TextTheme appTextTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    bodyMedium: bodyMedium,
    bodyLarge: bodyLarge,
    labelSmall: labelSmall,
    bodySmall: bodySmall,
    labelLarge: button);
