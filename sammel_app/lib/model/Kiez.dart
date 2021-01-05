import 'package:collection/collection.dart';
import 'package:latlong/latlong.dart';

class Bezirk {
  String id;
  String name;
  List<LatLng> polygon;
  Set<Ortsteil> ortsteile;

  Bezirk.fromJson(json)
      : id = (json['properties']['BEZIRK'] as String),
        name = json['properties']['BEZIRKSREG'],
        polygon = json['geometry']['type'] == 'MultiPolygon'
            ? (json['geometry']['coordinates'][0][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList()
            : (json['geometry']['coordinates'][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList();
}

class Ortsteil {
  String id;
  List<LatLng> polygon;
  Set<Kiez> kieze;

  Ortsteil.fromJson(centroidJson, polygonJson)
      : id = centroidJson['properties']['SCHLUESSEL'],
        polygon = polygonJson['geometry']['type'] == 'MultiPolygon'
            ? (polygonJson['geometry']['coordinates'][0][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList()
            : (polygonJson['geometry']['coordinates'][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList();
}

class Kiez {
  String id;
  String name;
  String bezirk;
  List<LatLng> polygon;

  Kiez(String name, String bezirk, List<LatLng> polygon) {
    this.name = name;
    this.bezirk = bezirk;
    this.polygon = polygon;
  }

  Kiez.fromJson(
      Map<String, dynamic> centroidJson, Map<String, dynamic> polygonJson)
      : id = centroidJson['properties']['SCHLUESSEL'],
        name = centroidJson['properties']['BEZIRKSREG'],
        polygon = polygonJson['geometry']['type'] == 'MultiPolygon'
            ? (polygonJson['geometry']['coordinates'][0][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList()
            : (polygonJson['geometry']['coordinates'][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList();

  String toJson() => name;

  bool equals(Kiez that) =>
      this.name == that.name &&
      DeepCollectionEquality().equals(this.polygon, that.polygon); //TODO Testen
}
