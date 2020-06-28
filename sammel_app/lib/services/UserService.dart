import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:sammel_app/model/Login.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/push_notification_manager.dart';
import 'package:uuid/uuid.dart';

class UserService extends BackendService {
  StorageService storageService;
  PushNotificationsManager firebase;
  Future<User> user;

  UserService(StorageService this.storageService,
      PushNotificationsManager this.firebase,
      [Backend backend])
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
    String secret = await generateSecret();
    String firebaseKey = await firebase.firebaseToken;
    Color color = _randomColor();
    User user = User(0, null, color);

    Login login = Login(user, secret, firebaseKey);
    var response =
        await post('service/benutzer/neu', jsonEncode(login.toJson()));
    var userFromServer = User.fromJSON(jsonDecode(response.body));

    storageService.saveUser(userFromServer);

    return userFromServer;
  ***REMOVED***

  Future<User> verifyUser(User user) async {
    String secret = await storageService.loadSecret();
    String firebaseKey = await firebase.firebaseToken;

    Login login = Login(user, secret, firebaseKey);
    var response = await post(
        'service/benutzer/authentifiziere', jsonEncode(login.toJson()));
    bool authenticated = response.body;
    if (authenticated)
      return user;
    else
      throw InvalidUserException();
  ***REMOVED***

  Future<String> generateSecret() async {
    String secret = Uuid().v1();
    await storageService.saveSecret(secret);
    return secret;
  ***REMOVED***
***REMOVED***

Color _randomColor() {
  var rng = new Random();
  var values = new List.generate(3, (_) => rng.nextInt(256));
  Color.fromRGBO(values[0], values[1], values[2], 0.5);
***REMOVED***

class InvalidUserException implements Exception {***REMOVED***