import 'dart:async';
import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  static FileReader fileReader = FileReader();
  static final _kieze = StreamController<Set<Kiez>>.broadcast();
  static final _bezirke = StreamController<Set<Bezirk>>.broadcast();
  static final _ortsteile = StreamController<Set<Ortsteil>>.broadcast();

  Future<Set<Bezirk>> bezirke = _bezirke.stream.first;
  Future<Set<Ortsteil>> ortsteile = _ortsteile.stream.first;
  Future<Set<Kiez>> kieze = _kieze.stream.first;

  StammdatenService() {
    loadKieze().then((kieze) async {
      final ortsteile = await loadOrtsteile(kieze);
      final bezirke = await loadBezirke(ortsteile);
      _bezirke.add(bezirke);
      _ortsteile.add(ortsteile);
      // warte auf Anreicherung der Kieze durch Bezirke
      _kieze.add(kieze);
    ***REMOVED***);
  ***REMOVED***

  Future<Set<Kiez>> loadKieze() async {
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

  Future<Set<Ortsteil>> loadOrtsteile(Set<Kiez> kieze) async {
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

    ortsteile.forEach((ortsteil) => ortsteil.kieze =
        kieze.where((kiez) => kiez.id.startsWith(ortsteil.id)).toSet());

    return ortsteile;
  ***REMOVED***

  Future<Set<Bezirk>> loadBezirke(Set<Ortsteil> ortsteile) async {
    final json = await fileReader.loadBezirke();

    final centroidsList = (jsonDecode(json)['features'] as List);

    final bezirke =
        centroidsList.map((bezirkJson) => Bezirk.fromJson(bezirkJson)).toSet();

    bezirke.forEach((bezirk) => bezirk.ortsteile = ortsteile
        .where((ortsteil) => ortsteil.id.startsWith(bezirk.id))
        .map((ortsteil) =>
            ortsteil..kieze.forEach((kiez) => kiez.bezirk = bezirk.name))
        .toSet());

    return bezirke;
  ***REMOVED***
***REMOVED***
