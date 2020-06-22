import 'dart:ui';

class User
{
  String user_id = null;
  String nick_name = null;
  Color user_color = null;

  User(this.nick_name, this.user_id, this.user_color);


  User.fromJSON(Map<dynamic, dynamic> json) {
    this.user_id = json['user_id'];
    this.nick_name = json['nick_name'];
    this.user_color = Color(json['user_color']);
  }

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'nick_name': nick_name,
    'user_color': user_color.value,
  };
}