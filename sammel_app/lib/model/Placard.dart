class Placard {
  int? id;
  double? latitude;
  double? longitude;
  String? adresse;
  int? benutzer;

  Placard(this.id, this.latitude, this.longitude, this.adresse, this.benutzer);

  Placard.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    adresse = json['adresse'];
    benutzer = json['benutzer'];
  ***REMOVED***

  Map<dynamic, dynamic> toJson() =>
      {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': adresse,
        'benutzer': benutzer
      ***REMOVED***
***REMOVED***