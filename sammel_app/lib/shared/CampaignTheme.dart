import 'package:flutter/material.dart';

class CampaignTheme {
  static final Color primary = Color.fromARGB(255, 253, 216, 22);
  static final Color primaryLight = Color.fromARGB(255, 255, 230, 40);
  static final Color primaryBright = Color.fromARGB(255, 255, 255, 130);
  static final Color secondary = Color.fromARGB(255, 128, 28, 98);
  static final Color secondaryLight = Color.fromARGB(255, 149, 48, 118);
  static final MaterialStateProperty<Color> red =
      MaterialStateProperty.all(Color.fromARGB(255, 204, 36, 36));
  static final Color altPrimaryLight = Color.fromARGB(255, 213, 252, 207);
  static final Color altPrimary = Color.fromARGB(255, 125, 244, 107);
  static final Color altSecondaryLight = Color.fromARGB(255, 150, 200, 255);
  static final Color altSecondaryBright = Color.fromARGB(255, 220, 235, 255);
  static final Color disabled = Colors.black45;

  static ThemeData themeData = ThemeData(
    // button text color
    primaryColor: primary,
    accentColor: secondary,
    appBarTheme: AppBarTheme(
        color: primary,
        textTheme: TextTheme(
            headline6: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20.0, color: secondary),
            headline5: TextStyle(color: secondary))),
    dialogBackgroundColor: primaryLight,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(secondary),
    )),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith((state) =>
          state.contains(MaterialState.disabled)
              ? disabled
              : secondary),
    )),
    iconTheme: IconThemeData(color: secondary),
    fontFamily: 'Raleway',
  );

  static var menuCaption =
      TextStyle(fontSize: 20.0, color: secondary);
  static var menuCaptionSelected =
      TextStyle(fontSize: 20.0, color: primary);

  static Color actionColor(DateTime ende, bool owner, bool participant) {
    final past = ende.isBefore(DateTime.now());

    if (owner && past) return altSecondaryBright;
    if (owner) return altSecondaryLight;

    if (participant && past) return altPrimaryLight;
    if (participant) return altPrimary;

    if (past) return primaryBright;
    return primaryLight;
  ***REMOVED***

  static Color placardColor(bool owner) {
    if (owner) return altSecondaryLight;
    return secondaryLight;
  ***REMOVED***

  static final BoxDecoration background = BoxDecoration(
      image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Color.fromARGB(220, 255, 255, 250), BlendMode.srcOver),
          image: AssetImage('assets/images/housy_happy.png'),
          scale: 1.8,
          fit: BoxFit.none,
          alignment: Alignment.topCenter));

  static String actionUrl(int? id) =>
      'www.dwenteignen.de/die-sammel-app?aktion=$id';
***REMOVED***
