import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/PushNotificationManager.dart';

import '../shared/Mocks.dart';
import '../shared/TestdatenVorrat.dart';

void main() {
  StorageService storageService;
  PushNotificationManager firebase;
  Backend backendMock;

  group('initialially', () {
    setUp(() {
      storageService = StorageServiceMock();
      backendMock = BackendMock();
      firebase = PushNotificationManagerMock();

      //defaults
      when(storageService.loadUser())
          .thenAnswer((_) async => User(11, 'Karl Marx', Colors.red));
      when(storageService.loadSecret()).thenAnswer((_) async => 'secret');
      when(firebase.firebaseToken).thenAnswer((_) async => 'firebaseToken');
      when(backendMock.post('service/benutzer/authentifiziere', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(true, 200));
      when(backendMock.post('service/benutzer/neu', any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              User(1, '', Colors.red).toJson(), 200));
    ***REMOVED***);

    test('assigns itself as userService and determines userHeader', () async {
      when(storageService.loadSecret()).thenAnswer((_) async => 'secret');
      when(storageService.loadUser()).thenAnswer((_) async => karl());

      var service = UserService(storageService, firebase, BackendMock());
      var userHeaders = await service.userHeaders;

      expect(service.userService, service);
      expect(userHeaders['Authorization'], 'Basic MTE6c2VjcmV0');
    ***REMOVED***);

    test('loads user from storage', () async {
      UserService(storageService, firebase, backendMock);

      verify(storageService.loadUser()).called(1);
    ***REMOVED***);

    test('registers new user to server, if none stored', () async {
      when(storageService.loadUser()).thenAnswer((_) async => null);

      UserService(storageService, firebase, backendMock);

      await Future.delayed(Duration(milliseconds: 10));

      var login = jsonDecode(
          verify(backendMock.post('service/benutzer/neu', captureAny, any))
              .captured
              .single);

      expect(login['user']['id'], 0);
      expect(login['user']['name'], isNull);
      expect(login['user']['color'], isNotNull);
      expect(login['secret'], isNotEmpty);
      expect(login['firebaseKey'], 'firebaseToken');
    ***REMOVED***);

    test('saves new user to storage', () async {
      var user = User(1, '', Colors.red);
      when(storageService.loadUser()).thenAnswer((_) async => null);

      UserService(storageService, firebase, backendMock);

      await Future.delayed(Duration(milliseconds: 100));

      var argument =
          verify(storageService.saveUser(captureAny)).captured.single as User;
      expect(equals(argument, user), true);
    ***REMOVED***);

    test('verifies stored user', () async {
      var user = User(11, 'Karl Marx', Colors.red);

      UserService(storageService, firebase, backendMock);

      await Future.delayed(Duration(milliseconds: 100));

      var argument = verify(backendMock.post(
              'service/benutzer/authentifiziere', captureAny, any))
          .captured
          .single;
      expect(equals(User.fromJSON(jsonDecode(argument)['user']), user), true);
      expect(jsonDecode(argument)['secret'], 'secret');
      expect(jsonDecode(argument)['firebaseKey'], 'firebaseToken');
    ***REMOVED***);

    test('serves created user', () async {
      when(storageService.loadUser()).thenAnswer((_) async => null);

      var userService = UserService(storageService, firebase, backendMock);

      userService.user.then(
          (user) => expect(equals(user, User(1, '', Colors.red)), isTrue));
    ***REMOVED***);

    test('serves verified user', () async {
      var userService = UserService(storageService, firebase, backendMock);

      userService.user.then((user) =>
          expect(equals(user, User(11, 'Karl Marx', Colors.red)), isTrue));
    ***REMOVED***);

    test('registers new user if authentication to server fails', () async {
      when(backendMock.post('service/benutzer/authentifiziere', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(false, 200));

      UserService(storageService, firebase, backendMock);

      await Future.delayed(Duration(milliseconds: 10));

      var login = jsonDecode(
          verify(backendMock.post('service/benutzer/neu', captureAny, any))
              .captured
              .single);

      expect(login['user']['id'], 0);
      expect(login['user']['name'], isNull);
      expect(login['user']['color'], isNotNull);
      expect(login['secret'], isNotEmpty);
      expect(login['firebaseKey'], 'firebaseToken');
    ***REMOVED***);

    // FIXME Funktioniert leider nicht, keine Ahnung was das Problem ist
    /*test('throws exception with non-authentication fail', () async {
      when(backendMock.post('service/benutzer/authentifiziere', any))
          .thenThrow((_) async => Exception());

      var userService = UserService(storageService, firebase, backendMock);

      expect(() {
        return userService.user;
      ***REMOVED***, throwsException);
    ***REMOVED***);*/
  ***REMOVED***);

  group('generateAuth', () {
    setUp(() {
      storageService = StorageServiceMock();
      backendMock = BackendMock();
      firebase = PushNotificationManagerMock();

      //defaults
      when(storageService.loadSecret()).thenAnswer((_) async => "mySecret");
      when(firebase.firebaseToken).thenAnswer((_) async => 'firebaseToken');
      when(backendMock.post('service/benutzer/authentifiziere', any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(true, 200));
      when(backendMock.post('service/benutzer/neu', any, any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              User(1, '', Colors.red).toJson(), 200));
    ***REMOVED***);

    test('erzeugt korrektes Basic Auth', () async {
      var userService = UserService(storageService, firebase, backendMock);
      Future<User> user = Future.delayed(
          Duration(milliseconds: 200), () => User(1, '', Colors.red));

      var auth = await userService.generateAuth(user);

      expect(auth, 'MTpteVNlY3JldA==');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

bool equals(User user1, User user2) =>
    user1.id == user2?.id &&
    user1.name == user2?.name &&
    user1.color?.value == user2?.color?.value;
