import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/TermineService.dart';

void main() {
  var service = DemoTermineService();

  test('DemoTermineService creates new Termin', () async {
    expect(
        (await service.ladeTermine(TermineFilter.leererFilter())).length,
        4);

    var response = await service.createTermin(Termin(
        null,
        DateTime.now(),
        Jiffy(DateTime.now()).add(days: 1),
        Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez'),
        'Sammel-Termin',
        TerminDetails(
            'U-Bahnhof Samariterstraße',
            'wir gehen die Frankfurter Alle hoch',
            'Ihr erreicht uns unter 0234567')));

    expect(response.id, 5);
    expect(
        (await service.ladeTermine(TermineFilter.leererFilter())).length,
        5);
  });
}
