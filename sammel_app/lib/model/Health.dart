class ServerHealth {
  String status;
  String minClient;
  String version;

  ServerHealth.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    minClient = json['minClient'];
    version = json['version'];
  ***REMOVED***

  get alive => status == 'lebendig';
***REMOVED***
