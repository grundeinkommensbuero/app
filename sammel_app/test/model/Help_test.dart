import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Help.dart';

main() {
  group('equals', () {
    test('true if identical', () {
      var help = Help(1, 'Title', 'Content', ['Tag1', 'Tag2', 'Tag3']);

      expect(help.equals(help), isTrue);
    });

    test('true if same values', () {
      var help1 = Help(1, 'Title', 'Content', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(1, 'Title', 'Content', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isTrue);
    });

    test('true if same values and empty tags', () {
      var help1 = Help(1, 'Title', 'Content', []);
      var help2 = Help(1, 'Title', 'Content', []);

      expect(help1.equals(help2), isTrue);
    });

    test('false if different id', () {
      var help1 = Help(1, 'Title', 'Content', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(2, 'Title', 'Content', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    });

    test('false if different title', () {
      var help1 = Help(1, 'Title1', 'Content', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(1, 'Title2', 'Content', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    });

    test('false if different content', () {
      var help1 = Help(1, 'Title', 'Content1', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(1, 'Title', 'Content2', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    });

    test('false if different order of tags', () {
      var help1 = Help(1, 'Title', 'Content', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(1, 'Title', 'Content', ['Tag2', 'Tag1', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    });

    test('false if different tags', () {
      var help1 = Help(1, 'Title', 'Content', ['Tag1', 'Tag2']);
      var help2 = Help(1, 'Title', 'Content', ['Tag1', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    });
  });

  test('serializes correctly', () {
    var help = Help(1, 'Title', 'Content', ['Tag1', 'Tag2', 'Tag3']);

    expect(jsonEncode(help),
        '{"id":1,"title":"Title","content":"Content","tags":["Tag1","Tag2","Tag3"]}');
  });

  test('deserializes correctly', () {
    var help = Help.fromJson(jsonDecode(
        '{"id":1,"title":"Title","content":"Content","tags":["Tag1","Tag2","Tag3"]}'));

    expect(help.id, 1);
    expect(help.title, 'Title');
    expect(help.content, 'Content');
    expect(listEquals(help.tags, <String>['Tag1','Tag2','Tag3']), isTrue);
  });
}
