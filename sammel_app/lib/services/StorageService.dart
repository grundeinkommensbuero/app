import 'dart:async';
import 'dart:convert';

import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/shared/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> _prefs;

  Future<SharedPreferences> get prefs => _prefs.timeout(Duration(seconds: 5));

  static const String _ACTION = 'action';
  static const String _ACTIONLIST = 'actionlist';
  static const String _FILTER = 'filter';
  static const String _USER = 'user';

  StorageService() {
    _prefs = SharedPreferences.getInstance();
  }

  // Action Properties

  Future<bool> saveActionToken(int id, String token) => prefs
      .then((prefs) => prefs.setString('$_ACTION:$id', token))
      .whenComplete(() => markActionIdAsStored(id));

  Future<bool> deleteActionToken(int id) => prefs
      .then((prefs) => prefs.remove('$_ACTION:$id'))
      .whenComplete(() => unmarkActionIdAsStored(id));

  Future<String> loadActionToken(int id) =>
      prefs.then((prefs) => prefs.getString('$_ACTION:${id.toString()}'));

  markActionIdAsStored(int id) => prefs.then((prefs) => _getActionList().then(
      (list) => prefs.setStringList(_ACTIONLIST, list..add(id.toString()))));

  unmarkActionIdAsStored(int id) => prefs.then((prefs) => _getActionList().then(
      (list) => prefs.setStringList(_ACTIONLIST, list..remove(id.toString()))));

  Future<List<int>> loadAllStoredActionIds() => prefs.then((prefs) async {
        List<String> stringList = prefs.getStringList(_ACTIONLIST);
        if (stringList == null) return [];
        List<int> intList = stringList.map((id) => int.parse(id)).toList();
        return intList;
      });

  Future<List<String>> _getActionList() => _prefs.then((prefs) async {
        var list = prefs.getStringList(_ACTIONLIST);
        return list != null ? list : [];
      });

  clearAllPreferences() => _prefs.then((prefs) async {
        prefs.clear();
      });

  // Filter Properties

  Future<bool> saveFilter(TermineFilter filter) => prefs
      .then((prefs) => prefs.setString(_FILTER, jsonEncode(filter.toJson())));

  Future<TermineFilter> loadFilter() => prefs.then((prefs) {
        var filter = prefs.getString(_FILTER);
        if (filter == null) return TermineFilter.leererFilter();
        return TermineFilter.fromJSON(jsonDecode(filter));
      });

  Future<bool> saveUser(User user) => prefs
      .then((prefs) => prefs.setString(_USER, jsonEncode(user.toJson())));

  Future<User> loadUser() => prefs.then((prefs) {
    var user = prefs.getString(_USER);
    if (user == null) return null;
    return User.fromJSON(jsonDecode(user));
  });


}
