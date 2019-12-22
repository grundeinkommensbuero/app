import 'package:flutter/material.dart';

class DweTheme {
  static final MaterialColor yellow = Colors.amber;
  static final MaterialAccentColor yellowLight = Colors.amberAccent;
  static final Color yellowBright = Color.fromARGB(255, 250, 250, 150);
  static final Color purple = Color.fromARGB(255, 149, 48, 118);
  static final Color purpleLight = Color.fromARGB(255, 129, 28, 98);

  static ThemeData themeData = ThemeData(
      primarySwatch: yellow,
      appBarTheme: AppBarTheme(
          // for AppBar
          color: yellow,
          textTheme: TextTheme(
              title: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20.0, color: purple),
              headline: TextStyle(color: purple))),
      dialogBackgroundColor: yellow,
      // for all dialogs
      buttonTheme: ButtonThemeData(
          // for buttons
          buttonColor: purple,
          textTheme: ButtonTextTheme.accent),
      accentIconTheme: IconThemeData(color: purple));
}
