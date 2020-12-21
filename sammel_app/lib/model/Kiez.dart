class Kiez {
  String kiez;
  String bezirk;
  double latitude;
  double longitude;
  List<List<double>> area;

  Kiez(bezirk, kiez, lattitude, longitude) {
    this.kiez = kiez;
    this.bezirk = bezirk;
    this.latitude = lattitude;
    this.longitude = longitude;
  ***REMOVED***

  Kiez.fromJson(Map<String, dynamic> json)
      : bezirk = json['properties']['ortsteil'],
        kiez = json['properties']['kiez'],
        latitude = json['geometry']['coordinates'][0],
        longitude = json['geometry']['coordinates'][1];

  String toJson() => kiez;

  void addArea(Map<String, dynamic> json) =>
      area = (json['geometry']['coordinates'] as List)
          .map((e) => [e[0] as double, e[1] as double])
          .toList();

  bool equals(Kiez that) =>
      this.bezirk == that.bezirk &&
      this.kiez == that.kiez &&
      this.latitude == that.latitude &&
      this.longitude == that.longitude;
***REMOVED***
