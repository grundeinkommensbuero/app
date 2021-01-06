import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/FileReader.dart';
import 'package:test/test.dart';

final kiezeCentroids =
    File('./assets/geodata/Bezirksregionen/Berlin_bezirksregionen_poi.geojson');
final kiezePolygons = File(
    './assets/geodata/Bezirksregionen/Berlin_bezirksregionen_polygons.geojson');
final ortsteileCentroids =
    File('./assets/geodata/Prognoseraeume/Berlin_prognoseraeume_poi.geojson');
final ortsteilePolygons = File(
    './assets/geodata/Prognoseraeume/Berlin_prognoseraeume_polygons.geojson');
final bezirke =
    File('assets/geodata/Bezirke/Berlin_bezirke_custom_generalized.geojson');

FileReader fileReaderMock = TestFileReader();

void main() {
  StammdatenService stammdatenService;
  setUp(() {
    reset(fileReaderMock);
    StammdatenService.fileReader = TestFileReader();
    stammdatenService = StammdatenService();
  });

  test('reads Kiez main features from files', () async {
    var kieze = await stammdatenService.kieze;

    expect(kieze.length, 138);

    expect(kieze.toList()[0].bezirk, 'Wedding');
    expect(kieze.toList()[0].name, 'Tiergarten Süd');

    expect(kieze.toList()[1].bezirk, 'Wedding');
    expect(kieze.toList()[1].name, 'Regierungsviertel');

    expect(kieze.toList()[2].bezirk, 'Wedding');
    expect(kieze.toList()[2].name, 'Alexanderplatz');
  });
}

class TestFileReader extends Mock implements FileReader {
  TestFileReader() {
    when(this.kiezeCentroids).thenAnswer((_) => kiezeCentroids.readAsString());
    when(this.kiezePolygons).thenAnswer((_) => kiezePolygons.readAsString());
    when(this.ortsteileCentroids)
        .thenAnswer((_) => ortsteileCentroids.readAsString());
    when(this.ortsteilePolygons)
        .thenAnswer((_) => ortsteilePolygons.readAsString());
    when(this.bezirke).thenAnswer((_) => bezirke.readAsString());
  }
}
