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
  static String appAuth =
      'MTpiOTdjNzU5Ny1mNjY5LTRmZWItOWJhMi0zMjE0YzE4MjIzMzk=';
  final streamController = StreamController<User>.broadcast();
  Stream<User> _userStream;
  User latestUser;
  Future<Map<String, String>> userHeaders;

  AbstractUserService(Backend backend) : super(null, backend) {
    this._userStream = streamController.stream;
    _userStream.listen((user) => latestUser = user);
  ***REMOVED***

  updateUsername(String name);

  Stream<User> get user {
    var streamController = StreamController<User>();
    if (latestUser != null) streamController.add(latestUser);
    streamController
        .addStream(_userStream)
        .then((_) => streamController.close());
    return streamController.stream;
  ***REMOVED***
***REMOVED***

class UserService extends AbstractUserService {
  StorageService storageService;
  FirebaseReceiveService firebase;

  UserService(this.storageService, this.firebase, Backend backend)
      : super(backend) {
    getOrCreateUser();
    generateUserHeaders();

    this.userService = this;
  ***REMOVED***

  getOrCreateUser() async {
    try {
      var user = await storageService.loadUser();
      if (user != null)
        await verifyUser(user).catchError((e, s) async {
          ErrorService.handleError(e, s,
              context: 'Ein neuer Benutzer wird angelegt.');
          user = await createNewUser();
        ***REMOVED***, test: (e) => e is InvalidUserException);
      else
        user = await createNewUser();
      streamController.add(user);
    ***REMOVED*** catch (e) {
      streamController.addError(e);
    ***REMOVED***
  ***REMOVED***

  Future<User> createNewUser() async {
    String secret = await generateSecret();
    String firebaseKey = await firebase.token;
    final user = User(0, null, _randomColor());

    Login login = Login(user, secret, firebaseKey);
    var response;
    try {
      response = await post('service/benutzer/neu', jsonEncode(login.toJson()),
          appAuth: true);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Anlegen eine*r neuen Benutzer*in ist gescheitert.');
      throw e;
    ***REMOVED***
    var userFromServer = User.fromJSON(response.body);

    storageService.saveUser(userFromServer);
    return userFromServer;
  ***REMOVED***

  verifyUser(User user) async {
    String secret = await storageService.loadSecret();
    String firebaseKey = await firebase.token;

    Login login = Login(user, secret, firebaseKey);
    var response;
    try {
      response = await post(
          'service/benutzer/authentifiziere', jsonEncode(login.toJson()),
          appAuth: true);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Benutzer*indaten konnte nicht überprüft werden.');
      rethrow;
    ***REMOVED***
    bool authenticated = response.body;
    if (authenticated)
      return;
    else
      throw InvalidUserException();
  ***REMOVED***

  Future<String> generateSecret() async {
    String secret = Uuid().v1();
    await storageService.saveSecret(secret);
    return secret;
  ***REMOVED***

  generateUserHeaders() async {
    userHeaders = _userStream.first.then((user) async {
      final secret = await storageService.loadSecret();
      final creds = '${user.id***REMOVED***:$secret';
      final creds64 = Base64Encoder().convert(creds.codeUnits);
      return {"Authorization": "Basic $creds64"***REMOVED***
    ***REMOVED***);
  ***REMOVED***

  updateUsername(String name) async {
    try {
      var response = await post('service/benutzer/aktualisiereName', name);

      var userFromServer = User.fromJSON(response.body);
      await storageService.saveUser(userFromServer);
      this.streamController.add(userFromServer);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Benutzer*in-Name konnte nicht geändert werden.');
      throw e;
    ***REMOVED***
  ***REMOVED***
***REMOVED***

Color _randomColor() {
  var rng = new Random();
  var values = new List.generate(3, (_) => rng.nextInt(256));
  return Color.fromRGBO(values[0], values[1], values[2], 0.5);
***REMOVED***

class InvalidUserException implements Exception {***REMOVED***

class DemoUserService extends AbstractUserService {
  DemoUserService() : super(DemoBackend()) {
    _userStream = streamController.stream;
    streamController.add(User(13, null, Colors.red));
    userHeaders = Future.value({'Authorization': 'userCreds'***REMOVED***);
  ***REMOVED***

  updateUsername(String name) {
    streamController.add(User(13, name, Colors.red));
  ***REMOVED***
***REMOVED***
