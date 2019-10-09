class Benutzer {
  String name;
  String telefonnummer;

  Benutzer(this.name, [this.telefonnummer]);

  Benutzer.fromJson(Map<String, dynamic> json) :
      name = json['name'],
      telefonnummer = json['telefonnummer'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'telefonnummer': telefonnummer,
      ***REMOVED***
***REMOVED***