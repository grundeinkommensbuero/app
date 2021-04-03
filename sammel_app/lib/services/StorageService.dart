import 'dart:async';
import 'dart:convert';

import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ErrorService.dart';

class StorageService {
  late Future<SharedPreferences> _prefs;

  Future<SharedPreferences> get prefs => _prefs.timeout(Duration(seconds: 5));

  static const String _ACTION = 'action';
  static const String _ACTIONLIST = 'actionlist';
  static const String _EVALUATIONLIST = 'evaluationlist';
  static const String _FILTER = 'filter';
  static const String _USER = 'user';
  static const String _SECRET = 'secret';
  static const String _PUSHTOKEN = 'pushToken';
  static const String _PULL_MODE = 'pullMode';
  static const String _CHANNEL = 'channel';
  static const String _MYKIEZ = 'mykiez';
  static const String _NOTIF_INTERVAL = 'notifInterval';
  static const String _CONTACT = 'contact';

  StorageService() {
    _prefs = SharedPreferences.getInstance();
  ***REMOVED***

  Future<bool> saveActionToken(int id, String token) => prefs
      .then((prefs) => prefs.setString('$_ACTION:$id', token))
      .whenComplete(() => markActionIdAsStored(id));

  Future<bool> deleteActionToken(int id) => prefs
      .then((prefs) => prefs.remove('$_ACTION:$id'))
      .whenComplete(() => unmarkActionIdAsStored(id));

  Future<String?> loadActionToken(int id) =>
      prefs.then((prefs) => prefs.getString('$_ACTION:${id.toString()***REMOVED***'));

  Future<bool> saveChatChannel(ChatChannel channel) => prefs.then((prefs) =>
      prefs.setString('$_CHANNEL:${channel.id***REMOVED***', jsonEncode(channel.toJson())));

  FutureOr<ChatChannel?> loadChatChannel(String id) async {
    try {
      return prefs.then((prefs) {
        var json = prefs.getString('$_CHANNEL:$id');
        if (json == null) return null;
        return ChatChannel.fromJSON(jsonDecode(json));
      ***REMOVED***);
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e, StackTrace.current);
    ***REMOVED***
  ***REMOVED***

  markActionIdAsStored(int id) => prefs.then((prefs) => _getActionList().then(
      (list) => prefs.setStringList(_ACTIONLIST, list..add(id.toString()))));

  unmarkActionIdAsStored(int id) => prefs.then((prefs) => _getActionList().then(
      (list) => prefs.setStringList(_ACTIONLIST, list..remove(id.toString()))));

  markActionIdAsEvaluated(int id) =>
      prefs.then((prefs) => _getEvaluationList().then((list) =>
          prefs.setStringList(_EVALUATIONLIST, list..add(id.toString()))));

  Future<List<int>> loadAllStoredActionIds() => prefs.then((prefs) async {
        List<String>? stringList = prefs.getStringList(_ACTIONLIST);
        if (stringList == null) return [];
        List<int> intList = stringList.map((id) => int.parse(id)).toList();
        return intList;
      ***REMOVED***);

  Future<List<int>> loadAllStoredEvaluations() => prefs.then((prefs) async {
        List<String>? stringList = prefs.getStringList(_EVALUATIONLIST);
        if (stringList == null) return [];
        List<int> intList = stringList.map((id) => int.parse(id)).toList();
        return intList;
      ***REMOVED***);

  Future<List<String>> _getActionList() => _prefs.then((prefs) async {
        var list = prefs.getStringList(_ACTIONLIST);
        return list != null ? list : [];
      ***REMOVED***);

  Future<List<String>> _getEvaluationList() => _prefs.then((prefs) async {
        var list = prefs.getStringList(_EVALUATIONLIST);
        return list != null ? list : [];
      ***REMOVED***);

  // Filter Properties

  Future<bool> saveFilter(TermineFilter filter) => prefs
      .then((prefs) => prefs.setString(_FILTER, jsonEncode(filter.toJson())));

  Future<TermineFilter?> loadFilter() => prefs.then((prefs) {
        var filter = prefs.getString(_FILTER);
        if (filter == null) return TermineFilter.leererFilter();
        return TermineFilter.fromJSON(jsonDecode(filter));
      ***REMOVED***);

  // User

  Future<bool> saveUser(User user) =>
      prefs.then((prefs) => prefs.setString(_USER, jsonEncode(user.toJson())));

  Future<User?> loadUser() => prefs.then((prefs) {
        var user = prefs.getString(_USER);
        if (user == null) return null;
        return User.fromJSON(jsonDecode(user));
      ***REMOVED***);

  // Gibt kein null zurück, sondern wartet bis ein Secret hinterlegt wurde
  Future<String> loadSecret() async {
    var prefs = await this.prefs;
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 500));
      return prefs.getString(_SECRET) == null;
    ***REMOVED***);
    var secret = prefs.getString(_SECRET)!;
    return secret;
  ***REMOVED***

  Future<void> saveSecret(String secret) =>
      prefs.then((prefs) => prefs.setString(_SECRET, secret));

  clearAllPreferences() => _prefs.then((prefs) async {
        prefs.clear();
      ***REMOVED***);

  Future<void> saveCostumPushToken(String token) =>
      prefs.then((prefs) => prefs.setString(_PUSHTOKEN, token));

  Future<void> markPullMode() =>
      prefs.then((prefs) => prefs.setBool(_PULL_MODE, true));

  Future<bool> isPullMode() =>
      prefs.then((prefs) => prefs.getBool(_PULL_MODE) ?? false);

  Future<void> saveMyKiez(List<String> kieze) =>
      prefs.then((prefs) => prefs.setStringList(_MYKIEZ, kieze));

  Future<List<String>> loadMyKiez() => _prefs.then((prefs) async {
        var list = prefs.getStringList(_MYKIEZ);
        return list != null ? list : [];
      ***REMOVED***);

  Future<bool> saveNotificationInterval(String interval) =>
      prefs.then((prefs) => prefs.setString(_NOTIF_INTERVAL, interval));

  Future<String?> loadNotificationInterval() =>
      prefs.then((prefs) => prefs.getString(_NOTIF_INTERVAL));

  Future<bool> saveContact(String interval) =>
      prefs.then((prefs) => prefs.setString(_CONTACT, interval));

  Future<String?> loadContact() =>
      prefs.then((prefs) => prefs.getString(_CONTACT));

  // for Debugging only
  loadCostumPushToken() => prefs.then((prefs) => prefs.getString(_PUSHTOKEN));
***REMOVED***
