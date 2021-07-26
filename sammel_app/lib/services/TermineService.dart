import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Evaluation.dart';
import 'package:sammel_app/model/ActionListPushData.dart';
import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StammdatenService.dart';

import 'ErrorService.dart';
import 'LocalNotificationService.dart';
import 'UserService.dart';

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

abstract class AbstractTermineService extends BackendService {
  StammdatenService stammdatenService;
  GlobalKey<TermineSeiteState> actionPageKey;

  AbstractTermineService(this.stammdatenService,
      AbstractUserService userService, this.actionPageKey, Backend backend)
      : super(userService, backend);

  Future<List<Termin>> loadActions(TermineFilter filter);

  Future<Termin> createAction(Termin termin, String token);

  Future<Termin> getActionWithDetails(int id);

  Future<void> saveAction(Termin action, String token);

  deleteAction(Termin action, String token);

  joinAction(int id);

  leaveAction(int id);

  Future<void> saveEvaluation(Evaluation evaluation);

  Future<void> loadAndShowAction(int id) async {
    try {
      var action = await getActionWithDetails(id);
      actionPageKey.currentState!.openTerminDetails(action);
    ***REMOVED*** on Error catch (e) {
      ErrorService.handleError(e, StackTrace.current,
          context:
              'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class TermineService extends AbstractTermineService
    implements PushNotificationListener {
  LocalNotificationService localNotificationService;

  TermineService(
      stammdatenService,
      AbstractUserService userService,
      Backend backend,
      PushNotificationManager manager,
      this.localNotificationService,
      GlobalKey<TermineSeiteState> actionPageKey)
      : super(stammdatenService, userService, actionPageKey, backend) {
    manager.registerMessageCallback(PushDataTypes.newKiezActions, this);
    manager.registerMessageCallback(PushDataTypes.actionChanged, this);
    manager.registerMessageCallback(PushDataTypes.actionDeleted, this);
  ***REMOVED***

  Future<List<Termin>> loadActions(TermineFilter filter) async {
    HttpClientResponseBody response =
        await post('service/termine', jsonEncode(filter));

    developer.log('body $response');
    debugPrint('body $response');
    print('body $response');
    stdout.writeln('body $response');

    developer.log(
    'body',
    name: 'response',
    error: jsonEncode(response),
  );
    var kieze = await stammdatenService.kieze;
    final termine = (response.body as List)
        .map((jsonTermin) => Termin.fromJson(jsonTermin, kieze))
        .toList();
    return termine;
  ***REMOVED***

  Future<Termin> createAction(Termin termin, String token) async {
    ActionWithToken actionWithToken = ActionWithToken(termin, token);
    var response =
        await post('service/termine/neu', jsonEncode(actionWithToken));
    var kieze = await stammdatenService.kieze;
    return Termin.fromJson(response.body, kieze);
  ***REMOVED***

  @override
  Future<Termin> getActionWithDetails(int id) async {
    var response = await get('service/termine/termin?id=' + id.toString());
    var kieze = await stammdatenService.kieze;
    return Termin.fromJson(response.body, kieze);
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
      ErrorService.handleError(e, s, context: 'Teilnahme ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***

  leaveAction(int id) async {
    try {
      await post('service/termine/absage', jsonEncode(null),
          parameters: {'id': '$id'***REMOVED***);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s, context: 'Absage ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***

  @override
  void handleNotificationTap(Map<String, dynamic> data) async {
    final actionData =
        ActionListPushData.fromJson(data, await stammdatenService.kieze);
    actionData.actions..sort(Termin.compareByStart);

    if (actionData.type ==
        PushDataTypes.newKiezActions) if (actionData.actions.length == 1)
      this.actionPageKey.currentState!.openTerminDetails(actionData.actions[0]);
    else {
      actionPageKey.currentState!
          .zeigeAktionen('Neue Aktionen', actionData.actions);
    ***REMOVED***

    if (actionData.type == PushDataTypes.actionChanged) {
      actionPageKey.currentState!.openTerminDetails(actionData.actions[0]);
    ***REMOVED***

    if (actionData.type == PushDataTypes.actionDeleted) {
      actionData.actions[0].id = null;
      actionPageKey.currentState!
          .zeigeAktionen('Gelöschte Aktionen', actionData.actions);
    ***REMOVED***
  ***REMOVED***

  @override
  loadAndShowAction(int id) async {
    try {
      var action = await getActionWithDetails(id);
      actionPageKey.currentState!.openTerminDetails(action);
    ***REMOVED*** on Exception catch (e) {
      ErrorService.handleError(e, StackTrace.current,
          context: 'Die Aktion konnte nicht angezeigt werden');
    ***REMOVED***
  ***REMOVED***

  @override
  void receiveMessage(Map<String, dynamic> data) async {
    final kieze = await stammdatenService.kieze;
    final message = ActionListPushData.fromJson(data, kieze);

    if (message.type == PushDataTypes.newKiezActions)
      localNotificationService.sendNewActionsNotification(message);
    if (message.type == PushDataTypes.actionDeleted)
      localNotificationService.sendActionDeletedNotification(message);
    if (message.type == PushDataTypes.actionChanged)
      localNotificationService.sendActionChangedNotification(message);
  ***REMOVED***

  @override
  void updateMessages(List<Map<String, dynamic>> data) {***REMOVED***

  saveEvaluation(Evaluation evaluation) async {
    try {
      await post('service/termine/evaluation', jsonEncode(evaluation));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s, context: 'Evaluation ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoTermineService extends AbstractTermineService {
  static var heute = DateTime.now();
  late Future<List<Termin>> termine;

  DemoTermineService(StammdatenService stammdatenService,
      AbstractUserService userService, actionPageKey)
      : super(stammdatenService, userService, actionPageKey, DemoBackend()) {
    termine = stammdatenService.kieze.then((kieze) => [
          Termin(
              1,
              DateTime(heute.year, heute.month - 1, heute.day - 1, 9, 0, 0),
              DateTime(heute.year, heute.month - 1, heute.day - 1, 12, 0, 0),
              kieze.firstWhere((kiez) => kiez.name == 'Frankfurter Allee Nord'),
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
              kieze.firstWhere((kiez) => kiez.name == 'Plänterwald'),
              'Sammeln',
              52.48756,
              13.46336,
              [User(11, "Karl Marx", Colors.red)],
              TerminDetails(
                  'Hinter der 3. Parkbank links',
                  'wir machen die Parkeingänge',
                  'Schreibt mir unter app@dwenteignen.de')),
          Termin(
              3,
              DateTime(heute.year, heute.month, heute.day, 23, 0, 0),
              DateTime(heute.year, heute.month, heute.day + 1, 2, 0, 0),
              kieze.firstWhere((kiez) => kiez.name == 'Tempelhofer Vorstadt'),
              'Sammeln',
              52.49655,
              13.43759,
              [
                User(11, "Karl Marx", Colors.red),
                User(11, "Karl Marx", Colors.purple),
              ],
              TerminDetails('wir telefonieren uns zusammen',
                  'bitte seid pünktlich', 'Meine Handynummer ist 01234567')),
          Termin(
              4,
              DateTime(heute.year, heute.month, heute.day + 1, 18, 0, 0),
              DateTime(heute.year, heute.month, heute.day + 1, 20, 30, 0),
              kieze.firstWhere((kiez) => kiez.name == 'Plänterwald'),
              'Infoveranstaltung',
              52.48612,
              13.47192,
              [
                User(12, "Rosa Luxemburg", Colors.purple),
                User(13, "Ich", Colors.red)
              ],
              TerminDetails(
                  'DGB-Haus, Raum 1312',
                  'Ihr seid alle herzlich eingeladen zur Strategiediskussion',
                  'Meldet euch doch bitte an unter info@dwenteignen.de damit wir das Buffet planen können')),
        ]);
  ***REMOVED***

  @override
  Future<List<Termin>> loadActions(TermineFilter filter) async {
    return (await termine).where((termin) {
      var von = DateTime(termin.beginn.year, termin.beginn.month,
          termin.beginn.day, filter.von?.hour ?? 0, filter.von?.minute ?? 0);
      var bis = DateTime(termin.beginn.year, termin.beginn.month,
          termin.beginn.day, filter.bis?.hour ?? 0, filter.bis?.minute ?? 0);
      DateTime datum =
          DateTime(termin.beginn.year, termin.beginn.month, termin.beginn.day);
      return (filter.von == null ? true : termin.ende.isAfter(von)) &&
              (filter.bis == null ? true : termin.beginn.isBefore(bis)) &&
              (filter.tage.isEmpty ? true : filter.tage.contains(datum)) &&
              (filter.tage.isEmpty ? true : filter.tage.contains(datum)) &&
              (filter.orte.isEmpty
                  ? true
                  : filter.orte.contains(termin.ort.name)) &&
              (filter.typen.isEmpty
                  ? true
                  : filter.typen.contains(termin.typ)) &&
              (filter.nurEigene == false
                  ? true
                  : termin.participants!.map((u) => u.id).contains(13)) ||
          (filter.immerEigene == true
              ? termin.participants!.map((u) => u.id).contains(13)
              : false);
    ***REMOVED***).toList();
  ***REMOVED***

  @override
  Future<Termin> createAction(Termin termin, String token) async {
    int highestId = (await termine).map((termin) => termin.id!).reduce(max);
    termin.id = highestId + 1;
    (await termine).add(termin);
    return termin;
  ***REMOVED***

  @override
  Future<Termin> getActionWithDetails(int id) async {
    return (await termine).firstWhere((termin) => termin.id == id);
  ***REMOVED***

  @override
  Future<void> saveAction(Termin newAction, String token) async {
    var termine = await this.termine;
    termine[termine.indexWhere((oldAction) => oldAction.id == newAction.id)] =
        newAction;
  ***REMOVED***

  @override
  deleteAction(Termin action, String token) async {
    var termine = await this.termine;
    termine.removeAt(termine.indexWhere((a) => a.id == action.id));
  ***REMOVED***

  joinAction(int id) async {
    var stored = (await termine).firstWhere((a) => a.id == id);
    if (!stored.participants!.map((e) => e.id).contains(1))
      stored.participants!.add(User(11, 'Ich', Colors.red));
  ***REMOVED***

  leaveAction(int id) async {
    var stored = (await termine).firstWhere((a) => a.id == id);
    if (stored.participants!.map((e) => e.id).contains(1))
      stored.participants!.remove(User(11, 'Ich', Colors.red));
  ***REMOVED***

  @override
  Future<void> saveEvaluation(Evaluation evaluation) async {
    // hier muss man nix machen, es wird sowieso lokal gespeichert, dass man eine Evaluation abgegeben hat
    return;
  ***REMOVED***
***REMOVED***
