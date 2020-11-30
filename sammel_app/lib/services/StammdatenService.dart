import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/services/ErrorService.dart';

import 'BackendService.dart';
import 'UserService.dart';

abstract class AbstractStammdatenService extends BackendService {
  Future<List<Ort>> ladeOrte();

  AbstractStammdatenService(AbstractUserService userService,
      [Backend backendMock])
      : super(userService, backendMock);
***REMOVED***

class StammdatenService extends AbstractStammdatenService {
  StammdatenService(AbstractUserService userService, [Backend backendMock])
      : super(userService, backendMock);

  Future<List<Ort>> ladeOrte() async {
    try {
      HttpClientResponseBody response = await get('/service/stammdaten/orte');

      final orte = (response.body as List)
          .map((jsonOrt) => Ort.fromJson(jsonOrt))
          .toList();
      return orte;
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e,
          additional: 'Orte konnten nicht geladen werden.');
      return [];
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoStammdatenService extends AbstractStammdatenService {
  DemoStammdatenService(
    userService,
  ) : super(userService, DemoBackend());

  static Ort nordkiez = Ort(1, 'Friedrichshain-Kreuzberg',
      'Friedrichshain Nordkiez', 52.51579, 13.45399);
  static Ort treptowerPark =
      Ort(2, 'Treptow-Köpenick', 'Treptower Park', 52.48993, 13.46839);
  static Ort goerli = Ort(3, 'Friedrichshain-Kreuzberg',
      'Görlitzer Park und Umgebung', 52.49653, 13.43762);

  static List<Ort> orte = [nordkiez, treptowerPark, goerli];

  Future<List<Ort>> ladeOrte() async => orte;
***REMOVED***
