import 'dart:convert';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/services/RestFehler.dart';

import 'Service.dart';
import 'Benutzer.dart';

class BenutzerService extends Service {
  Future<Authentifizierung> authentifziereBenutzer(Login login) async {
    print('Authentifiziere Benutzer ${login.benutzer.name***REMOVED***');
    HttpClientResponseBody response;
    try {
      response = await post(
          Uri(path: '/service/benutzer/authentifiziere'), jsonEncode(login));
    ***REMOVED*** on WrongResponseFormatException catch (e, t) {
      // TODO Log
      print('Exception bei Authentifizierung: ${e.message***REMOVED***\n$t');
      throw LoginException('Vom Server kommt eine fehlerhafte Antwort');
    ***REMOVED***
    if (response.response.statusCode == 200) {
      return Authentifizierung(true);
    ***REMOVED***

    if (response.response.statusCode == 412) {
      var fehler = RestFehler.deserialisiere(response.body);
      return Authentifizierung(false, fehler.meldung);
    ***REMOVED***

    if (response.response.statusCode == 401) {
      var fehler = RestFehler.deserialisiere(response.body);
      print('Authentifizierung von Benutzer ${login.benutzer.name***REMOVED*** '
          'fehlgeschlagen: ${fehler.meldung***REMOVED***.');
      return Authentifizierung(false, fehler.meldung);
    ***REMOVED*** else {
      // Unerwarteter Fehler
      throw Exception(
          'HTTP-Status: ${response.response.statusCode***REMOVED***\n ${body(response.body)***REMOVED***');
    ***REMOVED***
  ***REMOVED***

  legeBenutzerAn(Login login) async {
    var response = await post(
      Uri.parse('/service/benutzer/neu'),
      jsonEncode(login),
    );

    if (response.response.statusCode == 200) {
      return;
    ***REMOVED***

    if (response.response.statusCode == 412) {
      print('Fehler: $response');
      final RestFehler restFehler = RestFehler.deserialisiere(response.body);
      throw LoginException(restFehler.meldung);
    ***REMOVED*** else {
      // Unerwarteter Fehler
      //TODO LOG
      print('Fehler: $response');
      throw Exception(
          'HTTP-Status: ${response.response.statusCode***REMOVED***\n ${response.body***REMOVED***');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class Login {
  Benutzer benutzer;
  String passwortHash;

  Login.ausName(name, this.passwortHash) {
    this.benutzer = Benutzer(name);
  ***REMOVED***

  Login(this.benutzer, this.passwortHash) {***REMOVED***

  Map<String, dynamic> toJson() =>
      {'benutzer': benutzer, 'passwortHash': passwortHash***REMOVED***
***REMOVED***

class Authentifizierung {
  bool erfolgreich = false;
  String meldung = '';

  Authentifizierung(this.erfolgreich, [this.meldung]);
***REMOVED***

class LoginException {
  final String message;

  LoginException(this.message);
***REMOVED***
