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
      return (jsonDecode(response.body) as List)
          .map((jsonTermin) => Termin.fromJson(jsonTermin))
          .toList();
    } else {
      throw RestFehler(
          "Unerwarteter Fehler: ${response.statusCode} - ${response.body}");
    }
  }
}
