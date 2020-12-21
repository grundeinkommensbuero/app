import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  static FileReader fileReader = FileReader();
  Future<List<Kiez>> kieze = ladeKieze();

  StammdatenService();

  static Future<List<Kiez>> ladeKieze() async {
    var json = await fileReader.loadLor();

    List centroidMaps = jsonDecode(json);

    return centroidMaps.map((json) => Kiez.fromJson(json)).toList();

    // Map<String, Kiez> kieze = centroidMaps.asMap().map(
    //     (_, json) => MapEntry(json['properties']['id'], Kiez.fromJson(json)));
    // print(kieze);
    //
    // kieze.keys.forEach((id) {
    //   var centroid =
    //       centroidMaps.firstWhere((c) => c['properties']['id'] == id);
    //   kieze[id].latitude = centroid['geometry']['coordinates'][0];
    //   kieze[id].longitude = centroid['geometry']['coordinates'][1];
    // });

    // return kieze.values.toList();
  }
}
