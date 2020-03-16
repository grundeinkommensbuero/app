class Ort {
  int id;
  String bezirk;
  String ort;
  double lattitude;
  double longitude;

  Ort(id, bezirk, ort, lattitude, longitude) {
    this.id = id;
    this.ort = ort;
    this.bezirk = bezirk;
    this.lattitude = lattitude;
    this.longitude = longitude;
  }

  Ort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bezirk = json['bezirk'] ?? '',
        ort = json['ort'] ?? '',
        lattitude = json['lattitude'] ?? null,
        longitude = json['longitude'] ?? null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'bezirk': bezirk,
        'ort': ort,
        'lattitude': lattitude,
        'longitude': longitude,
      };

  bool equals(Ort that) =>
      this.id == that.id &&
      this.bezirk == that.bezirk &&
      this.ort == that.ort &&
      this.lattitude == that.lattitude &&
      this.longitude == that.longitude;
}
