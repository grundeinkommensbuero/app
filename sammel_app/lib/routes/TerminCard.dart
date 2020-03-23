import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Ort.dart';
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

  TerminCard(this.termin, [this.myAction = false, Key key])
      : super(key: key);

  build(context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: DweTheme.actionColor(termin.ende, myAction),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 1.0)
          ]),
      child: Column(children: [
        Text(
          '${termin.typ}',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 129, 28, 98)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            termin.getAsset(),
            height: 40.0,
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  erzeugeOrtText(termin.ort),
                  style: style,
                ),
                Text(erzeugeDatumText(termin.beginn, termin.ende)),
              ])),
        ]),
      ]),
    );
  }

  static String erzeugeOrtText(Ort ort) {
    return '${ort.bezirk}, ${ort.ort}';
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
