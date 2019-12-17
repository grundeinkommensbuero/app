import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/Service.dart';

abstract class AbstractTermineService extends Service {
  Future<List<Termin>> ladeTermine(TermineFilter filter);
  Future<Termin> createTermin(Termin termin);
***REMOVED***

class TermineService extends AbstractTermineService {
  Future<List<Termin>> ladeTermine(TermineFilter filter) async {
    HttpClientResponseBody response =
        await post(Uri.parse('/service/termine'), jsonEncode(filter));
    if (response.response.statusCode == 200) {
      final termine = (response.body as List)
          .map((jsonTermin) => Termin.fromJson(jsonTermin))
          .toList();
      // Sortierung auf Client-Seite um Server und Datenbank skalierbar zu halten
      termine
          .sort((termin1, termin2) => termin1.beginn.compareTo(termin2.beginn));
      return termine;
    ***REMOVED*** else {
      throw RestFehler("Unerwarteter Fehler: "
          "${response.response.statusCode***REMOVED*** - ${response.body***REMOVED***");
    ***REMOVED***
  ***REMOVED***

  Future<Termin> createTermin(Termin termin) async {
    var response =
        await post(Uri.parse('service/termine/neu'), jsonEncode(termin));
    if(response.response.statusCode == 200) {
      return Termin.fromJson(response.body);
    ***REMOVED*** else {
      throw RestFehler("Fehler beim Anlegen eines Termins: "
          "${response.response.statusCode***REMOVED*** - ${response.body***REMOVED***");
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoTermineService extends AbstractTermineService {
  static Ort nordkiez =
      Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez');
  static Ort treptowerPark = Ort(2, 'Treptow-Köpenick', 'Treptower Park');
  static Ort goerli =
      Ort(3, 'Friedrichshain-Kreuzberg', 'Görlitzer Park und Umgebung');
  static var heute = DateTime.now();
  List<Termin> termine = [
    Termin(
        1,
        DateTime(heute.year - 1, heute.month - 1, heute.day - 1, 9, 0, 0),
        DateTime(heute.year - 1, heute.month - 1, heute.day - 1, 12, 0, 0),
        nordkiez,
        'Sammel-Termin',
        null /*TerminDetails('Weltzeituhr', 'Bringe Westen und Klämmbretter mit',
            'Ruft mich an unter 01234567')*/
        ),
    Termin(
        2,
        DateTime(heute.year, heute.month, heute.day, 11, 0, 0),
        DateTime(heute.year, heute.month, heute.day, 13, 0, 0),
        treptowerPark,
        'Sammel-Termin',
        null /*TerminDetails('Hinter der 3. Parkbank links',
            'wir machen die Parkeingänge', 'Schreibt mir unter e@mail.de')*/
        ),
    Termin(
        3,
        DateTime(heute.year, heute.month, heute.day, 23, 0, 0),
        DateTime(heute.year, heute.month, heute.day + 1, 2, 0, 0),
        goerli,
        'Sammel-Termin',
        null /*TerminDetails('wir telefonieren uns zusammen', 'bitte seid pünktlich',
            'Meine Handynummer ist 01234567')*/
        ),
    Termin(
        4,
        DateTime(heute.year, heute.month, heute.day + 1, 18, 0, 0),
        DateTime(heute.year, heute.month, heute.day + 1, 20, 30, 0),
        treptowerPark,
        'Info-Veranstaltung',
        null /*TerminDetails(
            'DGB-Haus, Raum 1312',
            'Ihr seid alle herzlich eingeladen zur Strategiediskussion',
            'Meldet euch doch bitte an unter info@dwenteignen.de damit wir das Buffet planen können')*/
        ),
  ];

  @override
  Future<List<Termin>> ladeTermine(TermineFilter filter) async {
    // Wert muss als Future herausgereicht werden
    //return (new Completer()..complete(termine)).future;
    return termine;
  ***REMOVED***

  @override
  Future<Termin> createTermin(Termin termin) async {
    int highestId = termine.map((termin) => termin.id).reduce(max);
    termin.id = highestId + 1;
    termine.add(termin);
    return await termin;
  ***REMOVED***
***REMOVED***
