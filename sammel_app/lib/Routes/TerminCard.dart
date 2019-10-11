import 'dart:convert';

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
    return Container(
        child: Column(children: [
      RaisedButton(
        color: termin.ende.isAfter(DateTime.now())
            ? Colors.amberAccent
            : _HELLGELB,
        child: Column(children: [
          Text('${termin.typ***REMOVED***',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 129, 28, 98))),
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
                    '${termin.ort.bezirk***REMOVED***, ${termin.ort.ort***REMOVED***',
                    style: style,
                    overflow: TextOverflow.clip,
                  ),
                  erzeugeDatumZeile(termin.beginn, termin.ende),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: termin.teilnehmer
                          .map((benutzer) => erzeugeTeilnehmerZeile(benutzer))
                          .toList()),
                ])),
          ]),
        ]),
        onPressed: () => {***REMOVED***,
      ),
      SizedBox(
        height: _PADDING,
      ),
    ]));
  ***REMOVED***

  Widget erzeugeTeilnehmerZeile(Benutzer benutzer) {
    return Row(
      children: <Widget>[
        Icon(Icons.supervised_user_circle),
        Text(' ${benutzer.name***REMOVED*** '),
      ],
    );
  ***REMOVED***

  Widget erzeugeDatumZeile(DateTime beginn, DateTime ende) {
    DateTime heuteNacht = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    String prefix = '';
    if (beginn.isAfter(heuteNacht.subtract(Duration(days: 1)))) {
      if (beginn.isBefore(heuteNacht)) {
        prefix = 'Heute, ';
      ***REMOVED*** else if (beginn.isBefore(heuteNacht.add(Duration(days: 1)))) {
        prefix = 'Morgen, ';
      ***REMOVED*** else {
        if (beginn.isBefore(heuteNacht.add(Duration(days: 7)))) {
          prefix = '${DateTimeHelfer.wochentag(beginn)***REMOVED***, ';
        ***REMOVED***
      ***REMOVED***
    ***REMOVED***
    return Text(''
        '$prefix'
        '${formatDate(beginn, [dd, '.', mm])***REMOVED*** '
        'um ${formatDate(beginn, [HH, ':', nn])***REMOVED*** Uhr, '
        '${ende.difference(beginn).inHours***REMOVED*** Stunden');
  ***REMOVED***
***REMOVED***
