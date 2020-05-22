import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Help.dart';
import 'package:sammel_app/services/HelpService.dart';

main() {
  group('loadHelps', () {
    HelpService.helps = testHelps;

    test('orders by number of hits in tags', () {
      List<Help> orderedHelps = HelpService.loadHelps('Ameise rot Holz');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Messor Barbarus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('orders by number of hits in title', () {
      List<Help> orderedHelps = HelpService.loadHelps('Lasius Niger Messor');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Lasius Niger',
            'Messor Barbarus',
            'Camponotus Ligniperdus',
          ]));
    ***REMOVED***);

    test('hits in tags outweight hits in title', () {
      List<Help> orderedHelps = HelpService.loadHelps('Holz Lasius Niger');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('orders by number of hits in content text', () {
      List<Help> orderedHelps = HelpService.loadHelps(
          'Netter Fleißig friedlich dickste Herrscher Mitteleuropa');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Messor Barbarus',
            'Camponotus Ligniperdus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('hits in title outweight hits in text', () {
      List<Help> orderedHelps =
          HelpService.loadHelps('Netter Fleißig friedlich Ligniperdus');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Messor Barbarus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('is not case sensitive', () {
      List<Help> orderedHelps =
          HelpService.loadHelps('RäUbEr CaMpoNoTuS lIgNiPeRdUs');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Lasius Niger',
            'Camponotus Ligniperdus',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('finds sub-words', () {
      List<Help> orderedHelps =
          HelpService.loadHelps('europa unscheinbar welt');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Lasius Niger',
            'Camponotus Ligniperdus',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('does not change original helps order', () {
      HelpService.loadHelps('Lasius Messor Barbarus');

      expect(
          HelpService.helps.map((help) => help.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('can handle multiple spaces and all kind of blanks', () {
      var orderedHelps = HelpService.loadHelps('Lasius     Messor\n\tBarbarus');

      expect(
          orderedHelps.map((help) => help.title),
          containsAllInOrder([
            'Messor Barbarus',
            'Lasius Niger',
            'Camponotus Ligniperdus',
          ]));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

var testHelps = [
  Help(
      1,
      'Camponotus Ligniperdus',
      Text('Anzeige-Text'),
      Text('Kurztext'),
      'Die dickste Ameise in Mitteleuropa',
      ['Holz', 'Ameise', 'rot', 'schwarz']),
  Help(
      2,
      'Lasius Niger',
      Text('Anzeige-Text'),
      Text('Kurztext'),
      'Die unscheinbaren Herrscher der Krabbelwelt',
      ['Räuber', 'Erdnester', 'schwarz']),
  Help(
      3,
      'Messor Barbarus',
      Text('Anzeige-Text'),
      Text('Kurztext'),
      'Netter als ihr Name vermuten lässt. Fleißig und friedlich.',
      ['Sammler', 'Erdnester', 'rot', 'schwarz']),
];
