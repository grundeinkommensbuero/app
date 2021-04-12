import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/FAQ.dart';
import 'package:sammel_app/services/FAQService.dart';

import '../services/FAQService_test.dart';
import '../shared/mocks.mocks.dart';
import '../shared/mocks.trainer.dart';

main() {
  trainTranslation(MockTranslations());
  final service = DemoFAQService();
  final faq = FAQ();

  setUpUI((WidgetTester tester) async {
    service.faqItems = testItems;
    await tester.pumpWidget(MaterialApp(
        home: Provider<AbstractFAQService>.value(value: service, child: faq)));
    await tester.pumpAndSettle();
  ***REMOVED***);

  group('visualisation', () {
    testUI('starts', (WidgetTester _) async {
      expect(find.byKey(Key('faq page')), findsOneWidget);
    ***REMOVED***);

    testUI('shows all items', (WidgetTester tester) async {
      expect(find.byKey(Key('item tile')), findsNWidgets(testItems.length));
    ***REMOVED***);

    testUI('initially shows all items closed', (WidgetTester tester) async {
      var itemTiles = tester.widgetList<FAQTile>(find.byKey(Key('item tile')));

      itemTiles.forEach((tile) => expect(tile.extended, isFalse));
      testItems
          .forEach((item) => expect(find.text(item.teaser), findsOneWidget));
      testItems.forEach((item) => expect(find.text(item.rest!), findsNothing));
    ***REMOVED***);
  ***REMOVED***);

  group('open/close', () {
    testUI('opens on tap at tile', (WidgetTester tester) async {
      await tester.tap(find.text(testItems[0].title));
      await tester.pump();

      expect(find.text(testItems[0].full), findsOneWidget);
    ***REMOVED***);

    testUI('closes on second tap at tile', (WidgetTester tester) async {
      await tester.tap(find.text(testItems[1].title));
      await tester.pump();

      expect(find.text(testItems[1].teaser), findsNothing);
      expect(find.text(testItems[1].full), findsOneWidget);

      await tester.tap(find.text(testItems[1].title));
      await tester.pump();

      expect(find.text(testItems[1].teaser), findsOneWidget);
      expect(find.text(testItems[1].full), findsNothing);
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
          containsAllInOrder([
            'Camponotus Ligniperdus',
            'Lasius Niger',
            'Messor Barbarus',
          ]));
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
