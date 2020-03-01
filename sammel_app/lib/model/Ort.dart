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

  ***REMOVED***

  Ort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bezirk = json['bezirk'] ?? '',
        ort = json['ort'] ?? '',
        lattitude = json['lattitude'] ?? '',
        longitude = json['longitude'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'bezirk': bezirk,
        'ort': ort,
        'lattitude': lattitude,
        'longitude': longitude,
      ***REMOVED***
***REMOVED***
