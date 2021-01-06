import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  static var fileReader = FileReader();

  static Future<Set<Kiez>> _kieze = loadKieze();
  static Future<Set<Ortsteil>> ortsteile = loadOrtsteile();
  static Future<Set<Bezirk>> bezirke = loadBezirke();
  // Warten dass Kieze mit Bezirken angereichert wurden
  static Future<Set<Kiez>> kieze = bezirke.then((_) => _kieze);

  static Future<Set<Kiez>> loadKieze() async {
    var jsonCentroids = await fileReader.kiezeCentroids;
    var jsonPolygons = await fileReader.kiezePolygons;

    var centroidsMap = (jsonDecode(jsonCentroids)['features'] as List)
        .asMap()
        .map((_, json) => MapEntry(json['properties']['SCHLUESSEL'], json));
    var polygonsMap = (jsonDecode(jsonPolygons)['features'] as List)
        .asMap()
        .map((_, json) => MapEntry(json['properties']['SCHLUESSEL'], json));

    return centroidsMap.keys
        .map((id) => Kiez.fromJson(centroidsMap[id], polygonsMap[id]))
        .toSet();
  }

  static Future<Set<Ortsteil>> loadOrtsteile() async {
    final kieze = await _kieze;
    final jsonCentroids = await fileReader.ortsteileCentroids;
    final jsonPolygons = await fileReader.ortsteilePolygons;

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
  }

  static Future<Set<Bezirk>> loadBezirke() async {
    print('Lade Bezirke');
    var o = await ortsteile;
    final json = await fileReader.bezirke;

    final centroidsList = (jsonDecode(json)['features'] as List);

    final bezirke =
        centroidsList.map((bezirkJson) => Bezirk.fromJson(bezirkJson)).toSet();

    bezirke.forEach((bezirk) {
      return bezirk.ortsteile = o
          .where((ortsteil) => ortsteil.id.startsWith(bezirk.id))
          .map((ortsteil) =>
              ortsteil..kieze.forEach((kiez) => kiez.bezirk = bezirk.name))
          .toSet();
    });

    return bezirke;
  }

  static Future<Kiez> kiezBy(name) =>
      kieze.then((k) => k.firstWhere((kiez) => name == kiez.name));

  static Future<List<Kiez>> kiezeBy(name) =>
      kieze.then((k) => k.where((kiez) => name == kiez.name).toList());
}
