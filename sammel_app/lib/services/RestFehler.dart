class RestFehler implements Exception {
  String message;

  RestFehler(String reason) {
    this.message =
        '$reason\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com';
  }

  RestFehler.fromJson(Map<String, dynamic> json) : message = json['meldung'];
}
