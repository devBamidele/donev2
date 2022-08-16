import 'package:flutter/material.dart';
import '../constants.dart';

// The theme for DONE
class MyTheme {
  ThemeData themeData = ThemeData.dark().copyWith(
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
