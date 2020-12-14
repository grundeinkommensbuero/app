import 'package:sammel_app/model/User.dart';

import 'Ort.dart';
import 'TerminDetails.dart';

class Evaluation {
  int terminId;
  int unterschriften;
  int teilnehmende;
  double stunden;
  String kommentar;
  String erkenntnisse;

  Evaluation(this.terminId, this.unterschriften, this.teilnehmende, this.stunden, this.kommentar, this.erkenntnisse);
}