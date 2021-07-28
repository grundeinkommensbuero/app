import 'dart:convert';
import 'dart:math';

import 'package:http_server/http_server.dart';
import 'package:intl/intl.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

import 'ErrorService.dart';

abstract class AbstractVisitedHousesService extends BackendService {
  AbstractVisitedHousesService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  Future<List<VisitedHouseDummy>> loadVisitedHouses();

  Future<VisitedHouseDummy?> createVisitedHouse(VisitedHouseDummy house);

  deleteVisitedHouse(int id);
***REMOVED***

class VisitedHousesService extends AbstractVisitedHousesService {
  VisitedHousesService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {***REMOVED***

  @override
  Future<VisitedHouseDummy?> createVisitedHouse(VisitedHouseDummy house) async {
    try {
      var response =
          await post('service/besuchteHaeuser/neu', jsonEncode(house));
      return VisitedHouseDummy.fromJson(response.body);
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
  Future<List<VisitedHouseDummy>> loadVisitedHouses() async {
    HttpClientResponseBody response;
    try {
      response = await get('service/besuchteHaeuser');
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Besuchte Häuser konnten nicht geladen werden.');
      return [];
    ***REMOVED***
    final houses = (response.body as List)
        .map((jsonHouse) => VisitedHouseDummy.fromJson(jsonHouse))
        .toList();
    return houses;
  ***REMOVED***
***REMOVED***

class DemoVisitedHousesService extends AbstractVisitedHousesService {
  DemoVisitedHousesService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {***REMOVED***
  List<VisitedHouseDummy> visitedHouses = [
    VisitedHouseDummy(
        1,
        52.52014,
        13.36911,
        'Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557',
        'Westflügel',
        DateTime(2021, 7, 18),
        11,
        ''),
    VisitedHouseDummy(
        2,
        52.4964133,
        13.3617511,
        'Potsdamer Straße 143, 10783 Berlin',
        null,
        DateTime(2021, 7, 17),
        12,
        ''),
    VisitedHouseDummy(
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
  Future<VisitedHouseDummy> createVisitedHouse(VisitedHouseDummy houses) {
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
  Future<List<VisitedHouseDummy>> loadVisitedHouses() =>
      Future.value(visitedHouses);
***REMOVED***

class VisitedHouseDummy {
  int? id;
  double latitude;
  double longitude;
  String adresse;
  String? hausteil;
  DateTime datum;
  int benutzer;
  String? polygon;

  VisitedHouseDummy(this.id, this.latitude, this.longitude, this.adresse,
      this.hausteil, this.datum, this.benutzer, this.polygon);

  VisitedHouseDummy.fromJson(Map<dynamic, dynamic> json) :
    id = json['id'],
    latitude = json['latitude'],
    longitude = json['longitude'],
    adresse = json['adresse'],
    hausteil = json['hausteil'],
    datum = ChronoHelfer.deserializeJsonDateTime(json['datum']),
    benutzer = json['benutzer'],
    polygon = '';

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': adresse,
        'hausteil': hausteil,
        'datum': DateFormat('yyyy-MM-dd').format(datum),
        'benutzer': benutzer
      ***REMOVED***
***REMOVED***
