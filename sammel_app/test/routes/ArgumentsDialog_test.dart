import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Arguments.dart';
import 'package:sammel_app/routes/ArgumentsDialog.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.mocks.dart';

main() {
  final mockStammdatenService = MockStammdatenService();
  Arguments? result = null;

  setUpUI((tester) async {
    reset(mockStammdatenService);
    when(mockStammdatenService.getKiezAtLocation(any))
        .thenAnswer((_) => Future.value(ffAlleeNord()));

    await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<StammdatenService>.value(value: mockStammdatenService)
        ],
        child: MaterialApp(
          home: Material(
            child: Builder(builder: (BuildContext context) {
              return Center(
                child: ElevatedButton(
                    key: Key('starter'),
                    child: const Text('Starter'),
                    onPressed: () async => result =
                    await showArgumentsDialog(
                        context: context,
                        coordinates: LatLng(52.49653, 13.43762))),
              );
            ***REMOVED***),
          ),
        )));
    await tester.tap(find.byKey(Key('starter')));
  ***REMOVED***);

  testUI('opens arguments dialog with all elements', (tester) async {
    await tester.pumpAndSettle();

    expect(find.byKey(Key('arguments dialog')), findsOneWidget);
    expect(find.byKey(Key('arguments input')), findsOneWidget);
    expect(find.byKey(Key('arguments dialog cancel button')), findsOneWidget);
    expect(find.byKey(Key('arguments dialog submit button')), findsOneWidget);
    expect(find.text('Vorbehalte'), findsOneWidget);
  ***REMOVED***);

  testUI('determines and shows Kiez and current Date', (tester) async {
    await tester.pumpAndSettle();

    var today = ChronoHelfer.formatDateOfDateTime(DateTime.now());
    verify(mockStammdatenService.getKiezAtLocation(LatLng(52.49653, 13.43762)))
        .called(1);

    expect(find.text('Frankfurter Allee Nord am $today'), findsOneWidget);
  ***REMOVED***);

  testUI('shows "Berlin" on start', (tester) async {
    when(mockStammdatenService.getKiezAtLocation(any))
        .thenAnswer((_) => Future.value(null));
    await tester.pump();

    var today = ChronoHelfer.formatDateOfDateTime(DateTime.now());
    expect(find.text('Berlin am $today'), findsOneWidget);
  ***REMOVED***);

  testUI('returns Arguments on submit button', (tester) async {
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(Key('arguments input')), 'Abschreckung von Investoren');
    await tester.tap(find.byKey(Key('arguments dialog submit button')));
    await tester.pump();

    expect(result?.arguments, 'Abschreckung von Investoren');
    expect(result?.date.year, DateTime.now().year);
    expect(result?.date.month, DateTime.now().month);
    expect(result?.date.day, DateTime.now().day);
    expect(result?.kiez?.name, "Frankfurter Allee Nord");
  ***REMOVED***);

  testUI('returns no Arguments on cancel button', (tester) async {
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(Key('arguments input')), 'Abschreckung von Investoren');
    await tester.tap(find.byKey(Key('arguments dialog cancel button')));
    await tester.pump();

    expect(result, isNull);
  ***REMOVED***);
***REMOVED***
