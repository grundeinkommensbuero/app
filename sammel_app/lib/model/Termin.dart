import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

import 'Kiez.dart';
import 'TerminDetails.dart';

class Termin {
  int? id;
  DateTime beginn;
  DateTime ende;
  Kiez ort;
  String typ;
  double latitude;
  double longitude;
  List<User>? participants;
  TerminDetails? details;

  Termin(this.id, this.beginn, this.ende, this.ort, this.typ, this.latitude,
      this.longitude, this.participants, this.details);

  Termin.fromJson(Map<String, dynamic> json, Set<Kiez> kieze)
      : id = json['id'],
        beginn = ChronoHelfer.deserializeJsonDateTime(json['beginn']),
        ende = ChronoHelfer.deserializeJsonDateTime(json['ende']),
        ort = kieze.firstWhere((kiez) => json['ort'] == kiez.name),
        typ = json['typ'] ?? 'Termin',
        latitude = json['latitude'] ?? null,
        longitude = json['longitude'] ?? null,
        participants = (json['participants'] as List?)
            ?.map((user) => User.fromJSON(user))
            .toList(),
        details = json['details'] != null
            ? TerminDetails.fromJSON(json['details'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'beginn': beginn.toIso8601String(),
        'ende': ende.toIso8601String(),
        'ort': ort.toJson(),
        'typ': typ,
        'latitude': latitude,
        'longitude': longitude,
        'participants': participants?.map((user) => user.toJson()).toList(),
        'details': details == null ? null : details?.toJson(),
      };

  bool isEvaluated(List<int>? evaluatedActionIds) {
    if (this.typ != 'Sammeln') return true;
    if (evaluatedActionIds == null) return false;
    if (evaluatedActionIds.contains(this.id)) return true;
    return false;
  }

  String getAsset({bool centered = false}) {
    switch (typ) {
      case 'Sammeln':
        return centered
            ? 'assets/images/Sammeln_centered.png'
            : 'assets/images/Sammeln.png';
      case 'Infoveranstaltung':
        return 'assets/images/Infoveranstaltung.png';
      case 'Workshop':
        return centered
            ? 'assets/images/Workshop_centered.png'
            : 'assets/images/Workshop.png';
      case 'Plakatieren':
        return 'assets/images/Plakatieren.png';
      case 'Kundgebung':
        return centered
            ? 'assets/images/Kundgebung_centered.png'
            : 'assets/images/Kundgebung.png';
      case 'Haust??rgespr??che':
        return 'assets/images/Haustuergespraeche.png';
      case 'Stra??engespr??che & Flyern':
        return 'assets/images/StrassengespraecheUndFlyern.png';
      case 'Kiezfest':
        return 'assets/images/Kiezfest.png';
      case 'Plakate aufh??ngen':
        return 'assets/images/PlakateAufhaengen.png';
    }
    return 'assets/images/logo_transparent.png'; // Platzhalter
  }

  static final int Function(Termin a, Termin b) compareByStart =
      (termin1, termin2) => termin1.beginn.compareTo(termin2.beginn);
}

class ActionWithToken {
  final Termin? action;
  final String? token;

  ActionWithToken(this.action, this.token);

  Map<String, dynamic> toJson() => {
        'action': action,
        'token': token,
      };

  ActionWithToken.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        token = json['token'];
}
