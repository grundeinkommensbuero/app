import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sammel_app/model/Login.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:uuid/uuid.dart';

abstract class AbstractUserService extends BackendService {
  final streamController = StreamController<User>.broadcast();
  late Stream<User> _userStream;
  User? latestUser;
  late Future<Map<String, String>> userHeaders;

  AbstractUserService(Backend backend) : super(null, backend) {
    this._userStream = streamController.stream;
    _userStream.listen((user) => latestUser = user);
  }

  updateUsername(String name);

  Stream<User> get user {
    var streamController = StreamController<User>();
    if (latestUser != null) streamController.add(latestUser!);
    streamController
        .addStream(_userStream)
        .then((_) => streamController.close());
    return streamController.stream;
  }
}

class UserService extends AbstractUserService {
  StorageService storageService;
  FirebaseReceiveService firebase;

  UserService(this.storageService, this.firebase, Backend backend)
      : super(backend) {
    getOrCreateUser();
    generateUserHeaders();

    this.userService = this;
  }

  getOrCreateUser() async {
    try {
      var user = await storageService.loadUser();
      if (user != null)
        await verifyUser(user).catchError((e, s) async {
          ErrorService.handleError(e, s,
              context: 'Eine neue Benutzer*in wird angelegt.');
          user = await createNewUser();
        }, test: (e) => e is InvalidUserException);
      else
        user = await createNewUser();
      streamController.add(user!);
    } catch (e) {
      streamController.addError(e);
    }
  }

  Future<User> createNewUser() async {
    String secret = await generateSecret();
    String? firebaseKey = await firebase.token;
    final user = User(0, null, _randomColor());

    Login login = Login(user, secret, firebaseKey);
    var response;
    try {
      response = await post('service/benutzer/neu', jsonEncode(login.toJson()),
          appAuth: true);
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Anlegen einer neuen Benutzer*in ist gescheitert.');
      throw e;
    }
    var userFromServer = User.fromJSON(response.body);

    storageService.saveUser(userFromServer);
    return userFromServer;
  }

  verifyUser(User user) async {
    String secret = await storageService.loadSecret();
    String? firebaseKey = await firebase.token;

    Login login = Login(user, secret, firebaseKey);
    var response;
    try {
      response = await post(
          'service/benutzer/authentifiziere', jsonEncode(login.toJson()),
          appAuth: true);
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Benutzer*indaten konnte nicht ??berpr??ft werden.');
      rethrow;
    }
    bool authenticated = response.body;
    if (authenticated)
      return;
    else
      throw InvalidUserException();
  }

  Future<String> generateSecret() async {
    String secret = Uuid().v1();
    await storageService.saveSecret(secret);
    return secret;
  }

  generateUserHeaders() async {
    userHeaders = _userStream.first.then((user) async {
      final secret = await storageService.loadSecret();
      final creds = '${user.id}:$secret';
      final creds64 = Base64Encoder().convert(creds.codeUnits);
      return {"Authorization": "Basic $creds64"};
    });
  }

  updateUsername(String name) async {
    try {
      var response = await post('service/benutzer/aktualisiereName', name);

      var userFromServer = User.fromJSON(response.body);
      await storageService.saveUser(userFromServer);
      this.streamController.add(userFromServer);
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Benutzer*in-Name konnte nicht ge??ndert werden.');
      throw e;
    }
  }
}

Color _randomColor() {
  var rng = new Random();
  var values = new List.generate(3, (_) => rng.nextInt(256));
  return Color.fromRGBO(values[0], values[1], values[2], 0.5);
}

class InvalidUserException implements Exception {
  static String message = 'Der hinterlegte Benutzer*in-Account ist ung??ltig.';
}

class DemoUserService extends AbstractUserService {
  DemoUserService() : super(DemoBackend()) {
    _userStream = streamController.stream;
    streamController.add(User(13, 'Ich', Colors.red));
    userHeaders = Future.value({'Authorization': 'userCreds'});
  }

  updateUsername(String name) {
    streamController.add(User(13, name, Colors.red));
  }
}
