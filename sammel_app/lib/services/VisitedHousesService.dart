import 'dart:convert';
import 'dart:math';

import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';

import 'ErrorService.dart';

abstract class AbstractVisitedHousesService extends BackendService {
  AbstractVisitedHousesService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  Future<List<Building>> loadVisitedHouses();

  Future<Building?> createVisitedHouse(Building house);

  deleteVisitedHouse(int id);
***REMOVED***

class VisitedHousesService extends AbstractVisitedHousesService {
  VisitedHousesService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {***REMOVED***

  @override
  Future<Building?> createVisitedHouse(Building house) async {
    try {
      var response =
          await post('service/besuchteHaeuser/neu', jsonEncode(house));
      return Building.fromJson(response.body);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Eintragen von Besuchtem Haus ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***

  @override
  deleteVisitedHouse(int id) async {
    try {
      return await delete('service/besuchteHaeuser/$id');
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Löschen von Besuchtem Haus ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***

  @override
  Future<List<Building>> loadVisitedHouses() async {
    HttpClientResponseBody response;
    try {
      response = await get('service/besuchteHaeuser');
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Besuchte Häuser konnten nicht geladen werden.');
      return [];
    ***REMOVED***
    final houses = (response.body as List)
        .map((jsonHouse) => Building.fromJson(jsonHouse))
        .toList();
    return houses;
  ***REMOVED***
***REMOVED***

class DemoVisitedHousesService extends AbstractVisitedHousesService {
  DemoVisitedHousesService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {***REMOVED***
  List<Building> visitedHouses = [
    Building(
        1,
        52.52014,
        13.36911,
        'Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557',
        'Westflügel',
        DateTime(2021, 7, 18),
        11,
        ''),
    Building(
        2,
        52.4964133,
        13.3617511,
        'Potsdamer Straße 143, 10783 Berlin',
        null,
        DateTime(2021, 7, 17),
        12,
        ''),
    Building(
        3,
        52.5065,
        13.35125,
        'Klingelhöferstraße 8,Botschaftsviertel, Tiergarten, Mitte, Berlin, 10785',
        'Haupteingang',
        DateTime(2021, 7, 19),
        11,
        '')
  ];

  @override
  Future<Building> createVisitedHouse(Building houses) {
    var maxId = visitedHouses
        .map((p) => p.id)
        .fold(0, (int? v, int? e) => max(v!, e == null ? 0 : e));
    if (houses.id == null || houses.id == 0) houses.id = maxId + 1;
    visitedHouses.add(houses);
    return Future.value(houses);
  ***REMOVED***

  @override
  deleteVisitedHouse(int id) {
    if (!visitedHouses.map((e) => e.id).contains(id)) return;

    var houses = visitedHouses.firstWhere((pl) => pl.id == id);
    visitedHouses.remove(houses);
  ***REMOVED***

  @override
  Future<List<Building>> loadVisitedHouses() =>
      Future.value(visitedHouses);
***REMOVED***