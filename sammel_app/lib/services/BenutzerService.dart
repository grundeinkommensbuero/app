import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sammel_app/services/RestFehler.dart';

import 'Benutzer.dart';

class BenutzerService {
  Map<String, String> _header = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*/*",
  };

  Future<bool> authentifziereBenutzer(Login login,
      [BuildContext context]) async {
    print('Authentifiziere Benutzer ${login.benutzer.name}');
    var response = await http.post(
      Uri.http('10.0.2.2:18080', '/service/benutzer/authentifiziere'),
      headers: _header,
      body: jsonEncode(login),
    );

    if (response.statusCode == 200) {
      return true;
    }

    if (response.statusCode == 412) {
      var fehler = RestFehler.deserialisiere(response.body);
      // TODO Usermeldung in GUI
      print('Eingabefehler für ${login.benutzer.name}: ${fehler.meldung}');
      if (context != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Fehler"),
                content: Text(fehler.meldung),
              );
            });
      }
      return false;
    }

    if (response.statusCode == 401) {
      var fehler = RestFehler.deserialisiere(response.body);
      // TODO Usermeldung in GUI
      print('Authentifizierung von Benutzer ${login.benutzer.name} '
          'fehlgeschlagen: ${fehler.meldung}.');
      if (context != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Anmelden fehlgeschlagen"),
                content: Text(fehler.meldung),
              );
            });
      }
      return false;
    } else {
      // Unerwarteter Fehler
      //LOG
      if (context != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Unerwarteter Fehler"),
                content: Text(response.body),
              );
            });
      }
      throw Exception('HTTP-Status: ${response.statusCode}\n ${response.body}');
    }
  }

  legeBenutzerAn(Login login) async {
    print('DEBUG ### lege neuen Benutzer an : ${jsonEncode(login)}');
    var response = await http.post(
      Uri.http('10.0.2.2:18080', '/service/benutzer/neu'),
      headers: _header,
      body: jsonEncode(login),
    );

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 412) {
      final RestFehler restFehler = RestFehler.deserialisiere(response.body);
      throw LoginException(restFehler.meldung);
    } else {
      // Unerwarteter Fehler
      //LOG
      throw Exception('HTTP-Status: ${response.statusCode}\n ${response.body}');
    }
  }
}

class Login {
  Benutzer benutzer;
  String passwortHash;

  Login.ausName(name, this.passwortHash) {
    this.benutzer = Benutzer(name);
  }

  Login(this.benutzer, this.passwortHash) {}

  Map<String, dynamic> toJson() =>
      {'benutzer': benutzer, 'passwortHash': passwortHash};
}

class LoginException {
  final String message;

  LoginException(this.message);
}
