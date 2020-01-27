import 'Ort.dart';
import 'TerminDetails.dart';

class Termin {
  int id;
  DateTime beginn;
  DateTime ende;
  Ort ort;
  String typ;
  TerminDetails details;

  Termin(this.id, this.beginn, this.ende, this.ort, this.typ, this.details);

  Termin.emptyAction()
      : id = null,
        beginn = null,
        ende = null,
        ort = null,
        typ = null,
        details = TerminDetails(null, null, null);

  Termin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        beginn = DateTime.parse(json['beginn']),
        ende = DateTime.parse(json['ende']),
        ort = Ort.fromJson(json['ort']),
        typ = json['typ'] ?? 'Termin',
        details = json['details'] != null
            ? TerminDetails.fromJSON(json['details'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'beginn': beginn.toIso8601String(),
        'ende': ende.toIso8601String(),
        'ort': ort,
        'typ': typ,
        'details': details,
      ***REMOVED***

  String getAsset() {
    switch (typ) {
      case 'Sammeln':
        return 'assets/images/Sammeln.png';
      case 'Infoveranstaltung':
        return 'assets/images/Infoveranstaltung.png';
    ***REMOVED***
    return '';
  ***REMOVED***

  static final int Function(Termin a, Termin b) compareByStart =
      (termin1, termin2) => termin1.beginn.compareTo(termin2.beginn);
***REMOVED***
