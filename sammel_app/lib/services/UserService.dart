import 'dart:convert';

import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/StorageService.dart';

class UserService extends BackendService {
  StorageService storageService;
  Future<User> user;

  UserService(StorageService this.storageService, [Backend backend])
      : super(backend) {
    user = determineUser();
  ***REMOVED***

  Future<User> determineUser() async {
    var userFromStorage = await storageService.loadUser();
    if (userFromStorage == null)
      return await createNewUser();
    else
      return await verifyUser(userFromStorage);
  ***REMOVED***

  Future<User> createNewUser() async {
    var response = await post(
        'service/benutzer/neu', jsonEncode(User('', null, null).toJson()));
    var userFromServer = User.fromJSON(jsonDecode(response.body));
    storageService.saveUser(userFromServer);
    return userFromServer;
  ***REMOVED***

  Future<User> verifyUser(User user) async {
    var response = await post(
        'service/benutzer/authentifiziere', jsonEncode(user.toJson()));
    bool authenticated = response.body;
    if (authenticated)
      return user;
    else
      throw InvalidUserException();
  ***REMOVED***
***REMOVED***

class InvalidUserException implements Exception {***REMOVED***
