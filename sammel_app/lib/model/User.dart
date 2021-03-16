import 'dart:ui';

class User {
  int? id;
  String? name;
  Color? color;

  User(this.id, this.name, this.color);

  setUserData(User user){
    id = user.id;
    name = user.name;
    color = user.color;
  ***REMOVED***

  User.fromJSON(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.color = json['color'] != null ? Color(json['color']) : null;
  ***REMOVED***

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color?.value,
      ***REMOVED***
***REMOVED***