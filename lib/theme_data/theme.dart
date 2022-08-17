import 'package:flutter/material.dart';
import '../constants.dart';

// The theme for DONE
class MyTheme {
  ThemeData themeData = ThemeData.dark().copyWith(
    // I could optionally use this, however I don't know how many
    // widgets use the canvas color
    // canvasColor: Colors.transparent,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: kScaffoldColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kTertiaryColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kTertiaryColor),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: kScaffoldColor,
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      horizontalTitleGap: 7,
      style: ListTileStyle.drawer,
      tileColor: kListTileColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kSecondaryColor,
    ),
  );
}
