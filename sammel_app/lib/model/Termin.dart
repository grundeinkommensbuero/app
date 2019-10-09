import 'package:sammel_app/services/Benutzer.dart';

import 'Ort.dart';

class Termin {
  int id;
  DateTime beginn;
  DateTime ende;
  Ort ort;
  List<Benutzer> teilnehmer;

  Termin(this.id, this.beginn, this.ende, this.ort, this.teilnehmer);

  Termin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        beginn = DateTime.parse(json['beginn']),
        ende = DateTime.parse(json['ende']),
        ort = Ort.fromJson(json['ort']),
        teilnehmer = (json['teilnehmer'] as List)
            .map((json) => Benutzer.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'beginn': beginn.toIso8601String(),
        'ende': ende.toIso8601String(),
        'ort': ort,
        'teilnehmer': teilnehmer,
      ***REMOVED***
***REMOVED***
