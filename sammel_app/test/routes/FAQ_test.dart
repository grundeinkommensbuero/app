import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/routes/FAQ.dart';
import 'package:sammel_app/services/FAQService.dart';

import '../services/FAQService_test.dart';
import '../shared/mocks.trainer.dart';
import '../shared/mocks.mocks.dart';

main() {
  trainTranslation(MockTranslations());
  var faq = FAQ();

  setUpUI((WidgetTester tester) async {
    FAQService.items = testItems;
    await tester.pumpWidget(MaterialApp(home: faq));
  ***REMOVED***);

  group('visualisation', () {
    testUI('starts', (WidgetTester _) async {
      expect(find.byKey(Key('faq page')), findsOneWidget);
    ***REMOVED***);

    testUI('shows all items', (WidgetTester _) async {
      expect(find.byKey(Key('item tile')),
          findsNWidgets(FAQService.items.length));
    ***REMOVED***);

    testUI('initially shows all items closed', (WidgetTester tester) async {
      var itemTiles = tester.widgetList<FAQTile>(find.byKey(Key('item tile')));

      itemTiles.forEach((tile) => expect(tile.extended, isFalse));
      FAQService.items.forEach(
          (item) => expect(find.byWidget(item.shortContent), findsOneWidget));
      FAQService.items
          .forEach((item) => expect(find.byWidget(item.content), findsNothing));
    ***REMOVED***);
  ***REMOVED***);

  group('open/close', () {
    testUI('opens on tap at tile', (WidgetTester tester) async {
      await tester.tap(find.byWidget(FAQService.items[0].shortContent));
      await tester.pump();

      expect(find.byWidget(FAQService.items[0].shortContent), findsNothing);
      expect(find.byWidget(FAQService.items[0].content), findsOneWidget);
    ***REMOVED***);

    testUI('closes on second tap at tile', (WidgetTester tester) async {
      await tester.tap(find.byWidget(FAQService.items[1].shortContent));
      await tester.pump();

      expect(find.byWidget(FAQService.items[1].shortContent), findsNothing);
      expect(find.byWidget(FAQService.items[1].content), findsOneWidget);

      await tester.tap(find.byWidget(FAQService.items[1].content));
      await tester.pump();

      expect(find.byWidget(FAQService.items[1].shortContent), findsOneWidget);
      expect(find.byWidget(FAQService.items[1].content), findsNothing);
    ***REMOVED***);
  ***REMOVED***);

  group('search', () {
    testUI('clear button deletes text field content',
        (WidgetTester tester) async {
      await tester.enterText(find.byKey(Key('faq search input')), 'Suchtext');
      await tester.pump();

      var faqState = tester.state<FAQState>(find.byWidget(faq));
      expect(faqState.searchInputController.text, 'Suchtext');

      await tester.tap(find.byKey(Key('faq search clear button')));
      await tester.pump();

      expect(faqState.searchInputController.text, '');
    ***REMOVED***);

    testUI('input sorts items', (WidgetTester tester) async {
      var itemTiles = find.byKey(Key('item tile'));
      var titlesInOrder =
          tester.widgetList<FAQTile>(itemTiles).map((tile) => tile.item.title);

      expect(
          titlesInOrder,
          containsAllInOrder(
              ['Camponotus Ligniperdus', 'Lasius Niger', 'Messor Barbarus']));

      await tester.enterText(
          find.byKey(Key('faq search input')), 'Lasius Niger Messor');
      await tester.pump();

      titlesInOrder =
          tester.widgetList<FAQTile>(itemTiles).map((tile) => tile.item.title);

      expect(
          titlesInOrder,
          containsAllInOrder(
              ['Lasius Niger', 'Messor Barbarus', 'Camponotus Ligniperdus']));
    ***REMOVED***);

    testUI('clear button resets item order', (WidgetTester tester) async {
      var itemTiles = find.byKey(Key('item tile'));
      await tester.enterText(
          find.byKey(Key('faq search input')), 'Lasius Niger Messor');
      await tester.pump();

      var titlesInOrder =
          tester.widgetList<FAQTile>(itemTiles).map((tile) => tile.item.title);

      expect(
          titlesInOrder,
          containsAllInOrder(
              ['Lasius Niger', 'Messor Barbarus', 'Camponotus Ligniperdus']));

      await tester.tap(find.byKey(Key('faq search clear button')));
      await tester.pump();

      titlesInOrder =
      tester.widgetList<FAQTile>(itemTiles).map((tile) => tile.item.title);

      expect(
          titlesInOrder,
          containsAllInOrder(
              ['Camponotus Ligniperdus', 'Lasius Niger', 'Messor Barbarus', ]));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
