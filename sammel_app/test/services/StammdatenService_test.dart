import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/services/StammdatenService.dart';

class HttpClientMock extends Mock implements HttpClient {***REMOVED***

void main() {
  // nöig wegen dem Laden des Zertifikats
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DemoStammdatenService', () {
    test('liefert Orte Aus', () async {
      var testStammdatenService = DemoStammdatenService();
      List<Ort> ergebnis = await testStammdatenService.ladeOrte();
      expect(ergebnis.length, 3);
      expect(ergebnis[0].id.toString() + ergebnis[0].bezirk + ergebnis[0].ort,
          '1Friedrichshain-KreuzbergFriedrichshain Nordkiez');
      expect(ergebnis[1].id.toString() + ergebnis[1].bezirk + ergebnis[1].ort,
          '2Treptow-KöpenickTreptower Park');
      expect(ergebnis[2].id.toString() + ergebnis[2].bezirk + ergebnis[2].ort,
          '3Friedrichshain-KreuzbergGörlitzer Park und Umgebung');
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
