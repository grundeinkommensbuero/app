
import 'package:sammel_app/shared/DeserialisationException.dart';

class Placard {
  int? id;
  late double latitude;
  late double longitude;
  late String adresse;
  late int benutzer;
  late bool abgehangen;

  Placard(this.id, this.latitude, this.longitude, this.adresse, this.benutzer,
      this.abgehangen);

  Placard.fromJson(Map<dynamic, dynamic> json) {
    List<String> missingValues = [];
    if (json['latitude'] == null) missingValues.add("latitude");
    if (json['longitude'] == null) missingValues.add("longitude");
    if (json['adresse'] == null) missingValues.add("adresse");
    if (json['benutzer'] == null) missingValues.add("benutzer");
    if (json['abgehangen'] == null) missingValues.add("abgehangen");
    if (missingValues.isNotEmpty)
      throw DeserialisationException('Fehlende Werte: ${missingValues.join(', ')***REMOVED***');

    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    adresse = json['adresse'];
    benutzer = json['benutzer'];
    abgehangen = json['abgehangen'];
  ***REMOVED***

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': adresse,
        'benutzer': benutzer,
        'abgehangen': abgehangen,
      ***REMOVED***
***REMOVED***
