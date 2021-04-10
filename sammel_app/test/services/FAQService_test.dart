import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:sammel_app/services/FAQService.dart';

main() {
  group('mixin', () {
    test('orders by number of hits in tags', () async {
      List<FAQItem> orderedItems =
          await TestFAQSorter().sortItems('Ameise rot Holz', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Messor Barbarus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('orders by number of hits in title', () async {
      List<FAQItem> orderedItems =
          await TestFAQSorter().sortItems('Lasius Niger Messor', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Lasius Niger',
            'Messor Barbarus',
            'Camponotus Ligniperdus',
          ]));
    ***REMOVED***);

    test('hits in tags outweight hits in title', () async {
      List<FAQItem> orderedItems =
          await TestFAQSorter().sortItems('Holz Lasius Niger', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('orders by number of hits in content text', () async {
      List<FAQItem> orderedItems = await TestFAQSorter().sortItems(
          'Netter Fleißig friedlich dickste Herrscher Mitteleuropa', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Messor Barbarus',
            'Camponotus Ligniperdus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('hits in title outweight hits in text', () async {
      List<FAQItem> orderedItems = await TestFAQSorter()
          .sortItems('Netter Fleißig friedlich Ligniperdus', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Messor Barbarus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('is not case sensitive', () async {
      List<FAQItem> orderedItems = await TestFAQSorter()
          .sortItems('RäUbEr CaMpoNoTuS lIgNiPeRdUs', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Lasius Niger',
            'Camponotus Ligniperdus',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('finds sub-words', () async {
      List<FAQItem> orderedItems =
          await TestFAQSorter().sortItems('europa unscheinbar welt', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Lasius Niger',
            'Camponotus Ligniperdus',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('does not change original items order', () async {
      var items = testItems;
      await TestFAQSorter().sortItems('Lasius Messor Barbarus', items);

      expect(
          items.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('can handle multiple spaces and all kind of blanks', () async {
      List<FAQItem> orderedItems = await TestFAQSorter()
          .sortItems('Lasius     Messor\n\tBarbarus', testItems);

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Messor Barbarus',
            'Lasius Niger',
            'Camponotus Ligniperdus',
          ]));
    ***REMOVED***);
  ***REMOVED***);

  group('DemoFAQService', () {
    test('delivers demo faq items', () async {
      var faq = await DemoFAQService().getSortedFAQ(null);

      expect(faq, isNotNull);
      expect(faq.length, 4);
      expect(faq[0].title, 'Wann geht\'s los?');
      expect(faq[1].title, 'Was sind die Stufen des Volksbegehrens?');
      expect(faq[2].title, 'Sammeltipps');
      expect(faq[3].title, 'Feedback und Fehlermeldungen');
    ***REMOVED***);

    test('uses sorter', () async {
      var faqUnsorted = await DemoFAQService().getSortedFAQ(null);
      var faqSorted = await DemoFAQService().getSortedFAQ('Erfolg');

      expect(faqSorted.map((e) => e.id).toList(),
          containsAll(faqUnsorted.map((e) => e.id)));
      expect(faqSorted.map((e) => e.id).toList(),
          isNot(containsAllInOrder(faqUnsorted.map((e) => e.id))));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***

var testItems = [
  FAQItem(1, 'Camponotus Ligniperdus', 'Die dickste Ameise', ' in Mitteleuropa',
      1.0, ['Holz', 'Ameise', 'rot', 'schwarz']),
  FAQItem(2, 'Lasius Niger', 'Die unscheinbaren Herrscher', ' der Krabbelwelt',
      2.0, ['Räuber', 'Erdnester', 'schwarz']),
  FAQItem(
      3,
      'Messor Barbarus',
      'Netter als ihr Name vermuten lässt.',
      ' Fleißig und friedlich.',
      3.0,
      ['Sammler', 'Erdnester', 'rot', 'schwarz']),
];

class TestFAQSorter with FAQSorter {***REMOVED***
