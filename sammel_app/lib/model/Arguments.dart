
import 'package:easy_localization/easy_localization.dart';

class Arguments {
  String arguments;
  DateTime date;
  String? plz;
  
  Arguments(this.arguments, this.date, this.plz);

  Map<String, dynamic> toJson() => {
    'vorbehalte': arguments,
    'datum': DateFormat('yyyy-MM-dd').format(date),
    'ort': plz,
  ***REMOVED***
***REMOVED***