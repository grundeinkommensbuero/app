import 'package:flutter/services.dart';

const _kieze_centroids =
    'assets/geodata/Bezirksregionen/Berlin_bezirksregionen_poi.geojson';
const _kieze_polygons =
    'assets/geodata/Bezirksregionen/Berlin_bezirksregionen_polygons.geojson';
const _ortsteile_centroids =
    'assets/geodata/Prognoseraeume/Berlin_prognoseraeume_poi.geojson';
const _ortsteile_polygons =
    'assets/geodata/Prognoseraeume/Berlin_prognoseraeume_polygons.geojson';
const _bezirke =
    'assets/geodata/Bezirke/Berlin_bezirke_custom_generalized.geojson';

class FileReader {
  Future<String> kiezeCentroids =
      rootBundle.loadString(_kieze_centroids);
  final Future<String> kiezePolygons =
      rootBundle.loadString(_kieze_polygons);
  final Future<String> ortsteileCentroids =
      rootBundle.loadString(_ortsteile_centroids);
  final Future<String> ortsteilePolygons =
      rootBundle.loadString(_ortsteile_polygons);
  final Future<String> bezirke = rootBundle.loadString(_bezirke);
}
