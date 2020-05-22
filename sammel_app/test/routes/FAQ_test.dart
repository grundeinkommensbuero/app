import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/routes/FAQ.dart';
import 'package:sammel_app/services/HelpService.dart';

import '../services/HelpService_test.dart';

main() {
  var faq = FAQ();
  setUpUI((WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: faq));
  });

  group('visualisation', () {
    testUI('starts', (WidgetTester _) async {
      expect(find.byKey(Key('faq page')), findsOneWidget);
    });

    testUI('shows all helps', (WidgetTester _) async {
      expect(find.byKey(Key('help tile')),
          findsNWidgets(HelpService.helps.length));
    });

    testUI('initially shows all helps closed', (WidgetTester tester) async {
      var helpTiles = tester.widgetList<HelpTile>(find.byKey(Key('help tile')));

      helpTiles.forEach((tile) => expect(tile.extended, isFalse));
      HelpService.helps.forEach(
          (help) => expect(find.byWidget(help.shortContent), findsOneWidget));
      HelpService.helps
          .forEach((help) => expect(find.byWidget(help.content), findsNothing));
    });
  });

  group('open/close', () {
    testUI('opens on tap at tile', (WidgetTester tester) async {
      await tester.tap(find.byWidget(HelpService.helps[0].shortContent));
      await tester.pump();

      expect(find.byWidget(HelpService.helps[0].shortContent), findsNothing);
      expect(find.byWidget(HelpService.helps[0].content), findsOneWidget);
    });

    testUI('closes on second tap at tile', (WidgetTester tester) async {
      await tester.tap(find.byWidget(HelpService.helps[1].shortContent));
      await tester.pump();

      expect(find.byWidget(HelpService.helps[1].shortContent), findsNothing);
      expect(find.byWidget(HelpService.helps[1].content), findsOneWidget);

      await tester.tap(find.byWidget(HelpService.helps[1].content));
      await tester.pump();

      expect(find.byWidget(HelpService.helps[1].shortContent), findsOneWidget);
      expect(find.byWidget(HelpService.helps[1].content), findsNothing);
    });
  });

  group('search', () {
    testUI('clear button deletes text field content',
        (WidgetTester tester) async {
      await tester.enterText(find.byKey(Key('faq search input')), 'Suchtext');
      await tester.pump();

      var faqState = tester.state<FAQState>(find.byWidget(faq));
      expect(faqState.searchInputController.text, 'Suchtext');

      await tester.tap(find.byKey(Key('search clear button')));
      await tester.pump();

      expect(faqState.searchInputController.text, '');
    });

    testUI('input sorts items', (WidgetTester tester) async {
      HelpService.helps = testHelps;

      var helpTiles = find.byKey(Key('help tile'));
      var titlesInOrder =
          tester.widgetList<HelpTile>(helpTiles).map((tile) => tile.help.title);

      expect(
          titlesInOrder,
          containsAllInOrder(
              ['Camponotus Ligniperdus', 'Lasius Niger', 'Messor Barbarus']));

      await tester.enterText(
          find.byKey(Key('faq search input')), 'Lasius Niger Messor');
      await tester.pump();

      titlesInOrder =
          tester.widgetList<HelpTile>(helpTiles).map((tile) => tile.help.title);

      expect(
          titlesInOrder,
          containsAllInOrder(
              ['Lasius Niger', 'Messor Barbarus', 'Camponotus Ligniperdus']));
    });
  });
}
