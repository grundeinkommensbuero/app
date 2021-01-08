import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  static var fileReader = FileReader();

  final Future<Set<Kiez>> kieze = loadKieze();
  final Future<Set<Region>> regionen = loadRegionen();
  final Future<Set<Ortsteil>> ortsteile = loadOrtsteile();

  StammdatenService();

  static Future<Set<Kiez>> loadKieze() async {
    var json = await fileReader.kieze;

    return (jsonDecode(json)['features'] as List)
        .map((json) => Kiez.fromJson(json))
        .toSet();
  ***REMOVED***

  static Future<Set<Region>> loadRegionen() async {
    final json = await fileReader.regionen;

    return (jsonDecode(json)['features'] as List)
        .map((json) => Region.fromJson(json))
        .toSet();
  ***REMOVED***

  static Future<Set<Ortsteil>> loadOrtsteile() async {
    final json = await fileReader.ortsteile;

    return (jsonDecode(json)['features'] as List)
        .map((json) => Ortsteil.fromJson(json))
        .toSet();
  ***REMOVED***
***REMOVED***
