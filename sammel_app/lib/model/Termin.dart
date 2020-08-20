import 'package:sammel_app/model/User.dart';

import 'Ort.dart';
import 'TerminDetails.dart';

class Termin {
  int id;
  DateTime beginn;
  DateTime ende;
  Ort ort;
  String typ;
  double latitude;
  double longitude;
  List<User> participants;
  TerminDetails details;

  Termin(this.id, this.beginn, this.ende, this.ort, this.typ, this.latitude,
      this.longitude, this.participants, this.details);

  Termin.emptyAction()
      : id = null,
        beginn = null,
        ende = null,
        ort = null,
        typ = null,
        latitude = null,
        longitude = null,
        participants = [],
        details = TerminDetails(null, null, null);

  Termin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        beginn = DateTime.parse(json['beginn']),
        ende = DateTime.parse(json['ende']),
        ort = Ort.fromJson(json['ort']),
        typ = json['typ'] ?? 'Termin',
        latitude = json['lattitude'] ?? null,
        longitude = json['longitude'] ?? null,
        participants = (json['participants'] as List)
            ?.map((user) => User.fromJSON(user))
            ?.toList(),
        details = json['details'] != null
            ? TerminDetails.fromJSON(json['details'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'beginn': beginn.toIso8601String(),
        'ende': ende.toIso8601String(),
        'ort':  ort == null ? null : ort.toJson(),
        'typ': typ,
        'lattitude': latitude,
        'longitude': longitude,
        'participants': participants?.map((user) => user.toJson())?.toList(),
        'details': details == null ? null : details.toJson(),
      ***REMOVED***

  String getAsset({bool centered = false***REMOVED***) {
    switch (typ) {
      case 'Sammeln':
        return centered
            ? 'assets/images/Sammeln_centered.png'
            : 'assets/images/Sammeln.png';
      case 'Infoveranstaltung':
        return 'assets/images/Infoveranstaltung.png';
    ***REMOVED***
    throw UnkownActionTypeException(
        'Cannot find asset for unknwon action type "$typ"');
  ***REMOVED***

  static final int Function(Termin a, Termin b) compareByStart =
      (termin1, termin2) => termin1.beginn.compareTo(termin2.beginn);
***REMOVED***

class UnkownActionTypeException extends Error {
  var message;

  UnkownActionTypeException(this.message) : super();

  @override
  String toString() {
    return '${super.toString()***REMOVED***: $message';
  ***REMOVED***
***REMOVED***

class ActionWithToken {
  final Termin action;
  final String token;

  ActionWithToken(this.action, this.token);

  Map<String, dynamic> toJson() => {
        'action': action,
        'token': token,
      ***REMOVED***

  ActionWithToken.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        token = json['token'];
***REMOVED***
