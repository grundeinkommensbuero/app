import 'dart:async';
import 'dart:convert';

import 'package:sammel_app/model/TermineFilter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> _prefs;

  Future<SharedPreferences> get prefs => _prefs.timeout(Duration(seconds: 5));

  static String _ACTION = 'action';
  static String _ACTIONLIST = 'actionlist';
  static String _FILTER = 'filter';

  StorageService() {
    _prefs = SharedPreferences.getInstance();
  }

//      .catchError((Object error) => print/*StorageAccessError()*/);

  // Action Properties

  Future<bool> saveActionToken(String id, String token) => prefs
      .then((prefs) => prefs.setString('$_ACTION:$id', token))
      .whenComplete(() => markActionIdAsStored(id));

  Future<bool> deleteActionToken(String id) => prefs
      .then((prefs) => prefs.remove('$_ACTION:$id'))
      .whenComplete(() => markActionIdAsRemoved(id));

  Future<String> loadActionToken(String id) =>
      prefs.then((prefs) => prefs.getString('$_ACTION:$id'));

//      .catchError((anyException) => throw (StorageLoadError('Aktion $id')));

  markActionIdAsStored(String id) => prefs.then((prefs) => prefs.setStringList(
      _ACTIONLIST, prefs.getStringList(_ACTIONLIST)..add(id)));

//      .catchError((anyException) => throw (StorageLoadError('Aktion $id')));

  markActionIdAsRemoved(String id) => prefs.then((prefs) => prefs.setStringList(
      _ACTIONLIST, prefs.getStringList(_ACTIONLIST)..remove(id)));

//      .catchError((anyException) => throw (StorageDeleteError('Aktion $id')));

  Future<List<String>> loadAllStoredActionIds() =>
      prefs.then((prefs) => prefs.getStringList(_ACTIONLIST));

//      .catchError((anyException) => throw (StorageLoadError('Aktionen-Liste')));

  // Filter Properties

  Future<bool> saveFilter(TermineFilter filter) => prefs
      .then((prefs) => prefs.setString(_FILTER, jsonEncode(filter.toJson())));

//      .catchError((anyException) => throw (StorageLoadError('Filter')));

  Future<TermineFilter> loadFilterTypes() => prefs.then(
      (prefs) => TermineFilter.fromJSON(jsonDecode(prefs.getString(_FILTER))));
//      .catchError((anyException) => throw (StorageLoadError('Filter')));
}

class StorageAccessError extends Error {
  String message = 'Der Speicher des Geräts ist nicht verfügbar';

  StorageAccessError();
}

class StorageLoadError extends Error {
  String message;

  StorageLoadError(String type) {
    this.message = '$type konnte nicht im Gerätespeicher gefunden werden.';
  }
}

class StorageDeleteError extends Error {
  String message;

  StorageDeleteError(String type) {
    this.message = '$type konnte nicht aus dem Gerätespeicher gelöscht werden.';
  }
}
