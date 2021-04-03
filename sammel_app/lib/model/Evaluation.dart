class Evaluation {
  int? terminId;
  int? teilnehmer;
  int? unterschriften;
  int? bewertung;
  double? stunden;
  String? kommentar;
  String? situation;
  bool ausgefallen = false;

  Evaluation(this.terminId, this.teilnehmer, this.unterschriften,
      this.bewertung, this.stunden, this.kommentar, this.situation);

  Evaluation.ausgefallen() : ausgefallen = true;

  Map<String, dynamic> toJson() => {
        'termin_id': terminId,
        'teilnehmer': teilnehmer,
        'unterschriften': unterschriften,
        'bewertung': bewertung,
        'stunden': stunden,
        'kommentar': kommentar,
        'situation': situation,
        'ausgefallen': ausgefallen
      };
}
