import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Login.dart';
import 'package:sammel_app/model/User.dart';

void main() {
  test('  serialises empty Login', () {
    expect(
        jsonEncode(Login(null, null, null).toJson()),
        '{'
        '"user":null,'
        '"secret":null,'
        '"firebaseKey":null'
        '***REMOVED***');

    expect(
        jsonEncode(Login(null, '', '').toJson()),
        '{'
        '"user":null,'
        '"secret":"",'
        '"firebaseKey":""'
        '***REMOVED***');
  ***REMOVED***);

  test('serialises filled Login', () {
    expect(
        jsonEncode(
            Login(User(1, 'Karl Marx', Colors.red), 'secret', 'firebaseKey')
                .toJson()),
        '{'
        '"user":{"id":1,"name":"Karl Marx","color":4294198070***REMOVED***,'
        '"secret":"secret",'
        '"firebaseKey":"firebaseKey"'
        '***REMOVED***');
  ***REMOVED***);
***REMOVED***
