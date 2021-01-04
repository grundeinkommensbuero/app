import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  static FileReader fileReader = FileReader();
  static final Future<Set<Kiez>> _kieze = loadKieze();
  static final Future<Set<Bezirk>> bezirke = loadBezirke();
  static final Future<Set<Ortsteil>> ortsteile = loadOrtsteile();

  // warte auf Anreicherung der Kieze durch Bezirke
  static Future<Set<Kiez>> get kieze => bezirke.then((_) => _kieze);

  StammdatenService();

  static Future<Set<Kiez>> loadKieze() async {
    var jsonCentroids = await fileReader.loadKiezeCentroids();
    var jsonPolygons = await fileReader.loadKiezePolygons();

    var centroidsMap = (jsonDecode(jsonCentroids)['features'] as List)
        .asMap()
        .map((_, json) => MapEntry(json['properties']['SCHLUESSEL'], json));
    var polygonsMap = (jsonDecode(jsonPolygons)['features'] as List)
        .asMap()
        .map((_, json) => MapEntry(json['properties']['SCHLUESSEL'], json));

    return centroidsMap.keys
        .map((id) => Kiez.fromJson(centroidsMap[id], polygonsMap[id]))
        .toSet();
  ***REMOVED***

  static Future<Set<Bezirk>> loadBezirke() async {
    final json = await fileReader.loadBezirke();

    final centroidsList = (jsonDecode(json)['features'] as List);

    final bezirke =
        centroidsList.map((bezirkJson) => Bezirk.fromJson(bezirkJson)).toSet();

    final ortsteile = await StammdatenService.ortsteile;
    bezirke.forEach((bezirk) => bezirk.ortsteile = ortsteile
        .where((ortsteil) => ortsteil.id.startsWith(bezirk.id))
        .map((ortsteil) =>
            ortsteil..kieze.forEach((kiez) => kiez.bezirk = bezirk.name))
        .toSet());

    return bezirke;
  ***REMOVED***

  static Future<Set<Ortsteil>> loadOrtsteile() async {
    final jsonCentroids = await fileReader.loadOrtsteileCentroids();
    final jsonPolygons = await fileReader.loadOrtsteilePolygons();

    final centroidsMap = (jsonDecode(jsonCentroids)['features'] as List)
        .asMap()
        .map((_, json) => MapEntry(json['properties']['SCHLUESSEL'], json));
    final polygonsMap = (jsonDecode(jsonPolygons)['features'] as List)
        .asMap()
        .map((_, json) => MapEntry(json['properties']['SCHLUESSEL'], json));

    final ortsteile = centroidsMap.keys
        .map((id) => Ortsteil.fromJson(centroidsMap[id], polygonsMap[id]))
        .toSet();

    var kieze = await _kieze;
    ortsteile.forEach((ortsteil) => ortsteil.kieze =
        kieze.where((kiez) => kiez.id.startsWith(ortsteil.id)).toSet());

    return ortsteile;
  ***REMOVED***
***REMOVED***
