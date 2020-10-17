import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/User.dart';

void main() {
  group('deserialisises', () {
    test('empty User', () {
      expect(
          jsonEncode(User(null, null, null).toJson()),
          '{'
          '"id":null,'
          '"name":null,'
          '"color":null'
          '***REMOVED***');

      expect(
          jsonEncode(User(0, '', null).toJson()),
          '{'
          '"id":0,'
          '"name":"",'
          '"color":null'
          '***REMOVED***');
    ***REMOVED***);

    test('filled User', () {
      expect(
          jsonEncode(User(1, 'secret', Colors.red).toJson()),
          '{'
          '"id":1,'
          '"name":"secret",'
          '"color":4294198070'
          '***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);

  group('deserialises', () {
    test('empty user', () {
      User user = User.fromJSON(jsonDecode('{'
          '"id":null,'
          '"name":null,'
          '"color":null'
          '***REMOVED***'));

      expect(user.id, isNull);
      expect(user.name, isNull);
      expect(user.color, isNull);

      user = User.fromJSON(jsonDecode('{'
          '"id":0,'
          '"name":"",'
          '"color":null'
          '***REMOVED***'));

      expect(user.id, 0);
      expect(user.name, isEmpty);
      expect(user.color, isNull);
    ***REMOVED***);

    test('filled user', () {
      User user = User.fromJSON(jsonDecode('{'
          '"id":11,'
          '"name":"Karl Marx",'
          '"color":4294198070'
          '***REMOVED***'));

      expect(user.id, 11);
      expect(user.name, 'Karl Marx');
      expect(user.color.value, Colors.red.value);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
