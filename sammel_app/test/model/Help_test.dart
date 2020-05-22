import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Help.dart';

main() {
  group('equals', () {
    test('true if identical', () {
      var help =
          Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);

      expect(help.equals(help), isTrue);
    ***REMOVED***);

    test('true if same values', () {
      var help1 =
          Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);
      var help2 =
          Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isTrue);
    ***REMOVED***);

    test('true if same values and empty tags', () {
      var help1 = Help(1, 'Title', 'Content', 'ShortContent', []);
      var help2 = Help(1, 'Title', 'Content', 'ShortContent', []);

      expect(help1.equals(help2), isTrue);
    ***REMOVED***);

    test('false if different id', () {
      var help1 =
          Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);
      var help2 =
          Help(2, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    ***REMOVED***);

    test('false if different title', () {
      var help1 = Help(
          1, 'Title1', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(
          1, 'Title2', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    ***REMOVED***);

    test('false if different content', () {
      var help1 = Help(
          1, 'Title', 'Content1', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(
          1, 'Title', 'Content2', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    ***REMOVED***);

    test('false if different short content', () {
      var help1 = Help(
          1, 'Title', 'Content', 'ShortContent1', ['Tag1', 'Tag2', 'Tag3']);
      var help2 = Help(
          1, 'Title', 'Content', 'ShortContent2', ['Tag1', 'Tag2', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    ***REMOVED***);

    test('false if different order of tags', () {
      var help1 =
          Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);
      var help2 =
          Help(1, 'Title', 'Content', 'ShortContent', ['Tag2', 'Tag1', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    ***REMOVED***);

    test('false if different tags', () {
      var help1 = Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2']);
      var help2 = Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag3']);

      expect(help1.equals(help2), isFalse);
    ***REMOVED***);
  ***REMOVED***);

  test('serializes correctly', () {
    var help =
        Help(1, 'Title', 'Content', 'ShortContent', ['Tag1', 'Tag2', 'Tag3']);

    expect(jsonEncode(help),
        '{"id":1,"title":"Title","content":"Content","shortContent":"ShortContent","tags":["Tag1","Tag2","Tag3"]***REMOVED***');
  ***REMOVED***);

  test('deserializes correctly', () {
    var help = Help.fromJson(jsonDecode(
        '{"id":1,"title":"Title","content":"Content","shortContent":"ShortContent","tags":["Tag1","Tag2","Tag3"]***REMOVED***'));

    expect(help.id, 1);
    expect(help.title, 'Title');
    expect(help.content, 'Content');
    expect(help.shortContent, 'ShortContent');
    expect(listEquals(help.tags, <String>['Tag1', 'Tag2', 'Tag3']), isTrue);
  ***REMOVED***);
***REMOVED***
