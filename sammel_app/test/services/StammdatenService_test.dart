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
  UserService userService = ConfiguredUserServiceMock();

  setUp(() {
    mock = BackendMock();
    service = StammdatenService(userService, mock);
  });

  group('StammdatenServer', () {
    test('delivers locations with status code 200', () async {
      when(mock.get(any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock([
                {
                  'id': 1,
                  'bezirk': 'Friedrichshain-Kreuzberg',
                  'ort': 'Friedrichshain Nordkiez',
                  'lattitude': 52.51579,
                  'longitude': 13.45399
                },
                {
                  'id': 2,
                  'bezirk': 'Friedrichshain-Kreuzberg',
                  'ort': 'Görlitzer Park und Umgebung',
                  'lattitude': 52.48993,
                  'longitude': 13.46839
                },
                {
                  'id': 3,
                  'bezirk': 'Treptow-Köpenick',
                  'ort': 'Treptower Park',
                  'lattitude': 52.49653,
                  'longitude': 13.43762
                },
              ], 200));

      var result = await service.kieze;

      verify(mock.get('/service/stammdaten/orte', any)).called(1);

      expect(result.length, 3);
      expect(result[0].bezirk, 'Friedrichshain-Kreuzberg');
      expect(result[0].plz, 'Friedrichshain Nordkiez');
      expect(result[0].latitude, 52.51579);
      expect(result[0].longitude, 13.45399);
      expect(result[1].bezirk, 'Friedrichshain-Kreuzberg');
      expect(result[1].plz, 'Görlitzer Park und Umgebung');
      expect(result[1].latitude, 52.48993);
      expect(result[1].longitude, 13.46839);
      expect(result[2].bezirk, 'Treptow-Köpenick');
      expect(result[2].plz, 'Treptower Park');
      expect(result[2].latitude, 52.49653);
      expect(result[2].longitude, 13.43762);
    });

    test('can handle empty lists', () async {
      when(mock.get(any, any))
          .thenAnswer((_) async => HttpClientResponseBodyMock([], 200));

      var result = await service.kieze;

      expect(result, isEmpty);
    });
  });

  group('DemoStammdatenService', () {
    DemoStammdatenService service;
    setUp(() {
      service = DemoStammdatenService(userService);
    });

    test('uses DemoBackend', () {
      expect(service.backend is DemoBackend, true);
    });

    test('liefert Orte Aus', () async {
      List<Kiez> ergebnis = await service.kieze;
      expect(ergebnis.length, 3);
      expect(ergebnis[0].bezirk + ergebnis[0].plz,
          'Friedrichshain-KreuzbergFriedrichshain Nordkiez');
      expect(ergebnis[1].bezirk + ergebnis[1].plz,
          'Treptow-KöpenickTreptower Park');
      expect(ergebnis[2].bezirk + ergebnis[2].plz,
          'Friedrichshain-KreuzbergGörlitzer Park und Umgebung');
    });
  });
}
