import 'package:latlong/latlong.dart';

class Kiez {
  String kiez;
  String bezirk;
  LatLng center;
  List<List<double>> polygon;

  Kiez(bezirk, kiez, latitude, longitude) {
    this.kiez = kiez;
    this.bezirk = bezirk;
    this.center = latitude == null || longitude == null
        ? null
        : LatLng(latitude, longitude);
  }

  Kiez.fromJson(Map<String, dynamic> json)
      : bezirk = json['bezirk'],
        kiez = json['kiez'],
        center = json['latitude'] == null || json['longitude'] == null
            ? null
            : LatLng(json['latitude'], json['longitude']),
        polygon = (json['polygon'] as List)
            .map((e) => (e as List).map((e) => e as double).toList())
            .toList();

  String toJson() => kiez;

  bool equals(Kiez that) =>
      this.bezirk == that.bezirk &&
      this.kiez == that.kiez &&
      this.center.latitude == that.center.latitude &&
      this.center.longitude == that.center.longitude &&
      this.polygon.contains(that.polygon) &&
      that.polygon.contains(this.polygon);
}
