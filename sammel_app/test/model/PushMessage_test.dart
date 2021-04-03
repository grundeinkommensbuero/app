import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Message.dart';
import 'package:sammel_app/model/PushMessage.dart';

import '../routes/TerminCard_test.dart';

ParticipationMessage message() =>
    ParticipationMessage(now(), 'Karl Marx', true);

void main() {
  group('ParticipationPushData', () {
    group('toJson', () {
      test('serializes correctly', () {
        var pushData = ParticipationPushData(message(), 1, 'my channel');
        var json = pushData.toJson();
        expect(json['channel'], 'my channel');
      ***REMOVED***);

      test('serializes with missing channel', () {
        var pushData = ParticipationPushData(message(), 1, null);
        var json = pushData.toJson();
        expect(json['channel'], null);
      ***REMOVED***);
    ***REMOVED***);
    group('fromJson', () {
      test('deserializes correcty', () {
        var json = {
          'type': 'ParticipationMessage',
          'channel': 'my channel',
          'obtained_from_server': false,
          'timestamp': '2020-12-12 23:58:00.000',
          'username': 'Karl Marx',
          'action': 1,
          'joins': true
        ***REMOVED***

        var pushData = ParticipationPushData.fromJson(json);
        expect(pushData.type, 'ParticipationMessage');
        expect(pushData.channel, 'my channel');
      ***REMOVED***);

      test('throws UnreadablePushMessage on incosistent data', () {
        var json = {
          'type': 'ParticipationMessage',
          'channel': 'my channel',
        ***REMOVED***

        expect(() => ParticipationPushData.fromJson(json),
            throwsA((e) => e is UnreadablePushMessage));
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
