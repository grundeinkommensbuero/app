import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

class TerminDetailsWidget extends StatelessWidget {
  Termin termin;

  TerminDetailsWidget(this.termin);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image.asset(termin.getAsset(), width: 30.0),
        Text(termin.typ,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Color.fromARGB(255, 129, 28, 98))),
        Container(width: 20.0)
      ]),
      SizedBox(
        height: 20.0,
      ),

      // Location
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.location_searching, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wo? ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(termin.ort.bezirk),
          Row(children: [
            Icon(
              Icons.subdirectory_arrow_right,
              size: 20.0,
            ),
            Text(termin.ort.ort),
          ]),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 40.0, maxWidth: 250.0),
              child:
                  SingleChildScrollView(child: Text('Treffpunkt: Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter')))
        ])
      ]),
      SizedBox(
        height: 10.0,
      ),

      // Time
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.access_time, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wann?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(formatiereDatum(termin.beginn)),
          Text(formatiereUhrzeit(termin.beginn, termin.ende))
        ])
      ]),
      SizedBox(
        height: 10.0,
      ),

      // Description
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.info_outline, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150.0, maxWidth: 250.0),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    'Was?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Column(children: [Text(' Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter   Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter')]))
                ])))
      ]),
      SizedBox(
        height: 10.0,
      ),

      // Contact
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.face, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wer?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 105.0, maxWidth: 250.0),
              child: SingleChildScrollView(
                  child: Text(
                ' Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter Platzhalter',
              )))
        ])
      ]),
    ]);
  ***REMOVED***

  String formatiereDatum(DateTime date) {
    return ChronoHelfer.wochentag(date) +
        ', ' +
        date.day.toString() +
        '. ' +
        ChronoHelfer.monthName(date.month) +
        ' ' +
        date.year.toString();
  ***REMOVED***

  String formatiereUhrzeit(DateTime start, DateTime end) =>
      'von ' +
      ChronoHelfer.dateTimeToStringHHmm(start) +
      ' bis ' +
      ChronoHelfer.dateTimeToStringHHmm(end);
***REMOVED***
