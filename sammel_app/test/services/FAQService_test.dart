import 'package:flutter_test/flutter_test.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:sammel_app/services/FAQService.dart';

import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

final _storageService = MockStorageService();
final _userService = MockUserService();
final _backend = MockBackend();

main() {
  setUp(() {
    reset(_storageService);
    reset(_userService);
    reset(_backend);
    trainUserService(_userService);
    trainBackend(_backend);
    when(_storageService.loadFAQ()).thenAnswer((_) => Future.value(testItems));
    when(_backend.get('service/faq', any)).thenAnswer((_) =>
    Future<HttpClientResponseBody>.value(
        trainHttpResponse(MockHttpClientResponseBody(), 200, [
          {
            "id": 4,
            "title": "Myrmica Ruginodis",
            "teaser": "Klein aber gemein",
            "order": 4.0,
            "tags": ["gelb", "braun", "giftig"]
          ***REMOVED***
        ])));
  ***REMOVED***);

  group('mixin', () {
    test('orders by number of hits in tags', () async {
      List<FAQItem> orderedItems =
          TestFAQSorter().sortItems('Ameise rot Holz', testItems)!;

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
          TestFAQSorter().sortItems('Lasius Niger Messor', testItems)!;

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
          TestFAQSorter().sortItems('Holz Lasius Niger', testItems)!;

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('orders by number of hits in content text', () async {
      List<FAQItem> orderedItems = TestFAQSorter().sortItems(
          'Netter Fleißig friedlich dickste Herrscher Mitteleuropa',
          testItems)!;

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Messor Barbarus',
            'Camponotus Ligniperdus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('hits in title outweight hits in text', () async {
      List<FAQItem> orderedItems = TestFAQSorter()
          .sortItems('Netter Fleißig friedlich Ligniperdus', testItems)!;

      expect(
          orderedItems.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Messor Barbarus',
            'Lasius Niger',
          ]));
    ***REMOVED***);

    test('is not case sensitive', () async {
      List<FAQItem> orderedItems = TestFAQSorter()
          .sortItems('RäUbEr CaMpoNoTuS lIgNiPeRdUs', testItems)!;

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
          TestFAQSorter().sortItems('europa unscheinbar welt', testItems)!;

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
      TestFAQSorter().sortItems('Lasius Messor Barbarus', items);

      expect(
          items.map((item) => item.title),
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);

    test('can handle multiple spaces and all kind of blanks', () async {
      List<FAQItem> orderedItems = TestFAQSorter()
          .sortItems('Lasius     Messor\n\tBarbarus', testItems)!;

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
      var faq = await DemoFAQService().getSortedFAQ(null).first;

      expect(faq, isNotNull);
      expect(faq!.length, 4);
      expect(faq[0].title, 'Wann geht\'s los?');
      expect(faq[1].title, 'Was sind die Stufen des Volksbegehrens?');
      expect(faq[2].title, 'Sammeltipps');
      expect(faq[3].title, 'Feedback und Fehlermeldungen');
    ***REMOVED***);

    test('uses sorter', () async {
      final faqUnsorted = await DemoFAQService().getSortedFAQ(null).first;
      final faqSorted = await DemoFAQService().getSortedFAQ('Erfolg').first;

      expect(faqSorted!.map((e) => e.id).toList(),
          containsAll(faqUnsorted!.map((e) => e.id)));
      expect(faqSorted.map((e) => e.id).toList(),
          isNot(containsAllInOrder(faqUnsorted.map((e) => e.id))));
    ***REMOVED***);
  ***REMOVED***);

  group('FAQService', () {
    test('loads and returns old faq from storage on start', () async {
      var faqService = FAQService(_storageService, _userService, _backend);
      var faq = await faqService.getSortedFAQ(null).first;

      expect(faq, isNotNull);
      expect(faq!.length, 3);
      expect(faq[0].id, 1);
      expect(faq[1].id, 2);
      expect(faq[2].id, 3);

      verify(_storageService.loadFAQ()).called(1);
    ***REMOVED***);

    test('retrieves and returns new faq from server on start', () async {
      var faqService = FAQService(_storageService, _userService, _backend);

      List<FAQItem>? faq;
      faqService.getSortedFAQ(null).listen((newFaq) => faq = newFaq);
      await Future.delayed(Duration(milliseconds: 100));

      verify(_backend.get('service/faq', any)).called(1);
      expect(faq, isNotNull);
      expect(faq!.length, 1);
      expect(faq![0].id, 4);
    ***REMOVED***);

    test('stores new faq from server in storage', () async {
      var faqService = FAQService(_storageService, _userService, _backend);

      faqService.getSortedFAQ(null);
      await Future.delayed(Duration(milliseconds: 100));

      var faq = verify(_storageService.saveFAQ(captureAny)).captured;
      expect(faq.length, 1);
      expect((faq[0] as List<FAQItem>).length, 1);
      expect((faq[0] as List<FAQItem>)[0].id, 4);
      expect((faq[0] as List<FAQItem>)[0].title, 'Myrmica Ruginodis');
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
