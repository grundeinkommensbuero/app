import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class TerminCard extends StatelessWidget {
  final Termin termin;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );

  final bool myAction;
  final bool participant;

  TerminCard(this.termin,
      [this.myAction = false, this.participant = false, Key key])
      : super(key: key);

  build(context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: DweTheme.actionColor(termin.ende, myAction, participant),
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
                    Text(
                      '${termin.typ}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 129, 28, 98)),
                    ),
                    SizedBox(width: 45.0)
                  ]),
                  Text(
                    erzeugeOrtText(termin.ort),
                    textAlign: TextAlign.start,
                    style: style,
                  ),
                  Text(
                    erzeugeDatumText(termin.beginn, termin.ende),
                    textAlign: TextAlign.start,
                  ),
                ])),
          ]),
    );
  }

  static String erzeugeOrtText(Kiez ort) {
    return '${ort.bezirk}, ${ort.kiez}';
  }

  static String erzeugeDatumText(DateTime beginn, DateTime ende) {
    return ''
        '${ermittlePrefix(beginn)}'
        '${formatDate(beginn, [dd, '.', mm, '.'])} '
        'um ${formatDate(beginn, [HH, ':', nn])} Uhr, '
        '${ende.difference(beginn).inHours} Stunde'
        '${ende.difference(beginn).inHours > 1 ? 'n' : ''}';
  }

  static String ermittlePrefix(DateTime beginn) {
    DateTime heuteNacht = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    String prefix = '';
    if (beginn.isAfter(heuteNacht.subtract(Duration(days: 1)))) {
      if (beginn.isBefore(heuteNacht)) {
        prefix = 'Heute, ';
      } else if (beginn.isBefore(heuteNacht.add(Duration(days: 1)))) {
        prefix = 'Morgen, ';
      } else {
        if (beginn.isBefore(heuteNacht.add(Duration(days: 7)))) {
          prefix = '${ChronoHelfer.wochentag(beginn)}, ';
        }
      }
    }
    return prefix;
  }
}
