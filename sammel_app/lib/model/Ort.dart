class Ort {
  int id;
  String bezirk;
  String ort;
  double latitude;
  double longitude;

  Ort(id, bezirk, ort, lattitude, longitude) {
    this.id = id;
    this.ort = ort;
    this.bezirk = bezirk;
    this.latitude = lattitude;
    this.longitude = longitude;
  ***REMOVED***

  Ort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bezirk = json['bezirk'] ?? '',
        ort = json['ort'] ?? '',
        latitude = json['lattitude'] ?? null,
        longitude = json['longitude'] ?? null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'bezirk': bezirk,
        'ort': ort,
        'lattitude': latitude,
        'longitude': longitude,
      ***REMOVED***

  bool equals(Ort that) =>
      this.id == that.id &&
      this.bezirk == that.bezirk &&
      this.ort == that.ort &&
      this.latitude == that.latitude &&
      this.longitude == that.longitude;
***REMOVED***
