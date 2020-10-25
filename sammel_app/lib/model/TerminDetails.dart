class TerminDetails {
  int id;
  String treffpunkt;
  String beschreibung;
  String kontakt;

  TerminDetails(this.treffpunkt, this.beschreibung, this.kontakt);

  TerminDetails.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        treffpunkt = json['treffpunkt'],
        beschreibung = json['beschreibung'],
        kontakt = json['kontakt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'treffpunkt': treffpunkt,
        'beschreibung': beschreibung,
        'kontakt': kontakt
      };
}
