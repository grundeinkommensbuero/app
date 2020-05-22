import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/routes/FAQ.dart';
import 'package:sammel_app/services/HelpService.dart';

main() {
  setUpUI((WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: FAQ()));
  ***REMOVED***);

  group('visualisation', () {
    testUI('starts', (WidgetTester _) async {
      expect(find.byKey(Key('faq page')), findsOneWidget);
    ***REMOVED***);

    testUI('shows all helps', (WidgetTester _) async {
      expect(find.byKey(Key('help tile')),
          findsNWidgets(HelpService.helps.length));
    ***REMOVED***);

    testUI('initially shows all helps closed', (WidgetTester tester) async {
      var helpTiles = tester.widgetList<HelpTile>(find.byKey(Key('help tile')));

      helpTiles.forEach((tile) => expect(tile.extended, isFalse));
      HelpService.helps.forEach(
          (help) => expect(find.byWidget(help.shortContent), findsOneWidget));
      HelpService.helps
          .forEach((help) => expect(find.byWidget(help.content), findsNothing));
    ***REMOVED***);
  ***REMOVED***);

  group('open/close', () {
    testUI('opens on tap at tile', (WidgetTester tester) async {
      await tester.tap(find.byWidget(HelpService.helps[0].shortContent));
      await tester.pump();

      expect(find.byWidget(HelpService.helps[0].shortContent), findsNothing);
      expect(find.byWidget(HelpService.helps[0].content), findsOneWidget);
    ***REMOVED***);

    testUI('closes on second tap at tile', (WidgetTester tester) async {
      await tester.tap(find.byWidget(HelpService.helps[1].shortContent));
      await tester.pump();

      expect(find.byWidget(HelpService.helps[1].shortContent), findsNothing);
      expect(find.byWidget(HelpService.helps[1].content), findsOneWidget);

      await tester.tap(find.byWidget(HelpService.helps[1].content));
      await tester.pump();

      expect(find.byWidget(HelpService.helps[1].shortContent), findsOneWidget);
      expect(find.byWidget(HelpService.helps[1].content), findsNothing);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
