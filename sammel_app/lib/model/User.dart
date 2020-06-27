import 'dart:ui';

class User {
  String user_id = null;
  String nick_name = null;
  Color user_color = null;

  User(this.nick_name, this.user_id, this.user_color);

  User.fromJSON(Map<dynamic, dynamic> json) {
    this.user_id = json['user_id'];
    this.nick_name = json['nick_name'];
    if (json['user_color'] != null) this.user_color = Color(json['user_color']);
  ***REMOVED***

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'nick_name': nick_name,
        'user_color': user_color?.value,
      ***REMOVED***

  bool equals(User other) =>
      this.user_id == other?.user_id &&
      this.nick_name == other?.nick_name &&
      this.user_color?.value == other?.user_color?.value;
***REMOVED***
