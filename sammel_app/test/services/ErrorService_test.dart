import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/RestFehler.dart';

void main() {
  setUp(() {
    ErrorService.messageQueue = List<List<String>>();
    ErrorService.setContext(null);
  ***REMOVED***);

  group('pushMessage', () {
    test('stores error message when waiting for build context', () {
      ErrorService.pushMessage('Titel', 'Nachricht');
      ErrorService.pushMessage('Titel', 'Nachricht');
      ErrorService.pushMessage('Titel', 'Nachricht');

      expect(ErrorService.messageQueue.length, 3);
    ***REMOVED***);

    testUI('shows error message immediately with build context',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: Builder(builder: (BuildContext context) {
            ErrorService.setContext(context);
            return Center(
              child: RaisedButton(
                  key: Key('starter'),
                  child: const Text('Starter'),
                  onPressed: () async => await ErrorService.showErrorDialog(
                      'Titel', 'Nachricht',
                      key: Key('error dialog'))),
            );
          ***REMOVED***),
        ),
      ));

      ErrorService.pushMessage('Titel', 'Nachricht');
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error dialog')), findsOneWidget);
      expect(ErrorService.messageQueue, isEmpty);
    ***REMOVED***);
  ***REMOVED***);

  group('handleError', () {
    test('recognizes and handles AuthFehler', () {
      ErrorService.handleError(AuthFehler('Nachricht'));

      expect(ErrorService.messageQueue.length, 1);
      expect(ErrorService.messageQueue[0][0],
          'Fehler bei Nutzer-Authentifizierung');
      expect(ErrorService.messageQueue[0][1],
          'Nachricht\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com');
    ***REMOVED***);

    test('recognizes and handles RestFehler', () {
      ErrorService.handleError(RestFehler('Nachricht'));

      expect(ErrorService.messageQueue.length, 1);
      expect(ErrorService.messageQueue[0][0],
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten');
      expect(ErrorService.messageQueue[0][1],
          'Nachricht\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com');
    ***REMOVED***);

    test('recognizes and handles WrongResponseFormatException', () {
      ErrorService.handleError(WrongResponseFormatException('Nachricht'));

      expect(ErrorService.messageQueue.length, 1);
      expect(ErrorService.messageQueue[0][0],
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten');
      expect(ErrorService.messageQueue[0][1],
          'Nachricht\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com');
    ***REMOVED***);

    test('adds optional message to Error text', () {
      ErrorService.handleError(RestFehler('Nachricht'),
          additional: 'Zusätzliche Info');

      expect(ErrorService.messageQueue.length, 1);
      expect(ErrorService.messageQueue[0][1],
          'Nachricht. Zusätzliche Info\n'
          'Wenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com');
    ***REMOVED***);
  ***REMOVED***);

  group('showErrorDialog', () {
    setUpUI((WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: Builder(builder: (BuildContext context) {
            ErrorService.setContext(context);
            return Center(
              child: RaisedButton(
                  key: Key('starter'),
                  child: const Text('Starter'),
                  onPressed: () async => await ErrorService.showErrorDialog(
                      'Titel', 'Nachricht',
                      key: Key('error dialog'))),
            );
          ***REMOVED***),
        ),
      ));

      await tester.tap(find.byKey(Key('starter')));
      await tester.pumpAndSettle();
    ***REMOVED***);

    testUI('starts and shows data', (WidgetTester tester) async {
      expect(find.byKey(Key('error dialog')), findsOneWidget);
      expect(find.text('Titel'), findsOneWidget);
      expect(find.text('Nachricht'), findsOneWidget);
    ***REMOVED***);

    testUI('closes on close button', (WidgetTester tester) async {
      await tester.tap(find.byKey(Key('error dialog close button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error dialog')), findsNothing);
    ***REMOVED***);
  ***REMOVED***);

  group('setContext', () {
    BuildContext context;
    setUpUI((WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Material(
        child: Builder(builder: (BuildContext newContext) {
          context = newContext;
          return Placeholder();
        ***REMOVED***),
      )));
    ***REMOVED***);

    testUI('shows dialog for every stored message',
        (WidgetTester tester) async {
      ErrorService.pushMessage('Titel1', 'Nachricht');
      ErrorService.pushMessage('Titel2', 'Nachricht');
      ErrorService.pushMessage('Titel3', 'Nachricht');

      ErrorService.setContext(context);
      await tester.pumpAndSettle();

      expect(find.text('Titel1'), findsOneWidget);
      expect(find.text('Titel2'), findsOneWidget);
      expect(find.text('Titel3'), findsOneWidget);
    ***REMOVED***);

    testUI('shows only one dialog for every stored message, when called twice',
        (WidgetTester tester) async {
      ErrorService.pushMessage('Titel1', 'Nachricht');
      ErrorService.pushMessage('Titel2', 'Nachricht');
      ErrorService.pushMessage('Titel3', 'Nachricht');

      ErrorService.setContext(context);
      ErrorService.setContext(context);
      await tester.pumpAndSettle();

      expect(find.text('Titel1'), findsOneWidget);
      expect(find.text('Titel2'), findsOneWidget);
      expect(find.text('Titel3'), findsOneWidget);
    ***REMOVED***);

    testUI('shows no dialog with empty queue', (WidgetTester tester) async {
      ErrorService.setContext(context);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error dialog')), findsNothing);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
