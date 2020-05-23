import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/services/RestFehler.dart';

import 'BackendService.dart';

abstract class AbstractStammdatenService extends BackendService {
  Future<List<Ort>> ladeOrte();

  AbstractStammdatenService([Backend backendMock]) : super(backendMock);
***REMOVED***

class StammdatenService extends AbstractStammdatenService {
  StammdatenService([Backend backendMock]) : super(backendMock);

  Future<List<Ort>> ladeOrte() async {
    HttpClientResponseBody response =
        await backend.get('/service/stammdaten/orte');
    if (response.response.statusCode == 200) {
      final orte = (response.body as List)
          .map((jsonOrt) => Ort.fromJson(jsonOrt))
          .toList();
      return orte;
    ***REMOVED*** else {
      throw RestFehler('Unerwarteter Fehler: '
          "${response.response.statusCode***REMOVED*** - ${response.body***REMOVED***");
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoStammdatenService extends AbstractStammdatenService {
  DemoStammdatenService() : super(DemoBackend());

  static Ort nordkiez = Ort(1, 'Friedrichshain-Kreuzberg',
      'Friedrichshain Nordkiez', 52.51579, 13.45399);
  static Ort treptowerPark =
      Ort(2, 'Treptow-Köpenick', 'Treptower Park', 52.48993, 13.46839);
  static Ort goerli = Ort(3, 'Friedrichshain-Kreuzberg',
      'Görlitzer Park und Umgebung', 52.49653, 13.43762);

  static List<Ort> orte = [nordkiez, treptowerPark, goerli];

  Future<List<Ort>> ladeOrte() async => orte;
***REMOVED***
