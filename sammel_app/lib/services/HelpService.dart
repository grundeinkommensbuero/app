import 'package:flutter/widgets.dart';
import 'package:sammel_app/model/Help.dart';

class HelpService {
  static List<Help> helps = [
    Help(1, 'Erster Eintrag',
        Text('Dies ist der erste Eintrag und er ist sehr gut'),
        Text('Dies ist der erste Eintrag und er ist...'), ['Tag', 'Tag2']),
    Help(
        2,
        'Zweiter Eintrag',
        Text('Dies ist der zweite Eintrag und er ist noch besser'),
        Text('Dies ist der zweite Eintrag und er ist...'),
        ['Tag']),
    Help(3, 'Dritter Eintrag    ',
        Column(children: [
          Text('Dies ist der dritte Eintrag und er ist der beste. Außerdem hat er ein Bild:'),
          Image.asset('assets/images/dwe.png')]),
        Text('Dies ist der dritte Eintrag und er ist...'), ['Tag2'])
  ];
***REMOVED***
