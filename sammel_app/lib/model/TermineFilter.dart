import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

class TermineFilter {
  List<String> typen;
  List<DateTime> tage;
  TimeOfDay? von;
  TimeOfDay? bis;
  List<String> orte;
  bool? nurEigene;
  bool? immerEigene;

  TermineFilter(this.typen, this.tage, this.von, this.bis, this.orte,
      this.nurEigene, this.immerEigene);

  static leererFilter() => TermineFilter([], [], null, null, [], false, true);

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
        orte = (json['orte'] as List<dynamic>).map((e) => e as String).toList(),
        nurEigene = json['nurEigene'] as bool,
        immerEigene = json['immerEigene'] as bool;

  Map<String, dynamic> toJson() => {
        'typen': typen,
        'tage':
            tage.map((tag) => DateFormat('yyyy-MM-dd').format(tag)).toList(),
        'von': ChronoHelfer.timeToStringHHmmss(von),
        'bis': ChronoHelfer.timeToStringHHmmss(bis),
        'orte': orte,
        'nurEigene': nurEigene,
        'immerEigene': immerEigene
      };

  get isEmpty =>
      tage.isEmpty &&
      bis == null &&
      von == null &&
      orte.isEmpty &&
      typen.isEmpty &&
      nurEigene != true &&
      immerEigene != false;
}
