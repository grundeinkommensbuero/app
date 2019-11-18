import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Ort.dart';

class TermineFilter {
  List<String> typen;
  List<DateTime> tage;
  Time von;
  Time bis;
  List<Ort> orte;

  TermineFilter(this.typen, this.tage, this.von, this.bis, this.orte);

  static leererFilter() => TermineFilter([], [], null, null, []);

  TermineFilter.fromJSON(Map<String, dynamic> json)
      : typen = json['typen'],
        tage = json['tage'],
        von = json['von'],
        bis = json['bis'],
        orte = json['orte'];

  Map<String, dynamic> toJson() => {
        'typen': typen,
        'tage': tage,
        'von': von,
        'bis': bis,
        'orte': orte,
      ***REMOVED***
***REMOVED***
