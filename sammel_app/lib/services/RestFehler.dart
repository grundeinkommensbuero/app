class RestFehler implements Exception {
  String message;

  RestFehler(String reason) {
    this.message = '$reason';
  ***REMOVED***

  RestFehler.fromJson(Map<String, dynamic> json) : message = json['meldung'];
***REMOVED***
