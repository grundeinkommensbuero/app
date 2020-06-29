import 'dart:ui';

class User {
  int id;
  String name;
  Color color;

  User(this.id, this.name, this.color);

  User.fromJSON(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    if (json['color'] != null) this.color = Color(json['color']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color?.value,
      };
}