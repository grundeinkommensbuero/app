import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/Service.dart';

abstract class AbstractTermineService extends BackendService {
  Future<List<Termin>> ladeTermine(TermineFilter filter);

  Future<Termin> createTermin(Termin termin, String token);

  Future<Termin> getTerminMitDetails(int id);

  Future<void> saveAction(Termin action, String token);

  Future<void> deleteAction(Termin action, String token);
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
      return termine;
    ***REMOVED***
    if (response.response.statusCode == 403) {
      throw AuthFehler.fromJson(response.body);
    ***REMOVED***
    // else
    throw RestFehler.fromJson(response.body);
  ***REMOVED***

  Future<Termin> createTermin(Termin termin, String token) async {
    ActionWithToken actionWithToken = ActionWithToken(termin, token);
    var response = await post(
        Uri.parse('service/termine/neu'), jsonEncode(actionWithToken));
    if (response.response.statusCode == 200) {
      return Termin.fromJson(response.body);
    ***REMOVED*** else {
      throw RestFehler.fromJson(response.body);
    ***REMOVED***
  ***REMOVED***

  @override
  Future<Termin> getTerminMitDetails(int id) {
    return get(Uri.parse('service/termine/termin?id=' + id.toString()))
        .then((response) {
      if (response.response.statusCode == 200)
        return Termin.fromJson(response.body);
      else
        throw RestFehler('${response.response.statusCode***REMOVED*** - '
            '${RestFehler.fromJson(response.body)***REMOVED***');
    ***REMOVED***);
  ***REMOVED***

  Future<void> saveAction(Termin action, String token) async {
    var response = await post(Uri.parse('service/termine/termin'),
        jsonEncode(ActionWithToken(action, token)));
    if (response.response.statusCode == 200) {
      return;
    ***REMOVED***
    if (response.response.statusCode == 403) {
      throw AuthFehler.fromJson(response.body);
    ***REMOVED***
    throw RestFehler.fromJson(response.body);
  ***REMOVED***

  Future<void> deleteAction(Termin action, String token) async {
    var response = await delete(Uri.parse('service/termine/termin'),
        jsonEncode(ActionWithToken(action, token)));
    if (response.response.statusCode == 403) {
      throw AuthFehler.fromJson(response.body);
    ***REMOVED***
    if (response.response.statusCode != 200) {
      throw RestFehler.fromJson(response.body);
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoTermineService extends AbstractTermineService {
  static Ort nordkiez = Ort(1, 'Friedrichshain-Kreuzberg',
      'Friedrichshain Nordkiez', 52.51579, 13.45399);
  static Ort treptowerPark =
      Ort(2, 'Treptow-Köpenick', 'Treptower Park', 52.48993, 13.46839);
  static Ort goerli = Ort(3, 'Friedrichshain-Kreuzberg',
      'Görlitzer Park und Umgebung', 52.49653, 13.43762);
  static var heute = DateTime.now();
  List<Termin> termine = [
    Termin(
        1,
        DateTime(heute.year, heute.month - 1, heute.day - 1, 9, 0, 0),
        DateTime(heute.year, heute.month - 1, heute.day - 1, 12, 0, 0),
        nordkiez,
        'Sammeln',
        52.52116,
        13.41331,
        TerminDetails('Weltzeituhr', 'Bringe Westen und Klämmbretter mit',
            'Ruft mich an unter 01234567')),
    Termin(
        2,
        DateTime(heute.year, heute.month, heute.day - 1, 11, 0, 0),
        DateTime(heute.year, heute.month, heute.day - 1, 13, 0, 0),
        treptowerPark,
        'Sammeln',
        52.48756,
        13.46336,
        TerminDetails('Hinter der 3. Parkbank links',
            'wir machen die Parkeingänge', 'Schreibt mir unter e@mail.de')),
    Termin(
        3,
        DateTime(heute.year, heute.month, heute.day, 23, 0, 0),
        DateTime(heute.year, heute.month, heute.day + 1, 2, 0, 0),
        goerli,
        'Sammeln',
        52.49655,
        13.43759,
        TerminDetails('wir telefonieren uns zusammen', 'bitte seid pünktlich',
            'Meine Handynummer ist 01234567')),
    Termin(
        4,
        DateTime(heute.year, heute.month, heute.day + 1, 18, 0, 0),
        DateTime(heute.year, heute.month, heute.day + 1, 20, 30, 0),
        treptowerPark,
        'Infoveranstaltung',
        52.48612,
        13.47192,
        TerminDetails(
            'DGB-Haus, Raum 1312',
            'Ihr seid alle herzlich eingeladen zur Strategiediskussion',
            'Meldet euch doch bitte an unter info@dwenteignen.de damit wir das Buffet planen können')),
  ];

  @override
  Future<List<Termin>> ladeTermine(TermineFilter filter) async {
    return termine.where((termin) {
      var von = DateTime(termin.beginn?.year, termin.beginn.month,
          termin.beginn.day, filter.von?.hour ?? 0, filter.von?.minute ?? 0);
      var bis = DateTime(termin.beginn.year, termin.beginn.month,
          termin.beginn.day, filter.bis?.hour ?? 0, filter.bis?.minute ?? 0);
      DateTime datum =
          DateTime(termin.beginn.year, termin.beginn.month, termin.beginn.day);
      return (filter.von == null ? true : termin.ende.isAfter(von)) &&
          (filter.bis == null ? true : termin.beginn.isBefore(bis)) &&
          (filter.tage == null || filter.tage.isEmpty
              ? true
              : filter.tage.contains(datum)) &&
          (filter.tage == null || filter.tage.isEmpty
              ? true
              : filter.tage.contains(datum)) &&
          (filter.orte == null || filter.orte.isEmpty
              ? true
              : filter.orte.map((o) => o.ort).contains(termin.ort.ort)) &&
          (filter.typen == null || filter.typen.isEmpty
              ? true
              : filter.typen.contains(termin.typ));
    ***REMOVED***).toList();
  ***REMOVED***

  @override
  Future<Termin> createTermin(Termin termin, String token) async {
    int highestId = termine.map((termin) => termin.id).reduce(max);
    termin.id = highestId + 1;
    termine.add(termin);
    return termin;
  ***REMOVED***

  @override
  Future<Termin> getTerminMitDetails(int id) async {
    return termine.firstWhere((termin) => termin.id == id);
  ***REMOVED***

  @override
  Future<void> saveAction(Termin newAction, String token) async {
    termine[termine.indexWhere((oldAction) => oldAction.id == newAction.id)] =
        newAction;
  ***REMOVED***

  @override
  Future<void> deleteAction(Termin action, String token) {
    termine.removeAt(termine.indexWhere((a) => a.id == action.id));
  ***REMOVED***
***REMOVED***
