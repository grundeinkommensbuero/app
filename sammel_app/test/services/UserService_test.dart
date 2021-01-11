import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushReceiveService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../shared/Mocks.dart';
import '../shared/TestdatenVorrat.dart';

void main() {
  StorageService storageService;
  FirebaseReceiveService firebase;
  Backend backendMock;

  group('UserService', () {
    setUp(() {
      storageService = StorageServiceMock();
      backendMock = BackendMock();
      firebase = FirebaseReceiveServiceMock();

      //defaults
      when(storageService.loadUser())
          .thenAnswer((_) async => User(11, 'Karl Marx', Colors.red));
      when(storageService.loadSecret()).thenAnswer((_) async => 'secret');
      when(firebase.token).thenAnswer((_) async => 'firebaseToken');
      when(backendMock.post('service/benutzer/authentifiziere', any, any))
          .thenAnswer((_) => Future<HttpClientResponseBody>.value(
              HttpClientResponseBodyMock(true, 200)));
      when(backendMock.post('service/benutzer/neu', any, any)).thenAnswer((_) =>
          Future<HttpClientResponseBody>.value(HttpClientResponseBodyMock(
              User(11, '', Colors.red).toJson(), 200)));
    });

    group('user streams', () {
      test('stream is initialized', () {
        var service = UserService(storageService, firebase, backendMock);

        expect(service.streamController.stream, isNotNull);
      });

      test('individual stream emits first user, even if subscribed later',
          () async {
        final user = karl();
        when(storageService.loadUser()).thenAnswer((_) async => user);
        var service = UserService(storageService, firebase, backendMock);

        // other listeners to broadcast
        service.streamController.stream.listen((_) => {});
        service.streamController.stream.listen((_) => {});

        await service.streamController.stream.first;

        var subscription = service.user;
        expect(await subscription.first, user);
      });

      test('individual streams emit following users', () async {
        when(storageService.loadUser()).thenAnswer((_) async => karl());
        var service = UserService(storageService, firebase, backendMock);

        var users = service.user.toList();

        await service.streamController.stream.first;

        service.streamController.add(rosa());
        service.streamController.add(User(13, 'Bini Adamczak', Colors.green));
        service.streamController.add(User(14, 'Walther Benjamin', Colors.blue));
        service.streamController.close();

        expect((await users).map((user) => user.id), [11, 12, 13, 14]);
      });

      test('stores latest user', () async {
        final user = karl();
        when(storageService.loadUser()).thenAnswer((_) async => user);
        var service = UserService(storageService, firebase, backendMock);

        await service.streamController.stream.first;

        expect(service.latestUser, user);
      });

      test('updates latest user', () async {
        when(storageService.loadUser()).thenAnswer((_) async => karl());
        var service = UserService(storageService, firebase, backendMock);

        var nextUser = rosa();
        var userPassed =
            service.streamController.stream.firstWhere((u) => u == nextUser);

        service.streamController.add(nextUser);

        await userPassed;

        expect(service.latestUser, nextUser);

        nextUser = User(12, 'Bini Adamczak', Colors.green);
        userPassed =
            service.streamController.stream.firstWhere((u) => u == nextUser);

        service.streamController.add(nextUser);

        await userPassed;

        expect(service.latestUser, nextUser);
      });

      test('closes individual streams', () async {
        when(storageService.loadUser()).thenAnswer((_) async => karl());
        var service = UserService(storageService, firebase, backendMock);

        var individualStream = service.user;

        await Future.delayed(Duration(milliseconds: 1));

        service.streamController.close();

        await individualStream.length.timeout(Duration(seconds: 1));
      });
    });

    group('initially', () {
      test('assigns itself as userService and determines userHeader', () async {
        when(storageService.loadSecret()).thenAnswer((_) async => 'secret');
        when(storageService.loadUser()).thenAnswer((_) async => karl());

        var service = UserService(storageService, firebase, backendMock);
        var userHeaders = await service.userHeaders;

        print(await userHeaders);

        expect(service.userService, service);
        expect(userHeaders['Authorization'], 'Basic MTE6c2VjcmV0');
      });

      test('loads user from storage', () async {
        UserService(storageService, firebase, backendMock);

        verify(storageService.loadUser()).called(1);
      });

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
      });

      test('saves new user to storage', () async {
        var user = User(11, '', Colors.red);
        when(storageService.loadUser()).thenAnswer((_) async => null);

        UserService(storageService, firebase, backendMock);

        await Future.delayed(Duration(milliseconds: 100));

        var argument =
            verify(storageService.saveUser(captureAny)).captured.single as User;
        expect(equals(argument, user), true);
      });

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
      });

      test('serves created user', () async {
        when(storageService.loadUser()).thenAnswer((_) async => null);

        var userService = UserService(storageService, firebase, backendMock);

        var user = await userService.user.first;
        expect(equals(user, User(11, '', Colors.red)), isTrue);
      });

      test('serves verified user', () async {
        var userService = UserService(storageService, firebase, backendMock);

        var user = await userService.user.first;
        expect(equals(user, User(11, 'Karl Marx', Colors.red)), isTrue);
      });

      test('registers new user if authentication to server fails', () async {
        when(backendMock.post('service/benutzer/authentifiziere', any, any))
            .thenAnswer((_) => Future<HttpClientResponseBody>.value(
                HttpClientResponseBodyMock(false, 200)));

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
      });

      // FIXME Funktioniert leider nicht, keine Ahnung was das Problem ist
      /*test('throws exception with non-authentication fail', () async {
      when(backendMock.post('service/benutzer/authentifiziere', any))
          .thenThrow((_) async => Exception());

      var userService = UserService(storageService, firebase, backendMock);

      expect(() {
        return userService.user;
      }, throwsException);
    });*/
    });
  });

  group('DemoUserService', () {
    var service = DemoUserService();

    test('updateName updates name', () async {
      var user = service.user;

      service.updateUsername('neuer Name');
      service.updateUsername('neuerer Name');
      service.streamController.close();

      var users = await user.toList();
      expect(users.map((user) => user.name),
          containsAll([null, 'neuer Name', 'neuerer Name']));
      expect(service.latestUser.name, 'neuerer Name');
    });
  });
}

bool equals(User user1, User user2) =>
    user1.id == user2?.id &&
    user1.name == user2?.name &&
    user1.color?.value == user2?.color?.value;
