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

import 'ErrorService.dart';
import 'UserService.dart';

abstract class AbstractTermineService extends BackendService {
  AbstractTermineService(AbstractUserService userService, [Backend backendMock])
      : super(userService, backendMock);

  Future<List<Termin>> loadActions(TermineFilter filter);

  Future<Termin> createAction(Termin termin, String token);

  Future<Termin> getActionWithDetails(int id);

  Future<void> saveAction(Termin action, String token);

  deleteAction(Termin action, String token);

  joinAction(int id);

  leaveAction(int id);
***REMOVED***

class TermineService extends AbstractTermineService {
  TermineService(AbstractUserService userService, [Backend backendMock])
      : super(userService, backendMock);

  Future<List<Termin>> loadActions(TermineFilter filter) async {
    HttpClientResponseBody response =
        await post('service/termine', jsonEncode(filter));
    final termine = (response.body as List)
        .map((jsonTermin) => Termin.fromJson(jsonTermin))
        .toList();
    return termine;
  ***REMOVED***

  Future<Termin> createAction(Termin termin, String token) async {
    ActionWithToken actionWithToken = ActionWithToken(termin, token);
    var response =
        await post('service/termine/neu', jsonEncode(actionWithToken));
    return Termin.fromJson(response.body);
  ***REMOVED***

  @override
  Future<Termin> getActionWithDetails(int id) async {
    var response = await get('service/termine/termin?id=' + id.toString());
    return Termin.fromJson(response.body);
  ***REMOVED***

  saveAction(Termin action, String token) async {
    await post(
        'service/termine/termin', jsonEncode(ActionWithToken(action, token)));
  ***REMOVED***

  deleteAction(Termin action, String token) async {
    await delete(
        'service/termine/termin', jsonEncode(ActionWithToken(action, token)));
  ***REMOVED***

  joinAction(int id) async {
    try {
      await post('service/termine/teilnahme', jsonEncode(null),
          parameters: {'id': '$id'***REMOVED***);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          additional: 'Teilnahme ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***

  leaveAction(int id) async {
    try {
      await post('service/termine/absage', jsonEncode(null),
          parameters: {'id': '$id'***REMOVED***);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s, additional: 'Absage ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoTermineService extends AbstractTermineService {
  DemoTermineService(AbstractUserService userService)
      : super(userService, DemoBackend());

  static Kiez nordkiez = Kiez(1, 'Friedrichshain-Kreuzberg',
      'Friedrichshain Nordkiez', 52.51579, 13.45399);
  static Kiez treptowerPark =
      Kiez(2, 'Treptow-Köpenick', 'Treptower Park', 52.48993, 13.46839);
  static Kiez goerli = Kiez(3, 'Friedrichshain-Kreuzberg',
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
        [User(11, "Karl Marx", Colors.red)],
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
          User(11, "Karl Marx", Colors.red),
          User(11, "Karl Marx", Colors.purple),
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
        [User(12, "Rosa Luxemburg", Colors.purple)],
        TerminDetails(
            'DGB-Haus, Raum 1312',
            'Ihr seid alle herzlich eingeladen zur Strategiediskussion',
            'Meldet euch doch bitte an unter info@dwenteignen.de damit wir das Buffet planen können')),
  ];

  @override
  Future<List<Termin>> loadActions(TermineFilter filter) async {
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
              : filter.orte.map((o) => o.plz).contains(termin.ort.plz)) &&
          (filter.typen == null || filter.typen.isEmpty
              ? true
              : filter.typen.contains(termin.typ));
    ***REMOVED***).toList();
  ***REMOVED***

  @override
  Future<Termin> createAction(Termin termin, String token) async {
    int highestId = termine.map((termin) => termin.id).reduce(max);
    termin.id = highestId + 1;
    termine.add(termin);
    return termin;
  ***REMOVED***

  @override
  Future<Termin> getActionWithDetails(int id) async {
    return termine.firstWhere((termin) => termin.id == id);
  ***REMOVED***

  @override
  Future<void> saveAction(Termin newAction, String token) async {
    termine[termine.indexWhere((oldAction) => oldAction.id == newAction.id)] =
        newAction;
  ***REMOVED***

  @override
  deleteAction(Termin action, String token) {
    termine.removeAt(termine.indexWhere((a) => a.id == action.id));
  ***REMOVED***

  joinAction(int id) {
    var stored = termine.firstWhere((a) => a.id == id);
    if (!stored.participants.map((e) => e.id).contains(1))
      stored.participants.add(User(11, 'Ich', Colors.red));
  ***REMOVED***

  leaveAction(int id) {
    var stored = termine.firstWhere((a) => a.id == id);
    if (stored.participants.map((e) => e.id).contains(1))
      stored.participants.remove(User(11, 'Ich', Colors.red));
  ***REMOVED***
***REMOVED***
