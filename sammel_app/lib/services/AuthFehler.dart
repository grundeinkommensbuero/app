class AuthFehler {
  String reason;

  AuthFehler(this.reason);

  // TODO auf neue Deserialisierung umstellen
  AuthFehler.deserialisiere(Map<String, dynamic> json)
      : reason = json['meldung'];
}