import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sammel_app/model/Ort.dart';

import 'BackendService.dart';
import 'UserService.dart';

abstract class AbstractStammdatenService extends BackendService {
  Future<List<Kiez>> kieze;

  AbstractStammdatenService(AbstractUserService userService,
      [Backend backendMock])
      : super(userService, backendMock);
***REMOVED***

class StammdatenService extends AbstractStammdatenService {
  StammdatenService(AbstractUserService userService, [Backend backendMock])
      : super(userService, backendMock);
  final Future<List<Kiez>> kieze = StammdatenService.ladeKieze();

  static Future<List<Kiez>> ladeKieze() async {
    var centerJsons =
        await rootBundle.loadString('assets/geography/plz-berlin-centers.json');
    var vectorJsons =
        await rootBundle.loadString('assets/geography/plz-berlin-vectors.json');

    List centerMaps = jsonDecode(centerJsons);
    List vectorMaps = jsonDecode(vectorJsons);

    List<Kiez> kieze = centerMaps.map((json) => Kiez.fromJson(json)).toList();
    kieze.forEach((kiez) => kiez.addArea(
        vectorMaps.firstWhere((map) => map['properties']['plz'] == kiez.plz)));

    return kieze;
  ***REMOVED***
***REMOVED***

class DemoStammdatenService extends AbstractStammdatenService {
  DemoStammdatenService(
    userService,
  ) : super(userService, DemoBackend());

  static Kiez nordkiez = Kiez(1, 'Friedrichshain-Kreuzberg',
      'Friedrichshain Nordkiez', 52.51579, 13.45399);
  static Kiez treptowerPark =
      Kiez(2, 'Treptow-Köpenick', 'Treptower Park', 52.48993, 13.46839);
  static Kiez goerli = Kiez(3, 'Friedrichshain-Kreuzberg',
      'Görlitzer Park und Umgebung', 52.49653, 13.43762);

  static List<Kiez> orte = [nordkiez, treptowerPark, goerli];

  final Future<List<Kiez>> kieze = Future.value(orte);
***REMOVED***
