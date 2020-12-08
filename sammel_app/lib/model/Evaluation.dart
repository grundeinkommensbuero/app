import 'package:sammel_app/model/User.dart';

import 'Ort.dart';
import 'TerminDetails.dart';

class Evaluation {
  // TODO
  // maybe this needs an id here for connection with a specific action?
  int signatures;

  Evaluation(this.signatures);

  Evaluation.fromJson(Map<String, dynamic> json)
  : signatures = json['signatures'];

  Map<String, dynamic> toJson() => {
        'signatures' : signatures
      };
}