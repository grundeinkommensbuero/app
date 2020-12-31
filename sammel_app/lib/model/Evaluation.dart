class Evaluation {
  int terminId;
  int unterschriften;
  int bewertung;
  double stunden;
  String kommentar;
  String situation;

  Evaluation(this.terminId, this.unterschriften, this.bewertung, this.stunden, this.kommentar, this.situation);

  Map<String, dynamic> toJson() => {
    'termin_id': terminId,
    'unterschriften': unterschriften,
    'bewertung': bewertung,
    'stunden': stunden,
    'kommentar': kommentar,
    'situation': situation
  };
}