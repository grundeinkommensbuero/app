import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';

void main() {
  group('DemoStammdatenService', () {
    DemoStammdatenService service;
    setUp(() {
      service = DemoStammdatenService();
    });

    test('uses DemoBackend', () {
      expect(service.backend is DemoBackend, true);
    });

    test('liefert Orte Aus', () async {
      List<Ort> ergebnis = await service.ladeOrte();
      expect(ergebnis.length, 3);
      expect(ergebnis[0].id.toString() + ergebnis[0].bezirk + ergebnis[0].ort,
          '1Friedrichshain-KreuzbergFriedrichshain Nordkiez');
      expect(ergebnis[1].id.toString() + ergebnis[1].bezirk + ergebnis[1].ort,
          '2Treptow-KöpenickTreptower Park');
      expect(ergebnis[2].id.toString() + ergebnis[2].bezirk + ergebnis[2].ort,
          '3Friedrichshain-KreuzbergGörlitzer Park und Umgebung');
    });
  });
}
