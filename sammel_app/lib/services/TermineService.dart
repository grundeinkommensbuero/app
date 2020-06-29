import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/BackendService.dart';

abstract class AbstractTermineService extends BackendService {
  AbstractTermineService([Backend backendMock]) : super(backendMock);

  Future<List<Termin>> ladeTermine(TermineFilter filter);

  Future<Termin> createTermin(Termin termin, String token);

  Future<Termin> getTerminMitDetails(int id);

  Future<void> saveAction(Termin action, String token);

  deleteAction(Termin action, String token);

  joinAction(Termin action, User user);

  leaveAction(Termin action, User user);
}

class TermineService extends AbstractTermineService {
  TermineService([Backend backendMock]) : super(backendMock);

  Future<List<Termin>> ladeTermine(TermineFilter filter) async {
    HttpClientResponseBody response =
        await post('/service/termine', jsonEncode(filter));
    final termine = (response.body as List)
        .map((jsonTermin) => Termin.fromJson(jsonTermin))
        .toList();
    return termine;
  }

  Future<Termin> createTermin(Termin termin, String token) async {
    ActionWithToken actionWithToken = ActionWithToken(termin, token);
    var response =
        await post('service/termine/neu', jsonEncode(actionWithToken));
    return Termin.fromJson(response.body);
  }

  @override
  Future<Termin> getTerminMitDetails(int id) async {
    var response = await get('service/termine/termin?id=' + id.toString());
    return Termin.fromJson(response.body);
  }

  saveAction(Termin action, String token) async {
    await post(
        'service/termine/termin', jsonEncode(ActionWithToken(action, token)));
  }

  deleteAction(Termin action, String token) async {
    await delete(
        'service/termine/termin', jsonEncode(ActionWithToken(action, token)));
  }

  joinAction(Termin action, User user) async {
    await post(
        'service/termine/teilnahme', jsonEncode(Participation(action, user)));
  }

  leaveAction(Termin action, User user) async {
    await post(
        'service/termine/absage', jsonEncode(Participation(action, user)));
  }
}

class Participation {
  Termin action;
  User user;

  Participation(this.action, this.user);

  toJson() => {
        'action': action,
        'user': user,
      };
}

class DemoTermineService extends AbstractTermineService {
  DemoTermineService() : super(DemoBackend());

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
        [],
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
        [User(1, "Karl Marx", Colors.red)],
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
        [
          User(1, "Karl Marx", Colors.red),
          User(1, "Karl Marx", Colors.purple),
        ],
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
        [User(1, "Rosa Luxemburg", Colors.purple)],
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
    }).toList();
  }

  @override
  Future<Termin> createTermin(Termin termin, String token) async {
    int highestId = termine.map((termin) => termin.id).reduce(max);
    termin.id = highestId + 1;
    termine.add(termin);
    return termin;
  }

  @override
  Future<Termin> getTerminMitDetails(int id) async {
    return termine.firstWhere((termin) => termin.id == id);
  }

  @override
  Future<void> saveAction(Termin newAction, String token) async {
    termine[termine.indexWhere((oldAction) => oldAction.id == newAction.id)] =
        newAction;
  }

  @override
  deleteAction(Termin action, String token) {
    termine.removeAt(termine.indexWhere((a) => a.id == action.id));
  }

  joinAction(Termin action, User user) {
    var stored = termine.firstWhere((a) => a.id == action.id);
    if (!stored.participants.map((e) => e.id).contains(user.id))
      stored.participants.add(user);
  }

  leaveAction(Termin action, User user) {
    var stored = termine.firstWhere((a) => a.id == action.id);
    if (stored.participants.map((e) => e.id).contains(user.id))
      stored.participants.remove(user);
  }
}
