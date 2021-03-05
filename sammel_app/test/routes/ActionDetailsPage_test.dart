import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionDetailsPage.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';

import '../model/Termin_test.dart';
import '../shared/Mocks.dart';

final storageServiceMock = StorageServiceMock();

main() {
  Widget widget;

  Function(Termin) joinAction = (_) {};
  Function(Termin) leaveAction = (_) {};

  mockTranslation();

  setUp(() async {
    reset(storageServiceMock);
    when(storageServiceMock.loadAllStoredEvaluations())
        .thenAnswer((_) async => []);

    Termin termin = TerminTestDaten.einTerminMitTeilisUndDetails();

    widget = MultiProvider(
        providers: [
          Provider<AbstractTermineService>.value(value: TermineServiceMock()),
          Provider<ChatMessageService>.value(value: ChatMessageServiceMock()),
          Provider<StorageService>.value(value: storageServiceMock),
          Provider<AbstractUserService>.value(
              value: ConfiguredUserServiceMock()),
        ],
        child: MaterialApp(
            home: Dialog(
                child: ActionDetailsPage(
                    termin, false, false, joinAction, leaveAction))));
  });

  testWidgets('opens', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byKey(Key('action details page')), findsOneWidget);
  });

  testWidgets('shows action values', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(
        find.text(
            'Frankfurter Allee Nord in Friedrichshain\n Treffpunkt: Weltzeituhr'),
        findsOneWidget);
    expect(find.text('Bringe Westen und Klämmbretter mit'), findsOneWidget);
    expect(find.text('Ruft an unter 012345678'), findsOneWidget);
  });

  testWidgets('shows map with marker', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byKey(Key('action details map')), findsOneWidget);
    expect(find.byKey(Key('action details map marker')), findsOneWidget);
  });
}
