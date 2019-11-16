import 'dart:convert';

import 'package:sammel_app/model/TerminDetails.dart';
import 'package:test/test.dart';

void main() {
  test('serialisert TerminDetailt mit Treffpunkt, Kommentar und Kontakt', () {
    var json = jsonEncode(TerminDetailsTestDaten.terminDetailsTestDaten());
    expect(
        json,
        '{'
        '"treffpunkt":"Weltzeituhr",'
        '"kommentar":"Bringe Westen und Klämmbretter mit",'
        '"kontakt":"Ruft an unter 012345678"'
        '***REMOVED***');
  ***REMOVED***);
  test('deserialisert TerminDetailt mit Treffpunkt, Kommentar und Kontakt', () {
    var json = '{'
        '"treffpunkt":"Weltzeituhr",'
        '"kommentar":"Bringe Westen und Klämmbretter mit",'
        '"kontakt":"Ruft an unter 012345678"'
        '***REMOVED***';
    var terminDetails = TerminDetails.fromJSON(jsonDecode(json));
    expect(terminDetails.treffpunkt, 'Weltzeituhr');
    expect(terminDetails.kommentar, 'Bringe Westen und Klämmbretter mit');
    expect(terminDetails.kontakt, 'Ruft an unter 012345678');
  ***REMOVED***);
***REMOVED***

class TerminDetailsTestDaten {
  static TerminDetails terminDetailsTestDaten() => TerminDetails('Weltzeituhr',
      'Bringe Westen und Klämmbretter mit', 'Ruft an unter 012345678');
***REMOVED***
