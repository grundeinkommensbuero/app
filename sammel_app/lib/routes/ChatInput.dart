import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sammel_app/shared/DweTheme.dart';

class ChatInputWidget extends StatefulWidget {
  Function(TextEditingController) onSendMessage;
  TextEditingController textEditingController = TextEditingController();

  ChatInputWidget(this.onSendMessage, {Key key}) : super(key: key);

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInputWidget> {
  Widget build(context) {
    print(widget.textEditingController);
    return SizedBox(
        child: Container(
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
                      hintText: tr('Nachricht eingeben...'),
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
                    onPressed: () {
                      return widget.onSendMessage(widget.textEditingController);
                    },
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
              border:
                  Border(top: BorderSide(color: Colors.blueGrey, width: 0.5)),
              color: Colors.white),
        ),
        height: 40);
  }
}
