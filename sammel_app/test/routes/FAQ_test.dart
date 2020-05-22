import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/routes/FAQ.dart';

main() {
  group('visualisation', () {
    testUI('starts', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FAQ()));

      expect(find.byKey(Key('faq page')), findsOneWidget);
    });
  });
}
