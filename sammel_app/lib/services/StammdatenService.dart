import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  static FileReader fileReader = FileReader();
  static final Future<List<Kiez>> _kieze = loadKieze();
  static final Future<List<Bezirk>> bezirke = loadBezirke();

  // warte auf Anreicherung der Kieze durch Bezirke
  static Future<List<Kiez>> get kieze => bezirke.then((_) => _kieze);

  StammdatenService();

  static Future<List<Kiez>> loadKieze() async {
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
        .toList();
  ***REMOVED***

  static Future<List<Bezirk>> loadBezirke() async {
    final json = await fileReader.loadBezirke();

    final centroidsList = (jsonDecode(json)['features'] as List);

    final bezirke =
        centroidsList.map((bezirkJson) => Bezirk.fromJson(bezirkJson)).toList();

    final ortsteile = await loadOrtsteile();

    bezirke.forEach((bezirk) => bezirk.ortsteile = ortsteile
        .where((ortsteil) => ortsteil.id.startsWith(bezirk.id))
        .map((ortsteil) =>
            ortsteil..kieze.forEach((kiez) => kiez.bezirk = bezirk.name))
        .toList());

    return bezirke;
  ***REMOVED***

  static Future<List<Ortsteil>> loadOrtsteile() async {
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
        .toList();

    var kieze = await _kieze;
    ortsteile.forEach((ortsteil) => ortsteil.kieze =
        kieze.where((kiez) => kiez.id.startsWith(ortsteil.id)).toList());

    return ortsteile;
  ***REMOVED***
***REMOVED***
