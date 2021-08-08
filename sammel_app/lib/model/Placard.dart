import 'package:sammel_app/shared/DeserialisiationError.dart';

class Placard {
  int? id;
  late double latitude;
  late double longitude;
  late String adresse;
  late int benutzer;

  Placard(this.id, this.latitude, this.longitude, this.adresse, this.benutzer);

  Placard.fromJson(Map<dynamic, dynamic> json) {
    List<String> missingValues = [];
    if (json['latitude'] == null) missingValues.add("latitude");
    if (json['longitude'] == null) missingValues.add("longitude");
    if (json['adresse'] == null) missingValues.add("adresse");
    if (json['benutzer'] == null) missingValues.add("benutzer");
    if (missingValues.isNotEmpty)
      throw DeserialisationError('Fehlende Werte: ${missingValues.join(', ')***REMOVED***');

    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    adresse = json['adresse'];
    benutzer = json['benutzer'];
  ***REMOVED***

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': adresse,
        'benutzer': benutzer
      ***REMOVED***
***REMOVED***
