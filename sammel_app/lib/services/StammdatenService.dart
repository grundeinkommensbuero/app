import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  StammdatenService();
  static var fileReader = FileReader();

  final Future<List<Kiez>> kieze = StammdatenService.ladeKieze();

  static Future<List<Kiez>> ladeKieze() async {
    var centroidsJsons = await fileReader.loadLorCentroids();
    var polygonsJsons = await fileReader.loadLorPolygons();

    List centroidMaps = jsonDecode(centroidsJsons);
    List polygonMaps = jsonDecode(polygonsJsons);

    List<Kiez> kieze = centroidMaps.map((json) => Kiez.fromJson(json)).toList();
    kieze.forEach((kiez) => kiez.addArea(
        polygonMaps.firstWhere((map) => map['properties']['id'] == kiez.kiez)));

    return kieze;
  ***REMOVED***
***REMOVED***