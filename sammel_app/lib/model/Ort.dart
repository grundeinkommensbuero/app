class Ort {
  int id;
  String bezirk;
  String ort;

  Ort(this.id, this.bezirk, this.ort);

  Ort.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bezirk = json['bezirk'] ?? '',
        ort = json['ort'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'bezirk': bezirk,
        'ort': ort,
      };
}
