import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme/custom_theme_colors.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

ThemeData light = ThemeData(
  fontFamily: 'Rubik',
  primaryColor: const Color.fromRGBO(255, 0, 0, 1),
  // primaryColor: const Color(0xFFFC6A57),
  //#FF5555
  secondaryHeaderColor: const Color(0xff04B200),
  brightness: Brightness.light,
  cardColor: Colors.white,
  hintColor: const Color(0xFF9F9F9F),
  disabledColor: const Color(0xFFBABFC4),
  shadowColor: Colors.grey[300],
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),

  popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),

  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.light(),
  ],

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color.fromRGBO(255, 0, 0, 1),
    onPrimary: const Color.fromRGBO(255, 0, 0, 1),
    secondary: const Color(0xff04B200),
    onSecondary: const Color(0xFFEFE6FE),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface: const Color(0xFF002349),
    shadow: Colors.grey[300],
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontWeight: FontWeight.w300, fontSize: Dimensions.fontSizeDefault),
    displayMedium: TextStyle(
        fontWeight: FontWeight.w400, fontSize: Dimensions.fontSizeDefault),
    displaySmall: TextStyle(
        fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeDefault),
    headlineMedium: TextStyle(
        fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.w700, fontSize: Dimensions.fontSizeDefault),
    titleLarge: TextStyle(
        fontWeight: FontWeight.w800, fontSize: Dimensions.fontSizeDefault),
    bodySmall: TextStyle(
        fontWeight: FontWeight.w900, fontSize: Dimensions.fontSizeDefault),
    titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
  tabBarTheme: const TabBarThemeData(indicatorColor: Color(0xFF1981E0)),
);
