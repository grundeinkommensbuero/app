import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:test/test.dart';

import '../shared/Mocks.dart';

void main() {
  Backend mock;
  StammdatenService service;
  UserService userService = UserServiceMock();

  setUp(() {
    mock = BackendMock();
    service = StammdatenService(mock);
  ***REMOVED***);

  group('StammdatenServer', () {
    test('delivers locations with status code 200', () async {
      when(mock.get(any, any)).thenAnswer((_) async =>
          HttpClientResponseBodyMock([
            {
              'id': 1,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Friedrichshain Nordkiez',
              'lattitude': 52.51579,
              'longitude': 13.45399
            ***REMOVED***,
            {
              'id': 2,
              'bezirk': 'Friedrichshain-Kreuzberg',
              'ort': 'Görlitzer Park und Umgebung',
              'lattitude': 52.48993,
              'longitude': 13.46839
            ***REMOVED***,
            {
              'id': 3,
              'bezirk': 'Treptow-Köpenick',
              'ort': 'Treptower Park',
              'lattitude': 52.49653,
              'longitude': 13.43762
            ***REMOVED***,
          ], 200));

      var result = await service.ladeOrte();

      verify(mock.get('/service/stammdaten/orte', any)).called(1);

      expect(result.length, 3);
      expect(result[0].id, 1);
      expect(result[0].bezirk, 'Friedrichshain-Kreuzberg');
      expect(result[0].ort, 'Friedrichshain Nordkiez');
      expect(result[0].latitude, 52.51579);
      expect(result[0].longitude, 13.45399);
      expect(result[1].id, 2);
      expect(result[1].bezirk, 'Friedrichshain-Kreuzberg');
      expect(result[1].ort, 'Görlitzer Park und Umgebung');
      expect(result[1].latitude, 52.48993);
      expect(result[1].longitude, 13.46839);
      expect(result[2].id, 3);
      expect(result[2].bezirk, 'Treptow-Köpenick');
      expect(result[2].ort, 'Treptower Park');
      expect(result[2].latitude, 52.49653);
      expect(result[2].longitude, 13.43762);
    ***REMOVED***);

    test('can handle empty lists', () async {
      when(mock.get(any, any)).thenAnswer((_) async =>
          HttpClientResponseBodyMock([], 200));

      var result = await service.ladeOrte();

      expect(result, isEmpty);
    ***REMOVED***);
  ***REMOVED***);

  group('DemoStammdatenService', () {
    DemoStammdatenService service;
    setUp(() {
      service = DemoStammdatenService(userService);
    ***REMOVED***);

    test('uses DemoBackend', () {
      expect(service.backend is DemoBackend, true);
    ***REMOVED***);

    test('liefert Orte Aus', () async {
      List<Ort> ergebnis = await service.ladeOrte();
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
