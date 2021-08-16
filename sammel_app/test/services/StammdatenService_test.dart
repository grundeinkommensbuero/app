import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/FileReader.dart';
import 'package:test/test.dart';

final kiezeFile = File('./assets/geodata/bezirksregion_generalized.geojson');
final regionenFile = File('./assets/geodata/prognoseraum_generalized.geojson');
final ortsteileFile = File('./assets/geodata/ortsteil_generalized.geojson');

FileReader fileReaderMock = TestFileReader();

void main() {
  late StammdatenService stammdatenService;
  setUp(() {
    StammdatenService.fileReader = TestFileReader();
    stammdatenService = StammdatenService();
  ***REMOVED***);

  test('reads Kiez main features from files', () async {
    var kieze = await stammdatenService.kieze;

    expect(kieze.length, 138);

    expect(kieze.toList()[0].ortsteil, 'Mitte');
    expect(kieze.toList()[0].region, 'Zentrum - Mitte');
    expect(kieze.toList()[0].name, 'Brunnenstraße Süd');

    expect(kieze.toList()[1].ortsteil, 'Prenzlauer Berg');
    expect(kieze.toList()[1].region, 'Nördlicher Prenzlauer Berg');
    expect(kieze.toList()[1].name, 'Prenzlauer Berg Nordwest');

    expect(kieze.toList()[2].ortsteil, 'Wilmersdorf');
    expect(kieze.toList()[2].region, 'CW 6');
    expect(kieze.toList()[2].name, 'Forst Grunewald');
  ***REMOVED***);
***REMOVED***

class TestFileReader extends Mock implements FileReader {
  late Future<String> kieze;
  late Future<String> regionen;
  late Future<String> ortsteile;

  TestFileReader() {
    kieze = Future.value(kiezeFile.readAsString());
    regionen = Future.value(regionenFile.readAsString());
    ortsteile = Future.value(ortsteileFile.readAsString());
  ***REMOVED***
***REMOVED***
