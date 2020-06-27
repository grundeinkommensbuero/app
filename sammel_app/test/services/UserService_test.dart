import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Mocks.dart';

void main() {
  var storageService = StorageServiceMock();
  var backendMock = BackendMock();

  group('initialially', () {
    setUp(() {
      storageService = StorageServiceMock();
      backendMock = BackendMock();
      when(storageService.loadUser())
          .thenAnswer((_) async => User("Karl Marx", "1", Colors.red));
      when(backendMock.post('service/benutzer/authentifiziere', any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(true, 200));
      when(backendMock.post('service/benutzer/neu', any)).thenAnswer(
          (_) async => HttpClientResponseBodyMock(
              jsonEncode(User('', "1", Colors.red).toJson()), 200));
    });

    test('loads user from storage', () async {
      UserService(storageService, backendMock);

      verify(storageService.loadUser()).called(1);
    });

    test('registers new user to server, if none stored', () async {
      when(storageService.loadUser()).thenAnswer((_) async => null);

      UserService(storageService, backendMock);

      await Future.delayed(Duration(milliseconds: 10));

      verify(backendMock.post('service/benutzer/neu',
              jsonEncode(User('', null, null).toJson())))
          .called(1);
    });

    test('saves new user to storage', () async {
      var user = User('', "1", Colors.red);
      when(storageService.loadUser()).thenAnswer((_) async => null);

      UserService(storageService, backendMock);

      await Future.delayed(Duration(milliseconds: 100));

      var argument =
          verify(storageService.saveUser(captureAny)).captured.single as User;
      expect(argument.equals(user), true);
    });

    test('verifies stored user', () async {
      var user = User('Karl Marx', "1", Colors.red);

      UserService(storageService, backendMock);

      await Future.delayed(Duration(milliseconds: 100));

      var argument = verify(
              backendMock.post('service/benutzer/authentifiziere', captureAny))
          .captured
          .single;
      expect(User.fromJSON(jsonDecode(argument)).equals(user), true);
    });

    test('serves created user', () async {
      when(storageService.loadUser()).thenAnswer((_) async => null);

      var userService = UserService(storageService, backendMock);

      userService.user.then(
          (user) => expect(user.equals(User('', '1', Colors.red)), isTrue));
    });

    test('serves verified user', () async {
      var userService = UserService(storageService, backendMock);

      userService.user.then((user) =>
          expect(user.equals(User('Karl Marx', '1', Colors.red)), isTrue));
    });

    test('throws exception with authentication fail', () async {
      when(backendMock.post('service/benutzer/authentifiziere', any))
          .thenAnswer((_) async => HttpClientResponseBodyMock(false, 200));

      var userService = UserService(storageService, backendMock);

      expect(() => userService.user, throwsA((e) => e is InvalidUserException));
    });
  });
}
