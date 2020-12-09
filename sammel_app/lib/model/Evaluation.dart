import 'package:sammel_app/model/User.dart';

import 'Ort.dart';
import 'TerminDetails.dart';

class Evaluation {
  // TODO
  // maybe this needs an id here for connection with a specific action?
  int unterschriften;
  int teilnehmende;
  double stunden;
  String kommentar;
  String erkenntnisse;

  Evaluation(this.unterschriften, this.teilnehmende, this.stunden, this.kommentar, this.erkenntnisse);
}