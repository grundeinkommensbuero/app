import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DweTheme.dart';

class ChatInputWidget extends StatefulWidget {

  var onSendMessage;
  TextEditingController textEditingController = TextEditingController();

  ChatInputWidget(this.onSendMessage, {Key key***REMOVED***) : super(key: key) {
  ***REMOVED***

  @override
  ChatInputState createState() => ChatInputState();
***REMOVED***

class ChatInputState extends State<ChatInputWidget>
{

  Widget build(context) {
    print(widget.textEditingController);
    return SizedBox(child: Container(
      key: Key('InputWidgetContainer'),
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                autofocus: false,
                // key: _formKey,
                style: TextStyle(color: DweTheme.purple, fontSize: 15.0),
                controller: widget.textEditingController,
                //     focusNode: myFocusNode,
                decoration: InputDecoration.collapsed(
                  hintText: 'Nachricht eingeben...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {widget.onSendMessage(widget.textEditingController.text); widget.textEditingController.clear();***REMOVED***,
                color: DweTheme.purple,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.blueGrey, width: 0.5)),
          color: Colors.white),
    ), height: 40);
  ***REMOVED***
***REMOVED***
