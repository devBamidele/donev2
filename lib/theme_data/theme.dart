import 'package:flutter/material.dart';
import '../constants.dart';

/// Vital theme data
class MyTheme {
  ThemeData themeData = ThemeData.dark().copyWith(
    // canvasColor: Colors.transparent, => I could also use this
    popupMenuTheme: const PopupMenuThemeData(
      color: kPopUpColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
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
    timePickerTheme: TimePickerThemeData(
      helpTextStyle: const TextStyle(
        letterSpacing: 1.5,
        fontFamily: 'Asap',
        fontSize: 16,
      ),
      backgroundColor: kListTileColor,
      dayPeriodBorderSide: const BorderSide(style: BorderStyle.none),
      dialBackgroundColor: const Color(0xff2d2e4e),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      dayPeriodTextStyle: const TextStyle(
        fontFamily: 'Asap',
        fontSize: 18,
      ),
      hourMinuteTextStyle: const TextStyle(
        fontFamily: 'Asap',
        fontSize: 53,
      ),
      shape: kAlertShape,
    ),
  );
}
