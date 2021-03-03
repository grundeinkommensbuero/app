import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

class TermineFilter {
  List<String> typen;
  List<DateTime> tage;
  TimeOfDay von;
  TimeOfDay bis;
  List<String> orte;

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
        orte = (json['orte'] as List<dynamic>).map((e) => e as String).toList();

  Map<String, dynamic> toJson() => {
        'typen': typen,
        'tage':
            tage.map((tag) => DateFormat('yyyy-MM-dd').format(tag)).toList(),
        'von': ChronoHelfer.timeToStringHHmmss(von),
        'bis': ChronoHelfer.timeToStringHHmmss(bis),
        'orte': orte,
      };

  get isEmpty =>
      (tage == null || tage.isEmpty) &&
      (bis == null || bis == null) &&
      von == null &&
      (orte == null || orte.isEmpty) &&
      (typen == null || typen.isEmpty);
}
