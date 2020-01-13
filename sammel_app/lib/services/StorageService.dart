import 'dart:async';
import 'dart:convert';

import 'package:sammel_app/model/TermineFilter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> _prefs;

  Future<SharedPreferences> get prefs => _prefs.timeout(Duration(seconds: 5));

  static const String _ACTION = 'action';
  static const String _ACTIONLIST = 'actionlist';
  static const String _FILTER = 'filter';

  StorageService() {
    _prefs = SharedPreferences.getInstance();
  ***REMOVED***

  // Action Properties

  Future<bool> saveActionToken(String id, String token) => prefs
      .then((prefs) => prefs.setString('$_ACTION:$id', token))
      .whenComplete(() => markActionIdAsStored(id));

  Future<bool> deleteActionToken(String id) => prefs
      .then((prefs) => prefs.remove('$_ACTION:$id'))
      .whenComplete(() => unmarkActionIdAsStored(id));

  Future<String> loadActionToken(String id) =>
      prefs.then((prefs) => prefs.getString('$_ACTION:$id'));

  markActionIdAsStored(String id) => prefs.then((prefs) => _getActionList()
      .then((list) => prefs.setStringList(_ACTIONLIST, list..add(id))));

  unmarkActionIdAsStored(String id) => prefs.then((prefs) => _getActionList()
      .then((list) => prefs.setStringList(_ACTIONLIST, list..remove(id))));

  Future<List<String>> loadAllStoredActionIds() =>
      prefs.then((prefs) => prefs.getStringList(_ACTIONLIST));

  Future<List<String>> _getActionList() => _prefs.then((prefs) async {
        var list = await prefs.getStringList(_ACTIONLIST);
        return list != null ? list : [];
      ***REMOVED***);

  // Filter Properties

  Future<bool> saveFilter(TermineFilter filter) => prefs
      .then((prefs) => prefs.setString(_FILTER, jsonEncode(filter.toJson())));

  Future<TermineFilter> loadFilter() => prefs.then(
      (prefs) => TermineFilter.fromJSON(jsonDecode(prefs.getString(_FILTER))));
***REMOVED***
