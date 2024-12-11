import 'package:flutter/material.dart';

// COLOR

const Color green = Color(0xFF0E2919);
const Color black = Color(0xFF17181A);
const Color white = Color(0xFFFFFFFF);
const Color blue = Color(0xFF0094FF);
const Color red = Color(0xFFFC4032);

const Color gray800 = Color(0xFF30313E);
const Color gray600 = Color(0xFF97989E);
const Color gray100 = Color(0xFFEBECED);

// TYPOGRAPHY

// TITLE
const TextStyle titleLarge = TextStyle(
  color: black,
  fontSize: 18,
  fontWeight: FontWeight.w600,
  letterSpacing: 0,
  height: 24 / 18,
);
const TextStyle titleMedium = TextStyle(
  color: black,
  fontSize: 16,
  fontWeight: FontWeight.w700,
  letterSpacing: 0,
  height: 20 / 16,
);
const TextStyle titleSmall = TextStyle(
  color: black,
  fontSize: 14,
  fontWeight: FontWeight.w600,
  letterSpacing: 0,
  height: 18 / 14,
);

// BODY
const TextStyle bodyLarge = TextStyle(
  color: black,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  letterSpacing: 0,
  height: 20 / 16,
);
const TextStyle bodySmall = TextStyle(
  color: black,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  letterSpacing: 0,
  height: 18 / 14,
);

// CAPTION
const TextStyle captionLarge = TextStyle(
  color: black,
  fontSize: 13,
  fontWeight: FontWeight.w500,
  letterSpacing: 0,
  height: 16 / 13,
);

final ThemeData theme = ThemeData(
  // For the sanity of the reader, make sure these properties are in the same
  // order in every place that they are separated by section comments (e.g.
  // GENERAL CONFIGURATION). Each section except for deprecations should be
  // alphabetical by symbol name.

  // GENERAL CONFIGURATION
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: gray600),
    border: OutlineInputBorder(),
  ),

  // COLOR
  colorSchemeSeed: green,
  scaffoldBackgroundColor: white,

  // TYPOGRAPHY & ICONOGRAPHY
  iconTheme: const IconThemeData(color: black),

  // COMPONENT THEMES
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    titleTextStyle: bodyLarge,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: white,
    contentTextStyle: captionLarge,
    behavior: SnackBarBehavior.floating,
  ),
  tabBarTheme: const TabBarTheme(
    indicatorColor: black,
    labelColor: black,
    unselectedLabelColor: gray600,
  ),
);
