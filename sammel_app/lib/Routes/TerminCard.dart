import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/Benutzer.dart';
import 'package:sammel_app/shared/DateTimeHelfer.dart';

class TerminCard extends StatelessWidget {
  Termin termin;
  static const _PADDING = 5.0;
  static const _HELLGELB = Color.fromARGB(255, 250, 250, 150);
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );

  TerminCard(this.termin);

  build(context) {
    return Column(children: [
      RaisedButton(
        color: termin.ende.isAfter(DateTime.now())
            ? Colors.amberAccent
            : _HELLGELB,
        child: Column(children: [
          Text('Sammel-Termin',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 129, 28, 98))),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              'assets/images/sammel-termin.png',
              height: 40.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              erzeugeDatumZeile(termin.beginn, termin.ende),
              Text('${termin.ort.bezirk}, ${termin.ort.ort}', style: style),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: termin.teilnehmer
                      .map((benutzer) => erzeugeTeilnehmerZeile(benutzer))
                      .toList()),
            ]),
          ]),
        ]),
        onPressed: () => {},
      ),
      SizedBox(
        height: _PADDING,
      ),
    ]);
  }

  Widget erzeugeTeilnehmerZeile(Benutzer benutzer) {
    return Row(
      children: <Widget>[
        Icon(Icons.supervised_user_circle),
        Text(' ${benutzer.name}'),
      ],
    );
  }

  Widget erzeugeDatumZeile(DateTime beginn, DateTime ende) {
    DateTime heuteNacht = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    String prefix = '';
    if (beginn.isAfter(heuteNacht.subtract(Duration(days: 1)))) {
      if (beginn.isBefore(heuteNacht)) {
        prefix = 'Heute, ';
      } else if (beginn.isBefore(heuteNacht.add(Duration(days: 1)))) {
        prefix = 'Morgen, ';
      } else if (beginn.isBefore(heuteNacht.add(Duration(days: 7)))) {
        prefix = '${DateTimeHelfer.wochentag(beginn)}, ';
      }
    }
    return Text(''
        '${prefix}'
        '${formatDate(beginn, [dd, '.', mm])} '
        'um ${formatDate(beginn, [HH, ':', nn])} Uhr, '
        '${ende.difference(beginn).inHours} Stunden');
  }
}
