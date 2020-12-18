class Kiez {
  String bezirk;
  String plz;
  double latitude;
  double longitude;
  List<List<double>> area;

  Kiez(id, bezirk, ort, lattitude, longitude) {
    this.plz = ort;
    this.bezirk = bezirk;
    this.latitude = lattitude;
    this.longitude = longitude;
  }

  Kiez.fromJson(Map<String, dynamic> json)
      : bezirk = json['properties']['ortsteil'],
        plz = json['properties']['plz'],
        latitude = json['geometry']['coordinates'][0],
        longitude = json['geometry']['coordinates'][1];

  Map<String, dynamic> toJson() => {'id': plz};

  void addArea(Map<String, dynamic> json) =>
      area = (json['geometry']['coordinates'] as List)
          .map((e) => [e[0] as double, e[1] as double])
          .toList();

  bool equals(Kiez that) =>
      this.bezirk == that.bezirk &&
      this.plz == that.plz &&
      this.latitude == that.latitude &&
      this.longitude == that.longitude;
}
