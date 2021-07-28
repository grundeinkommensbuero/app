import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';
import 'package:poly/poly.dart' as poly;

class StammdatenService {
  static var fileReader = FileReader();

  final Future<Set<Kiez>> kieze = loadKieze();
  final Future<Set<Region>> regionen = loadRegionen();
  final Future<Set<Ortsteil>> ortsteile = loadOrtsteile();

  StammdatenService();

  static Future<Set<Kiez>> loadKieze() async {
    var json = await fileReader.kieze;

    return (jsonDecode(json)['features'] as List)
        .map((json) => Kiez.fromJson(json))
        .toSet();
  }

  static Future<Set<Region>> loadRegionen() async {
    final json = await fileReader.regionen;

    return (jsonDecode(json)['features'] as List)
        .map((json) => Region.fromJson(json))
        .toSet();
  }

  static Future<Set<Ortsteil>> loadOrtsteile() async {
    final json = await fileReader.ortsteile;

    return (jsonDecode(json)['features'] as List)
        .map((json) => Ortsteil.fromJson(json))
        .toSet();
  }

  Future<Kiez?> getKiezAtLocation(LatLng point) async {
    return (await kieze)
        .map((kiez) => kiez as Kiez?) // nötig wegen orElse => null
        .firstWhere(
            (kiez) => poly.Polygon(kiez!.polygon
            .map((latlng) =>
            poly.Point<num>(latlng.latitude, latlng.longitude))
            .toList())
            .contains(point.latitude, point.longitude),
        orElse: () => null);
  }
}
