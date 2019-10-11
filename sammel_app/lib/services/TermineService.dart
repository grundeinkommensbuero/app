import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/Service.dart';

class TermineService extends Service {
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
