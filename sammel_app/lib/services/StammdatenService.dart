import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/services/RestFehler.dart';

import 'Service.dart';

abstract class AbstractStammdatenService extends Service {
  Future<List<Ort>> ladeOrte();
}

class StammdatenService extends AbstractStammdatenService {
  Future<List<Ort>> ladeOrte() async {
    HttpClientResponseBody response =
        await get(Uri.parse('/service/stammdaten/orte'));
    if (response.response.statusCode == 200) {
      final orte = (response.body as List)
          .map((jsonOrt) => Ort.fromJson(jsonOrt))
          .toList();
      return orte;
    } else {
      throw RestFehler("Unerwarteter Fehler: "
          "${response.response.statusCode} - ${response.body}");
    }
  }
}

class DemoStammdatenService extends AbstractStammdatenService {
  static Ort nordkiez =
      Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez');
  static Ort treptowerPark = Ort(2, 'Treptow-Köpenick', 'Treptower Park');
  static Ort goerli =
      Ort(3, 'Friedrichshain-Kreuzberg', 'Görlitzer Park und Umgebung');

  static List<Ort> orte = [nordkiez, treptowerPark, goerli];

  Future<List<Ort>> ladeOrte() async => orte;
}
