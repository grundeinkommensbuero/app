import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/TermineService.dart';

import '../model/Ort_test.dart';
import '../model/Termin_test.dart';

void main() {
  // nöig wegen dem Laden des Zertifikats
  TestWidgetsFlutterBinding.ensureInitialized();

  var service = DemoTermineService();

  test('DemoTermineService creates new Termin', () async {
    expect((await service.ladeTermine(TermineFilter.leererFilter())).length, 4);

    var response = await service.createTermin(
        Termin(
            null,
            DateTime.now(),
            Jiffy(DateTime.now()).add(days: 1),
            Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
                52.51579, 13.45399),
            'Sammeln',
            52.52116,
            13.41331,
            TerminDetails(
                'U-Bahnhof Samariterstraße',
                'wir gehen die Frankfurter Allee hoch',
                'Ihr erreicht uns unter 0234567')),
        '');

    expect(response.id, 5);
    expect((await service.ladeTermine(TermineFilter.leererFilter())).length, 5);
  ***REMOVED***);

  test('DemoTermineService deletes action', () async {
    var actionsBefore = await service.ladeTermine(TermineFilter.leererFilter());
    expect(actionsBefore.map((action) => action.id), containsAll([1, 2, 3, 4]));

    await service.deleteAction(actionsBefore[1], '');

    var actionsAfter = await service.ladeTermine(TermineFilter.leererFilter());
    expect(actionsAfter.map((action) => action.id), containsAll([1, 3, 4]));
  ***REMOVED***);

  test('DemoTerminService stores new action', () async {
    expect(service.termine[0].typ, 'Sammeln');
    expect(service.termine[0].ort.id, 1);
    expect(service.termine[0].details.kontakt, 'Ruft mich an unter 01234567');

    await service.saveAction(
        TerminTestDaten.einTermin()
          ..id = 1
          ..typ = 'Infoveranstaltung'
          ..ort = treptowerPark()
          ..details = TerminDetails('bla', 'blub', 'Test123'),
        '');

    expect(service.termine[0].typ, 'Infoveranstaltung');
    expect(service.termine[0].ort.id, 2);
    expect(service.termine[0].details.kontakt, 'Test123');
  ***REMOVED***);
***REMOVED***
