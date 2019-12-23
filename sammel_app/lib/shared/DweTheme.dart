import 'package:flutter/material.dart';

class DweTheme {
  static final MaterialColor yellow = Colors.amber;
  static final MaterialAccentColor yellowLight = Colors.amberAccent;
  static final Color yellowBright = Color.fromARGB(255, 250, 250, 150);
  static final Color purple = Color.fromARGB(255, 149, 48, 118);
  static final Color purpleLight = Color.fromARGB(255, 129, 28, 98);

  static ThemeData themeData = ThemeData(
      // button text color
      primaryColor: yellow,
      accentColor: purple,
      appBarTheme: AppBarTheme(
          color: yellow,
          textTheme: TextTheme(
              title: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20.0, color: purple),
              headline: TextStyle(color: purple))),
      dialogBackgroundColor: yellowLight,
      buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(
              primary: purple,
              onPrimary: yellow,
              secondary: purple,
              onSecondary: yellowLight,
              surface: yellow,
              background: yellow,
              onError: yellow),
          buttonColor: purple,
          textTheme: ButtonTextTheme.primary),
      iconTheme: IconThemeData(color: purple));
}
