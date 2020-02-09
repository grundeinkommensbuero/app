class AuthFehler {
  String reason;

  AuthFehler(String reason) {
    this.reason = reason;
  }

  String message() => '$reason\n\n'
      'Wenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com';

  AuthFehler.fromJson(Map<String, dynamic> json) : reason = json['meldung'];
}
