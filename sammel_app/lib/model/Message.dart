import 'dart:ui';

class Message
{
  String text;
  String sender_name;
  DateTime sending_time;
  Color message_color;
  bool obtained_from_server = false;
  int user_id = -1;

  Message({this.text, this.sender_name, this.sending_time, this.message_color, this.obtained_from_server=false, this.user_id***REMOVED***);

  Message.fromJSON(Map<dynamic, dynamic> json_message_data)
  {
    text = json_message_data['text'];
    sender_name = json_message_data['sender_name'];
    sending_time = DateTime.parse(json_message_data['sending_time']);
    message_color = Color(int.parse(json_message_data['color'].toString()));
    obtained_from_server = json_message_data['from_server'] ;
    user_id = int.parse(json_message_data['user_id'].toString());
  ***REMOVED***

  Map<String, dynamic> toJson() => {
    'text': text,
    'sender_name': sender_name,
    'user_id': user_id,
    'sending_time': sending_time.toString(),
    'color': message_color.value,
    'from_server': obtained_from_server
  ***REMOVED***

  bool isMessageEqual(Message msg)
  {
    return msg.text == text && msg.sender_name == msg.sender_name
        && sending_time == msg.sending_time && message_color == msg.message_color  && user_id == msg.user_id && obtained_from_server == msg.obtained_from_server;
  ***REMOVED***

***REMOVED***