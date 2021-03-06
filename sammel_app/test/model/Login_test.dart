import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Login.dart';
import 'package:sammel_app/model/User.dart';

void main() {
  test('serialises empty Login', () {
    expect(
        jsonEncode(Login(null, null, null).toJson()),
        '{'
        '"user":null,'
        '"secret":null,'
        '"firebaseKey":null'
        '}');

    expect(
        jsonEncode(Login(null, '', '').toJson()),
        '{'
        '"user":null,'
        '"secret":"",'
        '"firebaseKey":""'
        '}');
  });

  test('serialises filled Login', () {
    expect(
        jsonEncode(
            Login(User(11, 'Karl Marx', Colors.red), 'secret', 'firebaseKey')
                .toJson()),
        '{'
        '"user":{"id":11,"name":"Karl Marx","color":4294198070},'
        '"secret":"secret",'
        '"firebaseKey":"firebaseKey"'
        '}');
  });
}
