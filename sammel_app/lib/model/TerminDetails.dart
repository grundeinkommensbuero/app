class TerminDetails {
  String treffpunkt;
  String kommentar;
  String kontakt;

  TerminDetails(this.treffpunkt, this.kommentar, this.kontakt);

  TerminDetails.fromJSON(Map<String, dynamic> json)
      : treffpunkt = json['treffpunkt'],
        kommentar = json['kommentar'],
        kontakt = json['kontakt'];

  Map<String, dynamic> toJson() =>
      {'treffpunkt': treffpunkt, 'kommentar': kommentar, 'kontakt': kontakt};
}
