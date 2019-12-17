import 'Ort.dart';
import 'TerminDetails.dart';

class Termin {
  int id;
  DateTime beginn;
  DateTime ende;
  Ort ort;
  String typ;
  TerminDetails terminDetails;

  Termin(
      this.id, this.beginn, this.ende, this.ort, this.typ, this.terminDetails);

  Termin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        beginn = DateTime.parse(json['beginn']),
        ende = DateTime.parse(json['ende']),
        ort = Ort.fromJson(json['ort']),
        typ = json['typ'] ?? 'Termin',
        terminDetails = json['terminDetails'] != null
            ? TerminDetails.fromJSON(json['terminDetails'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'beginn': beginn.toIso8601String(),
        'ende': ende.toIso8601String(),
        'ort': ort,
        'typ': typ,
        'terminDetails': terminDetails,
      ***REMOVED***

  String getAsset() {
    switch (typ) {
      case 'Sammel-Termin':
        return 'assets/images/Sammel-Termin.png';
      case 'Info-Veranstaltung':
        return 'assets/images/Info-Veranstaltung.png';
    ***REMOVED***
    return '';
  ***REMOVED***
***REMOVED***
