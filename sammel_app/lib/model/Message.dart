import 'dart:ui';

class Message
{
  String text;
  String sender_name;
  DateTime sending_time;
  Color message_color;
  bool obtained_from_server = false;

  Message({this.text, this.sender_name, this.sending_time, this.message_color, this.obtained_from_server=false});

  Message.fromJSON(Map<dynamic, dynamic> json_message_data)
  {
    text = json_message_data['text'];
    sender_name = json_message_data['sender_name'];
    sending_time = DateTime.parse(json_message_data['sending_time']);
    message_color = Color(int.parse(json_message_data['color'].toString()));
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'sender_name': sender_name,
    'sending_time': sending_time.toString(),
    'color': message_color.value
  };

  bool isMessageEqual(Message msg)
  {
    return msg.text == text && msg.sender_name == msg.sender_name
        && sending_time == msg.sending_time && message_color == msg.message_color;
  }

}