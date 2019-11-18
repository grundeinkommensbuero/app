import 'dart:async';
import 'dart:convert';

import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/Benutzer.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/Service.dart';

abstract class AbstractTermineService extends Service {
  Future<List<Termin>> ladeTermine(TermineFilter filter);
***REMOVED***

class TermineService extends AbstractTermineService {
  Future<List<Termin>> ladeTermine(TermineFilter filter) async {
    HttpClientResponseBody response =
        await post(Uri.parse('/service/termine'), jsonEncode(filter));
    if (response.response.statusCode == 200) {
      final termine = (response.body as List).map((jsonTermin) {
        var termin = Termin.fromJson(jsonTermin);
        return termin;
      ***REMOVED***).toList();
      // Sortierung auf Client-Seite um Server und Datenbank skalierbar zu halten
      termine
          .sort((termin1, termin2) => termin1.beginn.compareTo(termin2.beginn));
      return termine;
    ***REMOVED*** else {
      throw RestFehler(
          "Unerwarteter Fehler: ${response.response.statusCode***REMOVED*** - ${response.body***REMOVED***");
    ***REMOVED***
  ***REMOVED***
***REMOVED***

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
        DateTime(heute.year - 1, heute.month - 1, heute.day - 1, 9, 0, 0),
        DateTime(heute.year - 1, heute.month - 1, heute.day - 1, 12, 0, 0),
        nordkiez,
        'Sammel-Termin',
        [karl, rosa],
        null /*TerminDetails('Weltzeituhr', 'Bringe Westen und Klämmbretter mit',
            'Ruft mich an unter 01234567')*/
        ),
    Termin(
        2,
        DateTime(heute.year, heute.month, heute.day, 11, 0, 0),
        DateTime(heute.year, heute.month, heute.day, 13, 0, 0),
        treptowerPark,
        'Sammel-Termin',
        [karl],
        null /*TerminDetails('Hinter der 3. Parkbank links',
            'wir machen die Parkeingänge', 'Schreibt mir unter e@mail.de')*/
        ),
    Termin(
        3,
        DateTime(heute.year, heute.month, heute.day, 23, 0, 0),
        DateTime(heute.year, heute.month, heute.day+1, 2, 0, 0),
        goerli,
        'Sammel-Termin',
        [rosa],
        null /*TerminDetails('wir telefonieren uns zusammen', 'bitte seid pünktlich',
            'Meine Handynummer ist 01234567')*/
        ),
    Termin(
        4,
        DateTime(heute.year, heute.month, heute.day + 1, 18, 0, 0),
        DateTime(heute.year, heute.month, heute.day + 1, 20, 30, 0),
        treptowerPark,
        'Info-Veranstaltung',
        [rosa, karl],
        null /*TerminDetails(
            'DGB-Haus, Raum 1312',
            'Ihr seid alle herzlich eingeladen zur Strategiediskussion',
            'Meldet euch doch bitte an unter info@dwenteignen.de damit wir das Buffet planen können')*/
        ),
  ];

  @override
  Future<List<Termin>> ladeTermine(TermineFilter filter) async {
    // Wert muss als Future herausgereicht werden
    return (new Completer()..complete(termine)).future;
  ***REMOVED***
***REMOVED***
