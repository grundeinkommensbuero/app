import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/FileReader.dart';
import 'package:test/test.dart';

final kieze =
    File('./assets/geodata/bezirksregion_generalized.geojson');
final regionen =
    File('./assets/geodata/prognoseraum_generalized.geojson');
final ortsteile =
    File('/assets/geodata/ortsteil_generalized.geojson');

FileReader fileReaderMock = TestFileReader();

void main() {
  StammdatenService stammdatenService;
  setUp(() {
    StammdatenService.fileReader = TestFileReader();
    stammdatenService = StammdatenService();
  ***REMOVED***);

  test('reads Kiez main features from files', () async {
    var kieze = await stammdatenService.kieze;

    expect(kieze.length, 138);

    expect(kieze.toList()[0].region, 'Wedding');
    expect(kieze.toList()[0].name, 'Tiergarten Süd');

    expect(kieze.toList()[1].region, 'Wedding');
    expect(kieze.toList()[1].name, 'Regierungsviertel');

    expect(kieze.toList()[2].region, 'Wedding');
    expect(kieze.toList()[2].name, 'Alexanderplatz');
  ***REMOVED***);
***REMOVED***

class TestFileReader extends Mock implements FileReader {
  TestFileReader() {
    when(this.kieze).thenAnswer((_) => kieze.readAsString());
    when(this.regionen).thenAnswer((_) => regionen.readAsString());
    when(this.ortsteile).thenAnswer((_) => ortsteile.readAsString());
  ***REMOVED***
***REMOVED***
