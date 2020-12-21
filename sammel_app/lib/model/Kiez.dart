
class Kiez {
  String kiez;
  String bezirk;
  // TODO LatLng center;
  double latitude;
  double longitude;
  List<List<double>> polygon;

  Kiez(bezirk, kiez, lattitude, longitude) {
    this.kiez = kiez;
    this.bezirk = bezirk;
    this.latitude = lattitude;
    this.longitude = longitude;
  }

  Kiez.fromJson(Map<String, dynamic> json)
      : bezirk = json['bezirk'],
        kiez = json['kiez'],
        latitude = json['longitude'],
        longitude = json['latitude'],
        polygon = (json['polygon'] as List).map((e) => (e as List).map((e) => e as double).toList()).toList();

  String toJson() => kiez;

  bool equals(Kiez that) =>
      this.bezirk == that.bezirk &&
      this.kiez == that.kiez &&
      this.latitude == that.latitude &&
      this.longitude == that.longitude &&
      this.polygon.contains(that.polygon) &&
      that.polygon.contains(this.polygon);
}
