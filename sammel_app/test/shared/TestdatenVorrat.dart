import 'package:flutter/material.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/User.dart';

User karl() => User(11, 'Karl Marx', Colors.red);

User rosa() => User(12, 'Rosa Luxemburg', Colors.purple);

Kiez ffAlleeNord() => Kiez(
    'Friedrichshain-Kreuzberg', 'Frankfurter Allee Nord', 52.51579, 13.45399);

Kiez tempVorstadt() => Kiez(
    'Friedrichshain-Kreuzberg', 'Tempelhofer Vorstadt', 52.48993, 13.46839);

Kiez plaenterwald() =>
    Kiez('Treptow-Köpenick', 'Plänterwald', 52.49653, 13.43762);
