import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({***REMOVED***); //set values here
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  var service = StorageService();

  group('action tokens', () {
    test('are stored correctly', () async {
      var result = await service.saveActionToken('1', "123789456");

      expect(result, true);
      expect(_prefs.getString("action:1"), "123789456");
    ***REMOVED***);

    test('are read correctly', () async {
      await _prefs.setString('action:1', '123789456');

      var token = await service.loadActionToken('1');

      expect(token, '123789456');
    ***REMOVED***);

    test('are deleted correctly', () async {
      await _prefs.setString('action:1', '123789456');

      var result = await service.deleteActionToken('1');

      expect(result, true);
      expect(_prefs.getString("action:1"), null);
    ***REMOVED***);

    test('are marked as stored with saving', () async {
      var result = await service.saveActionToken('1', '123789456');

      expect(result, true);
      expect(_prefs.getStringList("actionlist"), containsAll(['1']));
    ***REMOVED***);

    test('are demarked as stored with deletion', () async {
      await _prefs.setString('action:1', '123789456');

      var result = await service.deleteActionToken('1');

      expect(result, true);
      expect(_prefs.getStringList("actionlist"), isEmpty);
    ***REMOVED***);

    tearDown(() {
      // Cleanup
      _prefs.remove("action:1");
      expect(_prefs.getString("action:1"), null);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
