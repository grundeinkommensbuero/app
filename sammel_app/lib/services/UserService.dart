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
  Future<User> user;
  Future<String> userAuthCreds;
  User internal_user_object = User(0, null, _randomColor());
  StreamController<User> user_stream = StreamController<User>.broadcast();

  AbstractUserService([Backend backendService]) : super(null, backendService);

  Future<void> updateUser(User user);
***REMOVED***

class UserService extends AbstractUserService {
  StorageService storageService;
  FirebaseReceiveService firebase;

  UserService(this.storageService, this.firebase, [Backend backend])
      : super(backend) {
    user = getOrCreateUser();
    userAuthCreds = generateAuth(user);

    this.userService = this;

    userHeaders = userAuthCreds
        .asStream()
        .map((creds) => {"Authorization": "Basic $creds"***REMOVED***)
        .first;
  ***REMOVED***

  Future<User> getOrCreateUser() async {
    var foundUser = await storageService.loadUser();
    if (foundUser != null)
      return verifyUser(foundUser).catchError((e) {
        ErrorService.handleError(e,
            additional: 'Ein neuer Benutzer wird angelegt.');
        return createNewUser();
      ***REMOVED***, test: (e) => e is InvalidUserException);
    else
      return await createNewUser();
  ***REMOVED***

  Future<User> createNewUser() async {
    String secret = await generateSecret();
    String firebaseKey = await firebase.token;
    //Color color = _randomColor();
    //User user = User(0, null, color);

    Login login = Login(this.internal_user_object, secret, firebaseKey);
    var response;
    try {
      response = await post('service/benutzer/neu', jsonEncode(login.toJson()),
          appAuth: true);
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e);
      throw e;
    ***REMOVED***
    var userFromServer = User.fromJSON(response.body);

    internal_user_object.setUserData(userFromServer);
    this.user_stream.sink.add(internal_user_object);

    storageService.saveUser(userFromServer);

    return internal_user_object;
  ***REMOVED***

  Future<User> verifyUser(User user) async {
    String secret = await storageService.loadSecret();
    String firebaseKey = await firebase.token;

    Login login = Login(user, secret, firebaseKey);
    var response;
    try {
      response = await post(
          'service/benutzer/authentifiziere', jsonEncode(login.toJson()),
          appAuth: true);
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e);
      throw e;
    ***REMOVED***
    bool authenticated = response.body;
    if (authenticated) {
      this.internal_user_object = user;
      this.user_stream.sink.add(user);
      return user;
    ***REMOVED***
    else
      throw InvalidUserException();
  ***REMOVED***

  Future<String> generateSecret() async {
    String secret = Uuid().v1();
    await storageService.saveSecret(secret);
    return secret;
  ***REMOVED***

  Future<String> generateAuth(Future<User> user) async {
    var userId = (await user).id;
    var secret = await storageService.loadSecret();
    List<int> input = '$userId:$secret'.codeUnits;
    var auth = Future.value(Base64Encoder().convert(input));
    return auth;
  ***REMOVED***

  Future<User> updateUser(User user) async {
    try {
      var response =
          await post('service/benutzer/aktualisiere', jsonEncode(user));

      var userFromServer = User.fromJSON(response.body);
      internal_user_object.setUserData(userFromServer);
      storageService.saveUser(userFromServer);
      this.user_stream.sink.add(userFromServer);

      return internal_user_object;
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e);
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
  DemoUserService() : super() {
    user = Future.value(User(1, 'Ich', Colors.red));
    userAuthCreds = Future.value('userCreds');

  ***REMOVED***

  Future<void> updateUser(User user) {
    //TODO
  ***REMOVED***
***REMOVED***
