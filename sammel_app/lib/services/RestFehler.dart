class RestFehler {
  String reason;

  RestFehler(String reason) {
    this.reason = reason;
  ***REMOVED***

  String message() => '$reason\n\n'
      'Wenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com';

  RestFehler.fromJson(Map<String, dynamic> json)
      : reason = json['meldung'];
***REMOVED***