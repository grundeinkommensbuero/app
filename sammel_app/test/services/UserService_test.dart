import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/push_notification_manager.dart';

import '../shared/Mocks.dart';

void main() {
  StorageService storageService;
  PushNotificationsManager firebase;
  Backend backendMock;

  group('initialially', () {
    setUp(() {
      storageService = StorageServiceMock();
      backendMock = BackendMock();
      firebase = PushNotificationsManagerMock();

      //defaults
      when(storageService.loadUser())
          .thenAnswer((_) async => User(1, 'Karl Marx', Colors.red));
      when(storageService.loadSecret()).thenAnswer((_) async => 'secret');
      when(firebase.firebaseToken).thenAnswer((_) async => 'firebaseToken');
      when(backendMock.post('service/benutzer/authentifiziere', any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(true, 200));
      when(backendMock.post('service/benutzer/neu', any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              User(1, '', Colors.red).toJson(), 200));
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
          verify(backendMock.post('service/benutzer/neu', captureAny))
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
      var user = User(1, 'Karl Marx', Colors.red);

      UserService(storageService, firebase, backendMock);

      await Future.delayed(Duration(milliseconds: 100));

      var argument = verify(
              backendMock.post('service/benutzer/authentifiziere', captureAny))
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
          expect(equals(user, User(1, 'Karl Marx', Colors.red)), isTrue));
    ***REMOVED***);

    test('throws exception with authentication fail', () async {
      when(backendMock.post('service/benutzer/authentifiziere', any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(false, 200));

      var userService = UserService(storageService, firebase, backendMock);

      expect(() => userService.user, throwsA((e) => e is InvalidUserException));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

bool equals(User user1, User user2) =>
    user1.id == user2?.id &&
    user1.name == user2?.name &&
    user1.color?.value == user2?.color?.value;
