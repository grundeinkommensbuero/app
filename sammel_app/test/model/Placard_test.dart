import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Placard.dart';

void main() {
  group('deserialises', () {
    test('Placard without id', () {
      expect(
          jsonEncode(Placard(null, 52.472246, 13.327783, '12161, Friedrich-Wilhelm-Platz 57', 13).toJson()),
          '{'
          '"id":null,'
          '"latitude":52.472246,'
          '"longitude":13.327783,'
          '"adresse":"12161, Friedrich-Wilhelm-Platz 57",'
          '"benutzer":13'
          '}');
    });

    test('filled Placard', () {
      expect(
          jsonEncode(Placard(1, 52.472246, 13.327783,
                  '12161, Friedrich-Wilhelm-Platz 57', 11)
              .toJson()),
          '{'
          '"id":1,'
          '"latitude":52.472246,'
          '"longitude":13.327783,'
          '"adresse":"12161, Friedrich-Wilhelm-Platz 57",'
          '"benutzer":11'
          '}');
    });
  });

  group('deserialises', () {
    test('empty user', () {
      Placard user = Placard.fromJson(jsonDecode('{'
          '"id":null,'
          '"latitude":null,'
          '"longitude":null,'
          '"adresse":null,'
          '"benutzer":null'
          '}'));

      expect(user.id, isNull);
      expect(user.latitude, isNull);
      expect(user.longitude, isNull);
      expect(user.adresse, isNull);
      expect(user.benutzer, isNull);

      user = Placard.fromJson(jsonDecode('{'
          '"id":0,'
          '"latitude":null,'
          '"longitude":null,'
          '"adresse":"",'
          '"benutzer":0'
          '}'));

      expect(user.id, 0);
      expect(user.latitude, isNull);
      expect(user.longitude, isNull);
      expect(user.adresse, '');
      expect(user.benutzer, 0);
    });

    test('filled user', () {
      Placard user = Placard.fromJson(jsonDecode('{'
          '"id":null,'
          '"latitude":null,'
          '"longitude":null,'
          '"adresse":null,'
          '"benutzer":null'
          '}'));

      expect(user.id, isNull);
      expect(user.latitude, isNull);
      expect(user.longitude, isNull);
      expect(user.adresse, isNull);
      expect(user.benutzer, isNull);

      user = Placard.fromJson(jsonDecode('{'
          '"id":1,'
          '"latitude":52.472246,'
          '"longitude":13.327783,'
          '"adresse":"12161, Friedrich-Wilhelm-Platz 57",'
          '"benutzer":11'
          '}'));

      expect(user.id, 1);
      expect(user.latitude, 52.472246);
      expect(user.longitude, 13.327783);
      expect(user.adresse, '12161, Friedrich-Wilhelm-Platz 57');
      expect(user.benutzer, 11);
    });
  });
}
