import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

import 'Ort.dart';

class TermineFilter {
  List<String> typen;
  List<DateTime> tage;
  TimeOfDay von;
  TimeOfDay bis;
  List<Ort> orte;

  TermineFilter(this.typen, this.tage, this.von, this.bis, this.orte);

  static leererFilter() => TermineFilter([], [], null, null, []);

  TermineFilter.fromJSON(Map<String, dynamic> json)
      : typen = (json['typen'] as List).map((typ) => typ as String).toList(),
        tage = (json['tage'] as List)
            .map((tag) => DateFormat("yyyy-MM-dd").parse(tag))
            .toList(),
        von = json['von'] == null ? null : TimeOfDay.fromDateTime(
          // Dirty Hack für Bug https://github.com/dart-lang/intl/issues/244
            DateFormat("yyyy HH:mm:ss").parse('2019 ' + json['von'])),
        bis = json['bis'] == null ? null : TimeOfDay.fromDateTime(
          // Dirty Hack für Bug https://github.com/dart-lang/intl/issues/244
            DateFormat("yyyy HH:mm:ss").parse('2019 ' + json['bis'])),
        orte =
        (json['orte'] as List).map((json) => Ort.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
        'typen': typen,
        'tage':
            tage.map((tag) => DateFormat('yyyy-MM-dd').format(tag)).toList(),
        'von': ChronoHelfer.timeToString(von),
        'bis': ChronoHelfer.timeToString(bis),
        'orte': orte,
      };
}
