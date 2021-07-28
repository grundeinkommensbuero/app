import 'package:flutter/material.dart';

class CampaignTheme {
  static final Color primary = Color.fromRGBO(255, 255, 255, 1);
  static final Color primaryLight = Color.fromRGBO(236, 234, 247, 1);
  static final Color primaryBright = Color.fromRGBO(255, 255, 255, 1);
  static final Color secondary = Color.fromRGBO(120, 95, 255, 1);
  static final Color secondaryLight = Color.fromRGBO(174, 159, 255, 1);
  static final MaterialStateProperty<Color> red =
      MaterialStateProperty.all(Color.fromRGBO(255, 70, 100, 1));
  //static final Color altPrimaryLight = Color.fromRGBO(255, 70, 100, 0.8);
  // static final Color altPrimary = Color.fromRGBO(255, 70, 100, 1);
  static final Color altPrimary = Color.fromRGBO(70, 180, 180, 1);
  static final Color altPrimaryLight = Color.fromRGBO(144, 210, 210, 1);
  static final Color altSecondaryLight = Color.fromRGBO(229, 181, 200, 1);
  static final Color altSecondaryBright = Color.fromRGBO(229, 181, 200, 1);
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
    fontFamily: 'Ideal',
  );

  static var menuCaption =
      TextStyle(fontSize: 20.0, color: secondary);
  static var menuCaptionSelected =
      TextStyle(fontSize: 20.0, color: primary);

  static Color actionColor(DateTime ende, bool owner, bool participant) {
    final past = ende.isBefore(DateTime.now());

    if(past) return primaryLight;

    // if (owner && past) return CampaignTheme.altSecondaryBright;
    // Proposition Tatiana: white on green
    if (owner) return altPrimary;

    // Proposition Tatiana: white on blue
    // if (participant && past) return CampaignTheme.altPrimaryLight;
    if (participant) return secondary;

    return primary;
  ***REMOVED***

  static Color actionColorText(bool owner, bool participant){
    if(owner || participant) return primary;

    return Colors.black54;
  ***REMOVED***

  static Color actionColorHeading(bool owner, bool participant){
    if(owner || participant) return CampaignTheme.primary;

    return secondary;
  ***REMOVED***

  static Color placardColor(bool owner) {
    if (owner) return altSecondaryLight;
    return Colors.transparent;
  ***REMOVED***

  static final BoxDecoration background = BoxDecoration(
      image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Color.fromARGB(220, 255, 255, 250), BlendMode.srcOver),
          image: AssetImage('assets/images/keyvisual.png'),
          scale: 1.8,
          fit: BoxFit.none,
          alignment: Alignment.topCenter));

  static String actionUrl(int? id) =>
      'www.dwenteignen.de/die-sammel-app?aktion=$id';
***REMOVED***
