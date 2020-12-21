import 'package:flutter/services.dart';

class FileReader {
  static const plz_centroids = 'assets/geodata/plz-berlin-centroids.json';
  static const plz_polygons = 'assets/geodata/plz-berlin-polygons.json';
  static const lor_centroids = 'assets/geodata/lor_berlin_centroids.json';
  static const lor_polygons = 'assets/geodata/lor_berlin_polygons.json';

  FileReader();

  Future<String> loadLorCentroids() async =>
      await rootBundle.loadString(lor_centroids);

  Future<String> loadLorPolygons() async =>
      await rootBundle.loadString(lor_polygons);

  Future<String> loadPlzCentroids() async =>
      await rootBundle.loadString(plz_centroids);

  Future<String> loadPlzPolgons() async =>
      await rootBundle.loadString(plz_centroids);
***REMOVED***
