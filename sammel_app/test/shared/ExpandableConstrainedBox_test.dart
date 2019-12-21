import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:sammel_app/shared/ExpandableConstrainedBox.dart';

void main() {
  testWidgets('ExpandableConstrainedBox shows child',
      (WidgetTester tester) async {
    var widget =
        ExpandableConstrainedBox(child: Text('Content', key: Key('content')));
    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.byKey(Key('content')), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
  });

  testWidgets('ExpandableConstrainedBox does not accept empty child',
      (WidgetTester tester) async {
    expect(() => ExpandableConstrainedBox(child: null), throwsAssertionError);
  });
  testWidgets('ExpandableConstrainedBox accepts long child',
      (WidgetTester tester) async {
    var widget = ExpandableConstrainedBox(
        child: Text(
            'he following TestFailure object was thrown running a test:' +
                'Expected: no matching nodes in the widget tree' +
                'Actual: ?:<exactly one widget with key [<element 2>] (ignoring offstage widgets):' +
                'Text-[<element 2>]("Lorem", dependencies: [MediaQuery, DefaultTextStyle])> Which: means one was found but none were expected',
            key: Key('content')));
    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.byKey(Key('content')), findsOneWidget);
  });

  testWidgets('ExpandableConstrainedBox clips too long child',
      (WidgetTester tester) async {
    var widget = ExpandableConstrainedBox(
      child: Text(
          'Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores ',
          key: Key('element 1')),
      maxHeight: 40.0,
    );
    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.byKey(Key('element 1')), findsOneWidget);
    expect(
        (tester.widget(
                    find.byKey(Key('ExpandableConstraintBox constrained box')))
                as ConstrainedBox)
            .constraints
            .maxHeight,
        40.0);
  });

  testWidgets('ExpandableConstrainedBox expands on tap',
      (WidgetTester tester) async {
    var widget = ExpandableConstrainedBox(
      child: Text(
          'Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores ',
          key: Key('content')),
      maxHeight: 40.0,
    );
    await tester.pumpWidget(MaterialApp(home: widget));

    await tester
        .tap(find.byKey(Key('ExpandableConstraintBox constrained box')));
    await tester.pump();

    expect(find.byKey(Key('content')), findsOneWidget);
    expect(
        (tester.widget(
                    find.byKey(Key('ExpandableConstraintBox constrained box')))
                as ConstrainedBox)
            .constraints
            .maxHeight,
        double.infinity);
  });

  testWidgets('ExpandableConstrainedBox changes icon on tap',
      (WidgetTester tester) async {
    var widget = ExpandableConstrainedBox(
      child: Text(
          'Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores ',
          key: Key('content')),
      maxHeight: 40.0,
    );
    await tester.pumpWidget(MaterialApp(home: widget));

    expect(
        (tester.widget(find.byKey(Key('ExpandableConstraintBox icon'))) as Icon)
            .icon,
        Icons.keyboard_arrow_down);

    await tester
        .tap(find.byKey(Key('ExpandableConstraintBox constrained box')));
    await tester.pump();

    expect(
        (tester.widget(find.byKey(Key('ExpandableConstraintBox icon'))) as Icon)
            .icon,
        Icons.keyboard_arrow_up);
  });

  testWidgets('ExpandableConstrainedBox applies condition',
      (WidgetTester tester) async {
    var widget = ExpandableConstrainedBox(
      child: Text(
          'Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores ',
          key: Key('content')),
      maxHeight: 40.0,
      expandableCondition: true,
    );
    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.byKey(Key('content')), findsOneWidget);
    expect(find.byKey(Key('ExpandableConstraintBox constrained box')),
        findsOneWidget);
    expect(find.byKey(Key('ExpandableConstraintBox icon')), findsOneWidget);

    widget = ExpandableConstrainedBox(
      child: Text(
          'Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores Lorem ipsum dolores ',
          key: Key('content')),
      maxHeight: 40.0,
      expandableCondition: false,
    );
    await tester.pumpWidget(MaterialApp(home: widget));

    expect(find.byKey(Key('content')), findsOneWidget);
    expect(find.byKey(Key('ExpandableConstraintBox constrained box')),
        findsNothing);
    expect(find.byKey(Key('ExpandableConstraintBox icon')), findsNothing);
  });
}
