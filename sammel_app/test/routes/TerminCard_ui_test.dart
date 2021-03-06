import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import '../shared/mocks.trainer.dart';
import '../shared/TestdatenVorrat.dart';
import '../shared/mocks.mocks.dart';

void main() {
  trainTranslation(MockTranslations());
  initializeDateFormatting('de');

  testWidgets('TerminCard startet fehlerfrei', (WidgetTester tester) async {
    var termin = Termin(0, DateTime.now(), DateTime.now(), ffAlleeNord(),
        'Sammeln', 52.52116, 13.41331, [], null);

    await tester.pumpWidget(MaterialApp(home: TerminCard(termin)));

    expect(find.text(termin.typ), findsOneWidget);
    expect(find.text(TerminCard.erzeugeOrtText(termin.ort)), findsOneWidget);
  });
}
