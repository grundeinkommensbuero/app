import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Message.dart';

void main() {
  group('determineType', () {
    test('determineType returns type in json data', () {
      Map<String, dynamic> data = {'type': 'MyType', 'anyOther': 'Data'***REMOVED***

      expect('MyType', Message.determineType(data));
    ***REMOVED***);

    test('returns null for missing type in json data', () {
      Map<String, dynamic> data = {'anyOther': 'Data'***REMOVED***

      expect(Message.determineType(data), isNull);
    ***REMOVED***);
  ***REMOVED***);

  group('ParticipationMessage', () {
    group('toJson', () {
      test('serializes corretly', () {
        var message = ParticipationMessage(
            false, DateTime(2020, 12, 12, 23, 58), 'Karl Marx', true);

        var json = message.toJson();
        expect(json['type'], 'ParticipationMessage');
        expect(json['obtained_from_server'], isFalse);
        expect(json['timestamp'], '2020-12-12 23:58:00.000');
        expect(json['username'], 'Karl Marx');
        expect(json['joins'], isTrue);
      ***REMOVED***);

      test('serializes null username', () {
        var message = ParticipationMessage(
            false, DateTime(2020, 12, 12, 23, 58), null, true);
        var json = message.toJson();
        expect(json['type'], 'ParticipationMessage');
        expect(json['obtained_from_server'], isFalse);
        expect(json['timestamp'], '2020-12-12 23:58:00.000');
        expect(json['username'], null);
        expect(json['joins'], isTrue);
      ***REMOVED***);

      group('fromJson', () {
        test('deserializes correctly', () {
          var json = {
            'type': 'ParticipationMessage',
            'obtained_from_server': false,
            'timestamp': '2020-12-12 23:58:00.000',
            'username': 'Karl Marx',
            'joins': true
          ***REMOVED***

          var message = ParticipationMessage.fromJson(json);
          expect(message.type, 'ParticipationMessage');
          expect(message.obtained_from_server, isFalse);
          expect(message.timestamp.toString(), '2020-12-12 23:58:00.000');
          expect(message.username, 'Karl Marx');
          expect(message.joins, isTrue);
        ***REMOVED***);

        test('deserializes null-values', () {
          var json = {'type': 'ParticipationMessage'***REMOVED***

          var message = ParticipationMessage.fromJson(json);
          expect(message.type, 'ParticipationMessage');
          expect(message.obtained_from_server, isNull);
          expect(message.timestamp, isNull);
          expect(message.joins, isNull);
        ***REMOVED***);

        test('fromJson expects timestamp', () async {
          var json = {
            'type': 'ParticipationMessage',
            'obtained_from_server': false,
            'username': 'Karl Marx',
            'joins': true
          ***REMOVED***
          expect(
              () => ParticipationMessage.fromJson(json), throwsAssertionError);
        ***REMOVED***);

        test('fromJson expects joins', () async {
          var json = {
            'type': 'ParticipationMessage',
            'obtained_from_server': false,
            'timestamp': '2020-12-12 23:58:00.000',
            'username': 'Karl Marx',
          ***REMOVED***
          expect(
              () => ParticipationMessage.fromJson(json), throwsAssertionError);
        ***REMOVED***);
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
