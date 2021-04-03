import 'package:flutter/material.dart';

class DweTheme {
  static final Color yellow = Color.fromARGB(255, 253, 216, 22);
  static final Color yellowLight = Color.fromARGB(255, 255, 230, 40);
  static final Color yellowBright = Color.fromARGB(255, 255, 255, 130);
  static final Color purple = Color.fromARGB(255, 128, 28, 98);
  static final Color purpleLight = Color.fromARGB(255, 149, 48, 118);
  static final MaterialStateProperty<Color> red =
      MaterialStateProperty.all(Color.fromARGB(255, 204, 36, 36));
  static final Color greenLight = Color.fromARGB(255, 213, 252, 207);
  static final Color green = Color.fromARGB(255, 125, 244, 107);
  static final Color blueLight = Color.fromARGB(255, 150, 200, 255);
  static final Color blueBright = Color.fromARGB(255, 220, 235, 255);
  static final Color disabledGrey = Colors.black45;

  static ThemeData themeData = ThemeData(
    // button text color
    primaryColor: yellow,
    accentColor: purple,
    appBarTheme: AppBarTheme(
        color: yellow,
        textTheme: TextTheme(
            headline6: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20.0, color: purple),
            headline5: TextStyle(color: purple))),
    dialogBackgroundColor: yellowLight,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(DweTheme.purple),
    )),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith((state) =>
          state.contains(MaterialState.disabled)
              ? DweTheme.disabledGrey
              : DweTheme.purple),
    )),
    iconTheme: IconThemeData(color: purple),
    fontFamily: 'Raleway',
  );

  static var menuCaption = TextStyle(fontSize: 20.0, color: DweTheme.purple);
  static var menuCaptionSelected =
      TextStyle(fontSize: 20.0, color: DweTheme.yellow);

  static Color actionColor(DateTime ende, bool owner, bool participant) {
    final past = ende.isBefore(DateTime.now());

    if (owner && past) return DweTheme.blueBright;
    if (owner) return DweTheme.blueLight;

    if (participant && past) return DweTheme.greenLight;
    if (participant) return DweTheme.green;

    if (past) return yellowBright;
    return yellowLight;
  ***REMOVED***

  static final BoxDecoration happyHouseBackground = BoxDecoration(
      image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Color.fromARGB(220, 255, 255, 250), BlendMode.srcOver),
          image: AssetImage('assets/images/housy_happy.png'),
          scale: 1.8,
          fit: BoxFit.none,
          alignment: Alignment.topCenter));
***REMOVED***
