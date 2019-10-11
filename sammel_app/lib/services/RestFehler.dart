import 'dart:convert';

class RestFehler {
  String meldung;

  RestFehler(this.meldung);

  // TODO auf neue Deserialisierung umstellen
  RestFehler.deserialisiere(Map<String, dynamic> json)
      : meldung = json['meldung'];
}
