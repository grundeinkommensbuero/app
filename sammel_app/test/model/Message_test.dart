import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Message.dart';

void main() {
  group('determineType', () {
    test('determineType returns type in json data', () {
      Map<String, dynamic> data = {'type': 'MyType', 'anyOther': 'Data'};

      expect('MyType', Message.determineType(data));
    });

    test('returns null for missing type in json data', () {
      Map<String, dynamic> data = {'anyOther': 'Data'};

      expect(Message.determineType(data), isNull);
    });
  });

  group('ParticipationMessage', () {
    group('toJson', () {
      test('serializes corretly', () {
        var message = ParticipationMessage(
            DateTime(2020, 12, 12, 23, 58), 'Karl Marx', true);

        var json = message.toJson();
        expect(json['type'], 'ParticipationMessage');
        expect(json['obtained_from_server'], isFalse);
        expect(json['timestamp'], '2020-12-12 23:58:00.000');
        expect(json['username'], 'Karl Marx');
        expect(json['joins'], isTrue);
      });

      test('serializes null username', () {
        var message =
            ParticipationMessage(DateTime(2020, 12, 12, 23, 58), null, true);
        var json = message.toJson();
        expect(json['type'], 'ParticipationMessage');
        expect(json['obtained_from_server'], isFalse);
        expect(json['timestamp'], '2020-12-12 23:58:00.000');
        expect(json['username'], null);
        expect(json['joins'], isTrue);
      });
    });

    group('fromJson', () {
      test('deserializes correctly', () {
        var json = {
          'type': 'ParticipationMessage',
          'obtained_from_server': false,
          'timestamp': '2020-12-12 23:58:00.000',
          'username': 'Karl Marx',
          'joins': true
        };

        var message = ParticipationMessage.fromJson(json);
        expect(message.type, 'ParticipationMessage');
        expect(message.obtainedFromServer, isFalse);
        expect(message.timestamp.toString(), '2020-12-12 23:58:00.000');
        expect(message.username, 'Karl Marx');
        expect(message.joins, isTrue);
      });

      test('deserializes null-values', () {
        var json = {
          'type': 'ParticipationMessage',
          'obtained_from_server': true,
          'timestamp': '2020-12-12 23:58:00.000',
          'joins': true
        };

        var message = ParticipationMessage.fromJson(json);
        expect(message.type, 'ParticipationMessage');
        expect(message.username, isNull);
      });

      test('fromJson expects timestamp', () async {
        var json = {
          'type': 'ParticipationMessage',
          'obtained_from_server': false,
          'username': 'Karl Marx',
          'joins': true
        };
        expect(() => ParticipationMessage.fromJson(json),
            throwsA((e) => e is TypeError));
      });

      test('fromJson expects joins', () async {
        var json = {
          'type': 'ParticipationMessage',
          'obtained_from_server': false,
          'timestamp': '2020-12-12 23:58:00.000',
          'username': 'Karl Marx',
        };
        expect(() => ParticipationMessage.fromJson(json),
            throwsA((e) => e is TypeError));
      });
    });
    group('isMessageEqual', () {
      test('idntifies equal values', () {
        var user1 = ParticipationMessage(
            DateTime(2020, 1, 11, 04, 18), 'Karl Marx', true);
        var user2 = ParticipationMessage(
            DateTime(2020, 1, 11, 04, 18), 'Karl Marx', true);

        expect(user1.isMessageEqual(user2), isTrue);
      });

      test('ignores different obtained_from_server values', () {
        var user1 = ParticipationMessage(
            DateTime(2020, 1, 11, 04, 18), 'Karl Marx', true, true);
        var user2 = ParticipationMessage(
            DateTime(2020, 1, 11, 04, 18), 'Karl Marx', true);

        expect(user1.isMessageEqual(user2), isTrue);
      });
    });
  });
}
