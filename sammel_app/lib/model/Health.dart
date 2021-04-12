class ServerHealth {
  String status = '';
  String minClient = '';
  String version = '';
  DateTime? faqTimestamp;

  ServerHealth();

  ServerHealth.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    minClient = json['minClient'];
    version = json['version'];
    faqTimestamp = DateTime.tryParse(json['faqTimestamp']);
  ***REMOVED***

  get alive => status == 'lebendig';
***REMOVED***
