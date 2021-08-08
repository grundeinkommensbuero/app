
import 'package:easy_localization/easy_localization.dart';

import 'Kiez.dart';

class Arguments {
  String arguments;
  DateTime date;
  Kiez? kiez;
  
  Arguments(this.arguments, this.date, this.kiez);

  Map<String, dynamic> toJson() => {
    'vorbehalte': arguments,
    'datum': DateFormat('yyyy-MM-dd').format(date),
    'ort': kiez?.name,
  ***REMOVED***
***REMOVED***