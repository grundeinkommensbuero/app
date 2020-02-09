class TerminDetails {
  int id;
  String treffpunkt;
  String kommentar;
  String kontakt;

  TerminDetails(this.treffpunkt, this.kommentar, this.kontakt);

  TerminDetails.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        treffpunkt = json['treffpunkt'],
        kommentar = json['kommentar'],
        kontakt = json['kontakt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'treffpunkt': treffpunkt,
        'kommentar': kommentar,
        'kontakt': kontakt
      };
}
