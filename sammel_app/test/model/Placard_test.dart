import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Placard.dart';
import 'package:sammel_app/shared/DeserialisationException.dart';

void main() {
  group('deserialises', () {
    test('Placard without id', () {
      expect(
          jsonEncode(Placard(null, 52.472246, 13.327783,
                  '12161, Friedrich-Wilhelm-Platz 57', 13, false)
              .toJson()),
          '{'
          '"id":null,'
          '"latitude":52.472246,'
          '"longitude":13.327783,'
          '"adresse":"12161, Friedrich-Wilhelm-Platz 57",'
          '"benutzer":13,'
          '"abgehangen":false'
          '***REMOVED***');
    ***REMOVED***);

    test('filled Placard', () {
      expect(
          jsonEncode(Placard(1, 52.472246, 13.327783,
                  '12161, Friedrich-Wilhelm-Platz 57', 11, false)
              .toJson()),
          '{'
          '"id":1,'
          '"latitude":52.472246,'
          '"longitude":13.327783,'
          '"adresse":"12161, Friedrich-Wilhelm-Platz 57",'
          '"benutzer":11,'
          '"abgehangen":false'
          '***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);

  group('deserialises', () {
    test('throws error on missing values', () {
      expect(
          () => Placard.fromJson(jsonDecode('{'
              '"id":null,'
              '"latitude":null,'
              '"longitude":null,'
              '"adresse":null,'
              '"benutzer":null,'
              '"abgehangen":null'
              '***REMOVED***')),
          throwsA((e) =>
              e is DeserialisationException &&
              e.message ==
                  'Fehlende Werte: latitude, longitude, adresse, benutzer, abgehangen'));
    ***REMOVED***);

    test('filled user', () {
      final user = Placard.fromJson(jsonDecode('{'
          '"id":1,'
          '"latitude":52.472246,'
          '"longitude":13.327783,'
          '"adresse":"12161, Friedrich-Wilhelm-Platz 57",'
          '"benutzer":11,'
          '"abgehangen":false'
          '***REMOVED***'));

      expect(user.id, 1);
      expect(user.latitude, 52.472246);
      expect(user.longitude, 13.327783);
      expect(user.adresse, '12161, Friedrich-Wilhelm-Platz 57');
      expect(user.benutzer, 11);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
