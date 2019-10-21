import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/Benutzer.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/Service.dart';

abstract class AbstractTermineService extends Service {
  Future<List<Termin>> ladeTermine();
}

class TermineService extends AbstractTermineService {
  Future<List<Termin>> ladeTermine() async {
    HttpClientResponseBody response = await get(Uri.parse('/service/termine'));
    if (response.response.statusCode == 200) {
      final termine = (response.body as List).map((jsonTermin) {
        var termin = Termin.fromJson(jsonTermin);
        return termin;
      }).toList();
      // Sortierung auf Client-Seite um Server und Datenbank skalierbar zu halten
      termine
          .sort((termin1, termin2) => termin1.beginn.compareTo(termin2.beginn));
      return termine;
    } else {
      throw RestFehler(
          "Unerwarteter Fehler: ${response.response.statusCode} - ${response.body}");
    }
  }
}

class DemoTermineService extends AbstractTermineService {
  static Benutzer karl = Benutzer('Karl Marx');
  static Benutzer rosa = Benutzer('Rosa Luxemburg');
  static Ort nordkiez =
      Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez');
  static Ort treptowerPark =
      Ort(2, 'Treptow-Köpenick', 'Treptower Park');
  static Ort goerli =
      Ort(2, 'Friedrichshain-Kreuzberg', 'Görlitzer Park und Umgebung');
  static var heute = DateTime.now();
  List<Termin> termine = [
    Termin(
        1,
        DateTime(heute.year-1, heute.month-1, heute.day-1, 9, 0, 0),
        DateTime(heute.year-1, heute.month-1, heute.day-1, 12, 0, 0),
        nordkiez,
        'Sammel-Termin',
        [karl, rosa]),
    Termin(
        2,
        DateTime(heute.year, heute.month, heute.day, 11, 0, 0),
        DateTime(heute.year, heute.month, heute.day, 13, 0, 0),
        treptowerPark,
        'Sammel-Termin',
        [karl]),
    Termin(
        3,
        DateTime(heute.year, heute.month, heute.day, 23, 0, 0),
        DateTime(heute.year, heute.month, heute.day+1, 2, 0, 0),
        goerli,
        'Sammel-Termin',
        [rosa]),
    Termin(
        4,
        DateTime(heute.year, heute.month, heute.day+1, 18, 0, 0),
        DateTime(heute.year, heute.month, heute.day+1, 20, 30, 0),
        treptowerPark,
        'Info-Veranstaltung',
        [rosa, karl]),
  ];

  @override
  Future<List<Termin>> ladeTermine() async {
    return termine;
  }
}
