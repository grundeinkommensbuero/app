
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:sammel_app/shared/ChatWindow.dart';

class Message
{
  String text = null;
  String sender_name = null;
  DateTime sending_time = null;
  Color message_color = null;

  Message({this.text, this.sender_name, this.sending_time, this.message_color***REMOVED***);

  Message.fromJSON(Map<dynamic, dynamic> json_message_data)
  {
    text = json_message_data['text'];
    sender_name = json_message_data['sender_name'];
    sending_time = DateTime.parse(json_message_data['sending_time']);
    message_color = Color(int.parse(json_message_data['color']));
  ***REMOVED***

  Map<String, dynamic> toJson() => {
    'text': text,
    'sender_name': sender_name,
    'sending_time': sending_time.toString(),
    'color': message_color.value
  ***REMOVED***
***REMOVED***

abstract class Channel
{
  String name = null;
  List<Message> channel_messages = null;
  List<String> member_names = null;

  Channel(this.name, {this.channel_messages, this.member_names***REMOVED***);

  Future<void> channelCallback(Message message);

  getAllMessages() {
    return channel_messages;
  ***REMOVED***

  List<String> get_member_names() {
    return member_names;
  ***REMOVED***
***REMOVED***

class SimpleMessageChannel extends Channel
{

  List<Message> channel_messages = null;
  ChannelChangeListener ccl = null;

  SimpleMessageChannel(String name) : super(name){
    this.channel_messages = List<Message>();
  ***REMOVED***

  @override
  Future<void> channelCallback(Message message) {
    // TODO: implement channelCallback
      if(!channel_messages.contains(message))
        {
          channel_messages.add(message);
        ***REMOVED***

      if(ccl != null)
        {
          ccl.channelChanged(this);
        ***REMOVED***
  ***REMOVED***

  void register_widget(ChannelChangeListener c)
  {
    if(ccl == null)
      {
        ccl = c;
      ***REMOVED***
    else
      {
        print('The Channel is already associated toa widget');
      ***REMOVED***
  ***REMOVED***

  void dispose_widget()
  {
    ccl = null;
  ***REMOVED***

***REMOVED***

class User
{
  String nick_name = null;
  String user_id = null;
  Color user_color = null;

  User(this.nick_name, this.user_id, this.user_color);


  User.fromJSON(Map<dynamic, dynamic> json) {
    this.nick_name = json['nick_name'];
    this.user_id = json['user_id'];
    this.user_color = Color(json['user_color']);
  ***REMOVED***

  Map<String, dynamic> toJson() => {
    'nick_name': nick_name,
    'user_id': user_id,
    'user_color': user_color.value,
  ***REMOVED***
***REMOVED***