import 'package:collection/collection.dart';
import 'package:latlong/latlong.dart';

class Ortsteil {
  String name;
  List<LatLng> polygon;

  Ortsteil(this.name, this.polygon);

  Ortsteil.fromJson(json)
      : name = json['properties']['ORTSTEIL'],
        polygon = json['geometry']['type'] == 'MultiPolygon'
            ? (json['geometry']['coordinates'][0][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList()
            : (json['geometry']['coordinates'][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList();
***REMOVED***

class Region {
  String name;
  List<LatLng> polygon;

  Region(this.name, this.polygon);

  Region.fromJson(json)
      : name = json['properties']['PROGNOSERA'],
        polygon = json['geometry']['type'] == 'MultiPolygon'
            ? (json['geometry']['coordinates'][0][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList()
            : (json['geometry']['coordinates'][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList();
***REMOVED***

class Kiez {
  String name;
  String region;
  String ortsteil;
  List<LatLng> polygon;

  Kiez(this.name, this.region, this.ortsteil, this.polygon);

  Kiez.fromJson(Map<String, dynamic> json)
      : name = json['properties']['BEZIRKSREG'],
        region = json['properties']['PROGNOSERA'],
        ortsteil = json['properties']['ORTSTEIL'],
        polygon = json['geometry']['type'] == 'MultiPolygon'
            ? (json['geometry']['coordinates'][0][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList()
            : (json['geometry']['coordinates'][0] as List)
                .map((e) => LatLng(e[1], e[0]))
                .toList();

  String toJson() => name;

  bool equals(Kiez that) =>
      this.name == that.name &&
      this.region == that.region &&
      this.ortsteil == that.ortsteil &&
      DeepCollectionEquality().equals(this.polygon, that.polygon); //TODO Testen
***REMOVED***
