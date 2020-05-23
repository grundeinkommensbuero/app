import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:sammel_app/services/FAQService.dart';

main() {
  group('loaditems', () {
    FAQService.items = testItems;

    test('orders by number of hits in tags', () {
      List<FAQItem> orderedItems = FAQService.loadItems('Ameise rot Holz');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Messor Barbarus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('orders by number of hits in title', () {
      List<FAQItem> orderedItems = FAQService.loadItems('Lasius Niger Messor');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Lasius Niger',
            'Messor Barbarus',
            'Camponotus Ligniperdus',
          ]));
    ***REMOVED***);

    test('hits in tags outweight hits in title', () {
      List<FAQItem> orderedItems = FAQService.loadItems('Holz Lasius Niger');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('orders by number of hits in content text', () {
      List<FAQItem> orderedItems = FAQService.loadItems(
          'Netter Fleißig friedlich dickste Herrscher Mitteleuropa');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Messor Barbarus',
            'Camponotus Ligniperdus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('hits in title outweight hits in text', () {
      List<FAQItem> orderedItems =
          FAQService.loadItems('Netter Fleißig friedlich Ligniperdus');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Messor Barbarus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('is not case sensitive', () {
      List<FAQItem> orderedItems =
          FAQService.loadItems('RäUbEr CaMpoNoTuS lIgNiPeRdUs');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Lasius Niger',
            'Camponotus Ligniperdus',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('finds sub-words', () {
      List<FAQItem> orderedItems =
          FAQService.loadItems('europa unscheinbar welt');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Lasius Niger',
            'Camponotus Ligniperdus',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('does not change original items order', () {
      FAQService.loadItems('Lasius Messor Barbarus');

      expect(
          FAQService.items.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('can handle multiple spaces and all kind of blanks', () {
      var orderedItems = FAQService.loadItems('Lasius     Messor\n\tBarbarus');

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Messor Barbarus',
            'Lasius Niger',
            'Camponotus Ligniperdus',
          ]));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

var testItems = [
  FAQItem(
      1,
      'Camponotus Ligniperdus',
      Text('Anzeige-Text'),
      Text('Kurztext'),
      'Die dickste Ameise in Mitteleuropa',
      ['Holz', 'Ameise', 'rot', 'schwarz']),
  FAQItem(
      2,
      'Lasius Niger',
      Text('Anzeige-Text'),
      Text('Kurztext'),
      'Die unscheinbaren Herrscher der Krabbelwelt',
      ['Räuber', 'Erdnester', 'schwarz']),
  FAQItem(
      3,
      'Messor Barbarus',
      Text('Anzeige-Text'),
      Text('Kurztext'),
      'Netter als ihr Name vermuten lässt. Fleißig und friedlich.',
      ['Sammler', 'Erdnester', 'rot', 'schwarz']),
];
