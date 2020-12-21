import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sammel_app/model/Ort.dart';

class StammdatenService {
  // static final centroids = 'assets/geodata/plz-berlin-centroids.json';
  // static final polygons = 'assets/geodata/plz-berlin-polygons.json';
  static final centroids =
      'assets/geodata/lor_berlin_centroids.json';
  static final polygons =
      'assets/geodata/lor_berlin_polygons.json';

  StammdatenService();
  final Future<List<Kiez>> kieze = StammdatenService.ladeKieze();

  static Future<List<Kiez>> ladeKieze() async {
    var centroidsJsons = await rootBundle.loadString(centroids);
    var polygonsJsons = await rootBundle.loadString(polygons);

    List centroidMaps = jsonDecode(centroidsJsons);
    List polygonMaps = jsonDecode(polygonsJsons);

    List<Kiez> kieze = centroidMaps.map((json) => Kiez.fromJson(json)).toList();
    kieze.forEach((kiez) => kiez.addArea(
        polygonMaps.firstWhere((map) => map['properties']['id'] == kiez.id)));

    return kieze;
  }
}