import 'package:flutter/material.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/Benutzer.dart';
import '../services/TermineService.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
}

class _TermineSeiteState extends State<TermineSeite> {
  static final TextStyle style = TextStyle(
    color: Colors.deepPurpleAccent,
    fontSize: 15.0,
  );
  static double _padding = 5.0;
  static final _termineService = TermineService();
  List<Termin> termine = [
    Termin(100, DateTime(2020, 5, 6, 12, 8, 0), DateTime(2020, 5, 6, 12, 8, 0),
        Ort(8, 'Dummy-Bezirk', 'Dummy-Ort'), [])
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Memory-Leak beheben
    _termineService.ladeTermine().asStream().forEach((termine) => {
          setState(() {
            this.termine = termine;
          })
        });
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: style,
          ),
        ),
        body: Center(
            child: ListView(
                children:
                    termine.map((termin) => erzeugeKarte(termin)).toList())));
  }

  Column erzeugeKarte(Termin termin) {
    return Column(children: [
      RaisedButton(
        color: Colors.amberAccent,
        child: Column(children: [
          Text('Termin',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent)),
          Text(
              'am ${formatiereDatum(termin.beginn)} von ${formatiereZeit(termin.beginn)} bis ${formatiereZeit(termin.ende)}'),
          Row(
            children: <Widget>[
              Text('Ort: ', style: style),
              Text('${termin.ort.bezirk}, ${termin.ort.ort}', style: style)
            ],
          ),
          Column(
              children: termin.teilnehmer
                  .map((benutzer) => erzeugeTeilnehmerZeile(benutzer))
                  .toList())
        ]),
        onPressed: () => {},
      ),
      SizedBox(
        height: _padding,
      ),
    ]);
  }

  String formatiereZeit(DateTime datetime) {
    return '${datetime.hour}:${datetime.minute}';
  }

  Widget erzeugeTeilnehmerZeile(Benutzer benutzer) {
    return Row(
      children: <Widget>[
        Icon(Icons.supervised_user_circle),
        Text(benutzer.name)
      ],
    );
  }

  String formatiereDatum(DateTime datetime) =>
      '${wochentag(datetime)}, ${datetime.day}.${datetime.month}';

  String wochentag(DateTime datetime) {
    switch (datetime.weekday) {
      case 1:
        return 'Montag';
      case 2:
        return 'Dienstag';
      case 3:
        return 'Mittwoch';
      case 4:
        return 'Donnerstag';
      case 5:
        return 'Freitag';
      case 6:
        return 'Samstag';
      case 7:
        return 'Sonntag';
    }
  }
}
