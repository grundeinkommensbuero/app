import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/TestdatenVorrat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({***REMOVED***); //set values here
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  var service = StorageService();

  setUp(() => _prefs.clear());

  group('action tokens', () {
    test('are stored correctly', () async {
      var result = await service.saveActionToken(1, "123789456");

      expect(result, true);
      expect(_prefs.containsKey('action:1'), true);
      expect(_prefs.getString("action:1"), "123789456");
    ***REMOVED***);

    test('are read correctly', () async {
      await _prefs.setString('action:1', '123789456');

      var token = await service.loadActionToken(1);

      expect(token, '123789456');
    ***REMOVED***);

    test('are deleted correctly', () async {
      await _prefs.setString('action:1', '123789456');

      var result = await service.deleteActionToken(1);

      expect(result, true);
      expect(_prefs.getString("action:1"), null);
    ***REMOVED***);

    test('are marked as stored with saving', () async {
      var result = await service.saveActionToken(1, '123789456');

      expect(result, true);
      expect(_prefs.containsKey('actionlist'), true);
      expect(_prefs.getStringList("actionlist"), containsAll(['1']));
    ***REMOVED***);

    test('are demarked as stored with deletion', () async {
      await _prefs.setString('action:1', '123789456');

      var result = await service.deleteActionToken(1);

      expect(result, true);
      expect(_prefs.getStringList("actionlist"), isEmpty);
    ***REMOVED***);

    test('loadAllStoredActionIds returns saved ids as integers', () async {
      await _prefs.setStringList('actionlist', ['1', '2', '3']);

      var list = await service.loadAllStoredActionIds();

      expect(list, containsAll([1, 2, 3]));
    ***REMOVED***);

    test('loadAllStoredActionIds returns empty list if storage empty',
        () async {
      await _prefs.setStringList('actionlist', null);

      var list = await service.loadAllStoredActionIds();

      expect(list, []);
    ***REMOVED***);
  ***REMOVED***);

  group('Filter', () {
    test('is stored correctly', () async {
      TermineFilter filter = TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [ffAlleeNord().name, tempVorstadt().name]);

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
      expect(filterFromStorage.orte,
          containsAll(['Frankfurter Allee Nord', 'Tempelhofer Vorstadt']));
    ***REMOVED***);

    test('is read correctly', () async {
      TermineFilter filter = TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [ffAlleeNord().name, tempVorstadt().name]);
      _prefs.setString('filter', jsonEncode(filter.toJson()));

      TermineFilter readFilter = await service.loadFilter();

      expect(readFilter, isNotNull);
      expect(readFilter.typen, containsAll(['Sammeln', 'Infoveranstaltung']));
      expect(readFilter.tage.length, 2);
      expect(readFilter.tage,
          containsAll([DateTime(2020, 1, 14), DateTime(2020, 1, 16)]));
      expect(readFilter.von, TimeOfDay(hour: 12, minute: 30));
      expect(readFilter.bis, TimeOfDay(hour: 15, minute: 0));
      expect(readFilter.orte,
          containsAll(['Frankfurter Allee Nord', 'Tempelhofer Vorstadt']));
    ***REMOVED***);

    test('loads empty filter if none is stored', () async {
      TermineFilter(
          ['Sammeln', 'Infoveranstaltung'],
          [DateTime(2020, 1, 14), DateTime(2020, 1, 16)],
          TimeOfDay(hour: 12, minute: 30),
          TimeOfDay(hour: 15, minute: 0),
          [ffAlleeNord().name, tempVorstadt().name]);
      _prefs.clear();

      TermineFilter readFilter = await service.loadFilter();

      expect(readFilter, isNotNull);
      expect(readFilter.typen, []);
      expect(readFilter.tage.length, 0);
      expect(readFilter.von, null);
      expect(readFilter.bis, null);
      expect(readFilter.orte.length, 0);
    ***REMOVED***);
  ***REMOVED***);

  group('secret', () {
    test('is stored correctly', () async {
      await service.saveSecret("123789456");

      expect(_prefs.containsKey('secret'), true);
      expect(_prefs.getString("secret"), "123789456");
    ***REMOVED***);

    test('is read correctly', () async {
      await _prefs.setString('secret', '123789456');

      var secret = await service.loadSecret();

      expect(secret, '123789456');
    ***REMOVED***);

    test('waits until stored', () async {
      Future.delayed(Duration(seconds: 1))
          .then((value) => _prefs.setString('secret', '123789456'));

      var secret = await service.loadSecret();

      expect(secret, '123789456');
    ***REMOVED***);
  ***REMOVED***);

  group('costum push token', () {
    test('is stored correctly', () async {
      await service.saveCostumPushToken("123789456");

      expect(_prefs.containsKey('pushToken'), true);
      expect(_prefs.getString("pushToken"), "123789456");
    ***REMOVED***);

    test('is read correctly', () async {
      await _prefs.setString('pushToken', '123789456');

      var token = await service.loadCostumPushToken();

      expect(token, '123789456');
    ***REMOVED***);
  ***REMOVED***);

  group('user', () {
    test('saveUser saves user to storage', () async {
      await service.saveUser(karl());

      expect(_prefs.getString('user'),
          '{"id":11,"name":"Karl Marx","color":4294198070***REMOVED***');
    ***REMOVED***);

    test('loadUser loads user from storage', () async {
      _prefs.setString(
          'user', '{"id":11,"name":"Karl Marx","color":4294198070***REMOVED***');

      var user = await service.loadUser();

      expect(user.id, 11);
      expect(user.name, 'Karl Marx');
      expect(user.color.value, 4294198070);
    ***REMOVED***);

    test('loadUser returns null if no user stored', () async {
      _prefs.remove('user');

      var user = await service.loadUser();

      expect(user, null);
    ***REMOVED***);
  ***REMOVED***);

  group('pullMode', () {
    test('markPullMode sets pullMode to true', () async {
      await service.markPullMode();

      expect(_prefs.getBool('pullMode'), true);
    ***REMOVED***);

    test('isPullMode returns false, if not set', () async {
      var result = await service.isPullMode();

      expect(result, false);
    ***REMOVED***);

    test('isPullMode returns false, if not set', () async {
      _prefs.setBool('pullMode', true);

      var result = await service.isPullMode();

      expect(result, true);
    ***REMOVED***);
  ***REMOVED***);

  group('contact', () {
    test('is stored correctly', () async {
      expect(_prefs.containsKey('contact'), false);

      await service.saveContact("Ick bin ein Berliner");

      expect(_prefs.containsKey('contact'), true);
      expect(_prefs.getString("contact"), "Ick bin ein Berliner");
    ***REMOVED***);

    test('is read correctly', () async {
      await _prefs.setString('contact', 'Ick bin ein Berliner');

      var secret = await service.loadContact();

      expect(secret, 'Ick bin ein Berliner');
    ***REMOVED***);
  ***REMOVED***);

  test('clearAllPreferences clears whole storage', () async {
    _prefs.setString('user', '{"id":11,"name":"Karl Marx","color":4294198070***REMOVED***');
    _prefs.setStringList('actionlist', ['1', '2', '3']);
    _prefs.setInt('anyInt', 1);
    _prefs.setBool('anyBool', true);
    _prefs.setDouble('anyDouble', 1.0);

    await service.clearAllPreferences();

    expect(_prefs.getString('user'), null);
    expect(_prefs.getStringList('actionlist'), null);
    expect(_prefs.getInt('anyInt'), null);
    expect(_prefs.getBool('anyBool'), null);
    expect(_prefs.getDouble('anyDouble'), null);
  ***REMOVED***);

  tearDown(() async {
    await service.clearAllPreferences();
  ***REMOVED***);
***REMOVED***
