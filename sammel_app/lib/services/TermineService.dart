import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/RestFehler.dart';

class TermineService {
  Map<String, String> _header = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*/*",
  };

  Future<List<Termin>> ladeTermine() async {
    var response = await http.get(
      Uri.http('10.0.2.2:18080', '/service/termine'),
      headers: _header,
    );
    if (response.statusCode == 200) {
      final termine = (jsonDecode(response.body) as List)
          .map((jsonTermin) => Termin.fromJson(jsonTermin))
          .toList();
      // Sortierung auf Client-Seite um Server und Datenbank skalierbar zu halten
      termine.sort((termin1, termin2) => termin1.beginn.compareTo(termin2.beginn));
      return termine;
    } else {
      throw RestFehler(
          "Unerwarteter Fehler: ${response.statusCode} - ${response.body}");
    }
  }
}
