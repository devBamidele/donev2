import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackbar(String? text, {int delay = 1500}) {
    if (text == null) return;

    final snackBar = SnackBar(
      duration: Duration(milliseconds: delay),
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
