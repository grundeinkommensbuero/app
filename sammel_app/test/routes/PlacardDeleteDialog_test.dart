import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/routes/PlacardDeleteDialog.dart';

main() {
  bool? returnValue;

  setUpUI((tester) async {
    returnValue = null;
    await tester
        .pumpWidget(MaterialApp(home: Builder(builder: (BuildContext context) {
      return Center(
          child: ElevatedButton(
              key: Key('starter'),
              child: const Text('Starter'),
              onPressed: () async =>
                  returnValue = await showPlacardDeleteDialog(context)));
    })));

    await tester.tap(find.byKey(Key('starter')));
    await tester.pump();
  });

  testUI('showPlacardDeleteDialog shows dialog', (tester) async {
    expect(find.byKey(Key('delete placard dialog')), findsOneWidget);
  });

  testUI('showPlacardDeleteDialog shows dialog', (tester) async {
    await tester.tap(find.byKey(Key('delete placard dialog abort button')));
    await tester.pump();

    expect(returnValue, false);
  });

  testUI('showPlacardDeleteDialog shows dialog', (tester) async {
    await tester.tap(find.byKey(Key('delete placard dialog confirm button')));
    await tester.pump();

    expect(returnValue, true);
  });
}
