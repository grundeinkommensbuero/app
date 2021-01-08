import 'package:flutter/services.dart';

const _ortsteile =
    'assets/geodata/ortsteil_generalized.geojson';
const _regionen =
    'assets/geodata/prognoseraum_generalized.geojson';
const _kieze =
    'assets/geodata/bezirksregion_generalized.geojson';

class FileReader {
  final Future<String> ortsteile = rootBundle.loadString(_ortsteile);
  final Future<String> regionen = rootBundle.loadString(_regionen);
  final Future<String> kieze = rootBundle.loadString(_kieze);
***REMOVED***
