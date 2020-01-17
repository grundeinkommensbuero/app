import 'package:flutter/material.dart';

class DweTheme {
  static final Color yellow = Color.fromARGB(255, 255, 216, 0);
  static final Color yellowLight = Color.fromARGB(255, 255, 230, 40);
  static final Color yellowBright = Color.fromARGB(255, 255, 255, 130);
  static final Color purple = Color.fromARGB(255, 129, 28, 98);
  static final Color purpleLight = Color.fromARGB(255, 109, 8, 78);
  static final Color red = Color.fromARGB(255, 204, 36, 36);

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

***REMOVED***
