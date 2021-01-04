import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/FileReader.dart';
import 'package:test/test.dart';

import '../shared/Mocks.dart';

void main() {
  FileReader fileReaderMock = FileReaderMock();
  StammdatenService service;

  final kiezeCentroids = File('./assets/geodata/Bezirksregionen/Berlin_bezirksregionen_poi.geojson');
  final kiezePolygons = File('./assets/geodata/Bezirksregionen/Berlin_bezirksregionen_polygons.geojson');
  final ortsteileCentroids = File('./assets/geodata/Prognoseraeume/Berlin_prognoseraeume_poi.geojson');
  final ortsteilePolygons = File('./assets/geodata/Prognoseraeume/Berlin_prognoseraeume_polygons.geojson');
  final bezirke = File('./assets/geodata/Bezirke/Berlin_bezirke.geojson');

  setUp(() {
    when(fileReaderMock.loadKiezeCentroids())
        .thenAnswer((_) => kiezeCentroids.readAsString());
    when(fileReaderMock.loadKiezePolygons())
        .thenAnswer((_) => kiezePolygons.readAsString());
    when(fileReaderMock.loadOrtsteileCentroids())
        .thenAnswer((_) => ortsteileCentroids.readAsString());
    when(fileReaderMock.loadOrtsteilePolygons())
        .thenAnswer((_) => ortsteilePolygons.readAsString());
    when(fileReaderMock.loadBezirke())
        .thenAnswer((_) => bezirke.readAsString());
    StammdatenService.fileReader = fileReaderMock;
    service = StammdatenService();
  });

  test('reads Kiez main features from files', () async {
    var kieze = await service.kieze;

    expect(kieze.length, 138);

    expect(kieze.toList()[0].bezirk, 'Mitte');
    expect(kieze.toList()[0].name, 'Tiergarten Süd');

    expect(kieze.toList()[1].bezirk, 'Mitte');
    expect(kieze.toList()[1].name, 'Regierungsviertel');

    expect(kieze.toList()[2].bezirk, 'Mitte');
    expect(kieze.toList()[2].name, 'Alexanderplatz');
  });
}
