import 'dart:convert';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/services/RestFehler.dart';

import 'Service.dart';
import 'Benutzer.dart';

class BenutzerService extends Service {
  Future<Authentifizierung> authentifziereBenutzer(Login login) async {
    print('Authentifiziere Benutzer ${login.benutzer.name}');
    HttpClientResponseBody response;
    try {
      response = await post(
          Uri(path: '/service/benutzer/authentifiziere'), jsonEncode(login));
    } on WrongResponseFormatException catch (e, t) {
      // TODO Log
      print('Exception bei Authentifizierung: ${e.message}\n$t');
      throw LoginException('Vom Server kommt eine fehlerhafte Antwort');
    }
    if (response.response.statusCode == 200) {
      return Authentifizierung(true);
    }

    if (response.response.statusCode == 412) {
      var fehler = RestFehler.deserialisiere(response.body);
      return Authentifizierung(false, fehler.meldung);
    }

    if (response.response.statusCode == 401) {
      var fehler = RestFehler.deserialisiere(response.body);
      print('Authentifizierung von Benutzer ${login.benutzer.name} '
          'fehlgeschlagen: ${fehler.meldung}.');
      return Authentifizierung(false, fehler.meldung);
    } else {
      // Unerwarteter Fehler
      throw Exception(
          'HTTP-Status: ${response.response.statusCode}\n ${body(response.body)}');
    }
  }

  legeBenutzerAn(Login login) async {
    var response = await post(
      Uri.parse('/service/benutzer/neu'),
      jsonEncode(login),
    );

    if (response.response.statusCode == 200) {
      return;
    }

    if (response.response.statusCode == 412) {
      print('Fehler: $response');
      final RestFehler restFehler = RestFehler.deserialisiere(response.body);
      throw LoginException(restFehler.meldung);
    } else {
      // Unerwarteter Fehler
      //TODO LOG
      print('Fehler: $response');
      throw Exception(
          'HTTP-Status: ${response.response.statusCode}\n ${response.body}');
    }
  }
}

class Login {
  Benutzer benutzer;
  String passwortHash;

  Login.ausName(name, this.passwortHash) {
    this.benutzer = Benutzer(name);
  }

  Login(this.benutzer, this.passwortHash);

  Map<String, dynamic> toJson() =>
      {'benutzer': benutzer, 'passwortHash': passwortHash};
}

class Authentifizierung {
  bool erfolgreich = false;
  String meldung = '';

  Authentifizierung(this.erfolgreich, [this.meldung]);
}

class LoginException {
  final String message;

  LoginException(this.message);
}
