import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({}); //set values here
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  var service = StorageService();

  group('action tokens', () {
    test('are stored correctly', () async {
      var result = await service.saveActionToken(1, "123789456");

      expect(result, true);
      expect(_prefs.containsKey('action:1'), true);
      expect(_prefs.getString("action:1"), "123789456");
    });

    test('are read correctly', () async {
      await _prefs.setString('action:1', '123789456');

      var token = await service.loadActionToken(1);

      expect(token, '123789456');
    });

    test('are deleted correctly', () async {
      await _prefs.setString('action:1', '123789456');

      var result = await service.deleteActionToken(1);

      expect(result, true);
      expect(_prefs.getString("action:1"), null);
    });

    test('are marked as stored with saving', () async {
      var result = await service.saveActionToken(1, '123789456');

      expect(result, true);
      expect(_prefs.containsKey('actionlist'), true);
      expect(_prefs.getStringList("actionlist"), containsAll(['1']));
    });

    test('are demarked as stored with deletion', () async {
      await _prefs.setString('action:1', '123789456');

      var result = await service.deleteActionToken(1);

      expect(result, true);
      expect(_prefs.getStringList("actionlist"), isEmpty);
    });

    tearDown(() {
      // Cleanup
      _prefs.remove("action:1");
      expect(_prefs.getString("action:1"), null);
    });
  });

  group('Filter', () {
    test('is stored correctly', () async {
      TermineFilter filter = TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [
            Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
                52.51579, 13.45399),
            Ort(2, 'Friedrichshain-Kreuzberg', 'Görlitzer Park und Umgebung',
                52.49653, 13.43762)
          ]);

      var result = await service.saveFilter(filter);

      expect(result, true);
      expect(_prefs.containsKey('filter'), true);
      var storedString = _prefs.getString('filter');
      var filterFromStorage = TermineFilter.fromJSON(jsonDecode(storedString));
      expect(filterFromStorage.typen,
          containsAll(['Sammeln', 'Infoveranstaltung']));
      expect(filterFromStorage.tage.length, 2);
      expect(filterFromStorage.tage,
          containsAll([DateTime(2020, 1, 14), DateTime(2020, 1, 16)]));
      expect(filterFromStorage.von, TimeOfDay(hour: 12, minute: 30));
      expect(filterFromStorage.bis, TimeOfDay(hour: 15, minute: 0));
      expect(
          filterFromStorage.orte.map((ort) => ort.toJson()),
          containsAll([
            {
              'id': 1,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Friedrichshain Nordkiez'
            },
            {
              'id': 2,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Görlitzer Park und Umgebung'
            }
          ]));
    });

    test('is read correctly', () async {
      TermineFilter filter = TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [
            Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
                52.51579, 13.45399),
            Ort(2, 'Friedrichshain-Kreuzberg', 'Görlitzer Park und Umgebung',
                52.49653, 13.43762)
          ]);
      _prefs.setString('filter', jsonEncode(filter.toJson()));

      TermineFilter readFilter = await service.loadFilter();

      expect(readFilter, isNotNull);
      expect(readFilter.typen, containsAll(['Sammeln', 'Infoveranstaltung']));
      expect(readFilter.tage.length, 2);
      expect(readFilter.tage,
          containsAll([DateTime(2020, 1, 14), DateTime(2020, 1, 16)]));
      expect(readFilter.von, TimeOfDay(hour: 12, minute: 30));
      expect(readFilter.bis, TimeOfDay(hour: 15, minute: 0));
      expect(
          readFilter.orte.map((ort) => ort.toJson()),
          containsAll([
            {
              'id': 1,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Friedrichshain Nordkiez'
            },
            {
              'id': 2,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Görlitzer Park und Umgebung'
            }
          ]));
    });

    test('loads empty filter if none is stored', () async {
      TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [
            Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
                52.51579, 13.45399),
            Ort(2, 'Friedrichshain-Kreuzberg', 'Görlitzer Park und Umgebung',
                52.49653, 13.43762)
          ]);
      _prefs.clear();

      TermineFilter readFilter = await service.loadFilter();

      expect(readFilter, isNotNull);
      expect(readFilter.typen, []);
      expect(readFilter.tage.length, 0);
      expect(readFilter.von, null);
      expect(readFilter.bis, null);
      expect(readFilter.orte.length, 0);
    });
  });
}
