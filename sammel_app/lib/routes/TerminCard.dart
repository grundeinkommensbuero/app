import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

class TerminCard extends StatelessWidget {
  final Termin termin;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );

  final bool myAction;
  final bool participant;

  TerminCard(this.termin,
      [this.myAction = false, this.participant = false, Key? key])
      : super(key: key);

  build(context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: CampaignTheme.actionColor(termin.ende, myAction, participant),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 1.0)
          ]),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              termin.getAsset(),
              width: 45.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                        child: Text(
                      '${termin.typ***REMOVED***',
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 129, 28, 98)),
                    ).tr()),
                    SizedBox(width: 45.0)
                  ]),
                  Text(
                    erzeugeOrtText(termin.ort),
                    textAlign: TextAlign.start,
                    style: style,
                  ),
                  Text(
                    erzeugeDatumText(termin.beginn, termin.ende,
                        Localizations.localeOf(context)),
                    textAlign: TextAlign.start,
                  ),
                ])),
          ]),
    );
  ***REMOVED***

  static String erzeugeOrtText(Kiez ort) {
    return '${ort.region***REMOVED***, ${ort.name***REMOVED***';
  ***REMOVED***

  static String erzeugeDatumText(
      DateTime beginn, DateTime ende, Locale locale) {
    return '{prefix***REMOVED***{date***REMOVED*** um {zeit***REMOVED*** Uhr, '.tr(namedArgs: {
          'prefix': ermittlePrefix(beginn, locale),
          'date': DateFormat.MMMd(locale.languageCode).format(beginn),
          'zeit': DateFormat.Hm(locale.languageCode).format(beginn),
        ***REMOVED***) +
        (ende.difference(beginn).inHours < 1
            ? '< ' + '{***REMOVED*** Stunden'.plural(1)
            : '{***REMOVED*** Stunden'.plural(ende.difference(beginn).inHours));
  ***REMOVED***

  static String ermittlePrefix(DateTime beginn, Locale locale) {
    DateTime heuteNacht = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    String prefix = '';
    if (beginn.isAfter(heuteNacht.subtract(Duration(days: 1)))) {
      if (beginn.isBefore(heuteNacht)) {
        prefix = 'Heute, '.tr();
      ***REMOVED*** else if (beginn.isBefore(heuteNacht.add(Duration(days: 1)))) {
        prefix = 'Morgen, '.tr();
      ***REMOVED*** else {
        if (beginn.isBefore(heuteNacht.add(Duration(days: 7)))) {
          prefix = '${DateFormat.EEEE(locale.languageCode).format(beginn)***REMOVED***, ';
        ***REMOVED***
      ***REMOVED***
    ***REMOVED***
    return prefix;
  ***REMOVED***
***REMOVED***
