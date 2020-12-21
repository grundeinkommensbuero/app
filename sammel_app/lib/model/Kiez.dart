class Kiez {
  String id;
  String bezirk;
  double latitude;
  double longitude;
  List<List<double>> area;

  // TODO id ausbauen
  Kiez(_, bezirk, ort, lattitude, longitude) {
    this.id = ort;
    this.bezirk = bezirk;
    this.latitude = lattitude;
    this.longitude = longitude;
  ***REMOVED***

  Kiez.fromJson(Map<String, dynamic> json)
      : bezirk = json['properties']['ortsteil'],
        id = json['properties']['id'],
        latitude = json['geometry']['coordinates'][0],
        longitude = json['geometry']['coordinates'][1];

  Map<String, dynamic> toJson() => {'id': id***REMOVED***

  void addArea(Map<String, dynamic> json) =>
      area = (json['geometry']['coordinates'] as List)
          .map((e) => [e[0] as double, e[1] as double])
          .toList();

  bool equals(Kiez that) =>
      this.bezirk == that.bezirk &&
      this.id == that.id &&
      this.latitude == that.latitude &&
      this.longitude == that.longitude;
***REMOVED***
