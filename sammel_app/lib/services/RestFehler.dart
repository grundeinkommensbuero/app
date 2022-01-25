class RestFehler implements Exception {
  late String message;

  RestFehler(String reason) {
    this.message = '$reason';
  }

  RestFehler.fromJson(Map<String, dynamic> json) : message = json['meldung'];
}
