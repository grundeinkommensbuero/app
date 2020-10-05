import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sammel_app/model/Login.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/push_notification_manager.dart';
import 'package:uuid/uuid.dart';

abstract class AbstractUserService extends BackendService {
  Future<User> user;

  AbstractUserService([Backend backend]) : super(backend);

  Future<void> updateUser(User user);
}

class UserService extends AbstractUserService {
  StorageService storageService;
  PushNotificationsManager firebase;

  UserService(this.storageService, this.firebase, [Backend backend])
      : super(backend) {
    user = getOrCreateUser();
  }

  Future<User> getOrCreateUser() async {
    var foundUser = await storageService.loadUser();
    if (foundUser != null)
      return verifyUser(foundUser).catchError((e) {
        ErrorService.handleError(e,
            additional: 'Ein neuer Benutzer wird angelegt.');
        return createNewUser();
      }, test: (e) => e is InvalidUserException);
    else {
      return await createNewUser();
    }
  }

  Future<User> createNewUser() async {
    String secret = await generateSecret();
    String firebaseKey = await firebase.firebaseToken;
    Color color = _randomColor();
    User user = User(0, null, color);

    Login login = Login(user, secret, firebaseKey);
    var response;
    try {
      response = await post('service/benutzer/neu', jsonEncode(login.toJson()));
    } catch (e) {
      ErrorService.handleError(e);
      throw e;
    }
    var userFromServer = User.fromJSON(response.body);

    storageService.saveUser(userFromServer);

    return userFromServer;
  }

  Future<User> verifyUser(User user) async {
    String secret = await storageService.loadSecret();
    String firebaseKey = await firebase.firebaseToken;

    Login login = Login(user, secret, firebaseKey);
    var response;
    try {
      response = await post(
          'service/benutzer/authentifiziere', jsonEncode(login.toJson()));
    } catch (e) {
      ErrorService.handleError(e);
      throw e;
    }
    bool authenticated = response.body;
    if (authenticated)
      return user;
    else
      throw InvalidUserException();
  }

  Future<String> generateSecret() async {
    String secret = Uuid().v1();
    await storageService.saveSecret(secret);
    return secret;
  }

  Future<User> updateUser(User user) async {
    try {
      var response =
          await post('service/benutzer/aktualisiere', jsonEncode(user));

      var userFromServer = User.fromJSON(response.body);
      storageService.saveUser(userFromServer);

      return userFromServer;
    } catch (e) {
      ErrorService.handleError(e);
      throw e;
    }
  }
}

Color _randomColor() {
  var rng = new Random();
  var values = new List.generate(3, (_) => rng.nextInt(256));
  return Color.fromRGBO(values[0], values[1], values[2], 0.5);
}

class InvalidUserException implements Exception {}

class DemoUserService extends AbstractUserService {
  DemoUserService() : super() {
    user = Future.value(User(1, 'Ich', Colors.red));
  }

  Future<void> updateUser(User user) {}
}
