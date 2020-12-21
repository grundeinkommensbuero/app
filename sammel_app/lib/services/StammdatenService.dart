import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/shared/FileReader.dart';

class StammdatenService {
  static FileReader fileReader = FileReader();
  Future<List<Kiez>> kieze = ladeKieze();

  StammdatenService();

  static Future<List<Kiez>> ladeKieze() async {
    var json = await fileReader.loadLor();

    List centroidMaps = jsonDecode(json);

    return centroidMaps.map((json) => Kiez.fromJson(json)).toList();
  ***REMOVED***
***REMOVED***
