import 'package:flutter/services.dart';

class FileReader {
  static const plz_centroids = 'assets/geodata/Bezirksregionenplz-berlin-centroids.json';
  static const plz_polygons = 'assets/geodata/plz-berlin-polygons.json';
  static const lor_berlin = 'assets/geodata/lor_berlin.json';
  static const kieze_centroids = 'assets/geodata/Bezirksregionen/Berlin_bezirksregionen_poi.geojson';
  static const kieze_polygons = 'assets/geodata/Bezirksregionen/Berlin_bezirksregionen_polygons.geojson';
  static const ortsteile_centroids = 'assets/geodata/Prognoseraeume/Berlin_prognoseraeume_poi.geojson';
  static const ortsteile_polygons = 'assets/geodata/Prognoseraeume/Berlin_prognoseraeume_polygons.geojson';
  static const bezirke = 'assets/geodata/Bezirke/Berlin_bezirke_custom_generalized.geojson';

  FileReader();

  Future<String> loadKiezeCentroids() async =>
      await rootBundle.loadString(kieze_centroids);

  Future<String> loadKiezePolygons() async =>
      await rootBundle.loadString(kieze_polygons);

  Future<String> loadOrtsteileCentroids() async =>
      await rootBundle.loadString(ortsteile_centroids);

  Future<String> loadOrtsteilePolygons() async =>
      await rootBundle.loadString(ortsteile_polygons);

  Future<String> loadBezirke() async =>
      await rootBundle.loadString(bezirke);

  Future<String> loadPlzCentroids() async =>
      await rootBundle.loadString(plz_centroids);

  Future<String> loadPlzPolgons() async =>
      await rootBundle.loadString(plz_centroids);
***REMOVED***
