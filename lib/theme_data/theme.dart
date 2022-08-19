import 'package:flutter/material.dart';
import '../constants.dart';

// The theme for DONE
class MyTheme {
  ThemeData themeData = ThemeData.dark().copyWith(
    // canvasColor: Colors.transparent, => I could also use this
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: kListTileColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      errorStyle: TextStyle(
        color: kShadowColor,
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kShadowColor),
      ),
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
    dialogTheme: const DialogTheme(
      backgroundColor: kListTileColor,
      shape: kAlertShape,
      contentTextStyle: TextStyle(fontSize: 17),
      titleTextStyle: TextStyle(fontSize: 23),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kTertiaryColor,
      contentTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 17.5,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
      ),
    ),
  );
}
