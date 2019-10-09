import 'dart:convert';

class RestFehler {
  String meldung;

  RestFehler(this.meldung);

  // TODO auf neue Deserialisierung umstellen
  RestFehler.deserialisiere(String json)
      : meldung = JsonDecoder().convert(json)['meldung'];
***REMOVED***
