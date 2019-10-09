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
  ***REMOVED***

  Future<bool> authentifziereBenutzer(Login login,
      [BuildContext context]) async {
    print('Authentifiziere Benutzer ${login.benutzer.name***REMOVED***');
    var response = await http.post(
      Uri.http('10.0.2.2:18080', '/service/benutzer/authentifiziere'),
      headers: _header,
      body: jsonEncode(login),
    );

    if (response.statusCode == 200) {
      return true;
    ***REMOVED***

    if (response.statusCode == 412) {
      var fehler = RestFehler.deserialisiere(response.body);
      // TODO Usermeldung in GUI
      print('Eingabefehler für ${login.benutzer.name***REMOVED***: ${fehler.meldung***REMOVED***');
      if (context != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Fehler"),
                content: Text(fehler.meldung),
              );
            ***REMOVED***);
      ***REMOVED***
      return false;
    ***REMOVED***

    if (response.statusCode == 401) {
      var fehler = RestFehler.deserialisiere(response.body);
      // TODO Usermeldung in GUI
      print('Authentifizierung von Benutzer ${login.benutzer.name***REMOVED*** '
          'fehlgeschlagen: ${fehler.meldung***REMOVED***.');
      if (context != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Anmelden fehlgeschlagen"),
                content: Text(fehler.meldung),
              );
            ***REMOVED***);
      ***REMOVED***
      return false;
    ***REMOVED*** else {
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
            ***REMOVED***);
      ***REMOVED***
      throw Exception('HTTP-Status: ${response.statusCode***REMOVED***\n ${response.body***REMOVED***');
    ***REMOVED***
  ***REMOVED***

  legeBenutzerAn(Login login) async {
    print('DEBUG ### lege neuen Benutzer an : ${jsonEncode(login)***REMOVED***');
    var response = await http.post(
      Uri.http('10.0.2.2:18080', '/service/benutzer/neu'),
      headers: _header,
      body: jsonEncode(login),
    );

    if (response.statusCode == 200) {
      return;
    ***REMOVED***

    if (response.statusCode == 412) {
      final RestFehler restFehler = RestFehler.deserialisiere(response.body);
      throw LoginException(restFehler.meldung);
    ***REMOVED*** else {
      // Unerwarteter Fehler
      //LOG
      throw Exception('HTTP-Status: ${response.statusCode***REMOVED***\n ${response.body***REMOVED***');
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

class LoginException {
  final String message;

  LoginException(this.message);
***REMOVED***
