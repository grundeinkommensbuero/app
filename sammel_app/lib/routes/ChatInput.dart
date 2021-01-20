import 'package:easy_localization/easy_localization.dart';
import 'dart:io';

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
    return Column(mainAxisSize: MainAxisSize.min ,children: [
      Container(
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
                  minLines: 1,
                  maxLines: 5,
                  autocorrect: true,
                  keyboardType: TextInputType.multiline,
                  //     focusNode: myFocusNode,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(Platform.isIOS ? 10.0 : 5.0, 5.0, 5.0, 5.0),
                    border: InputBorder.none,
                    hintText: 'Nachricht eingeben...'.tr(),
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
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.blueGrey, width: 0.5)),
            color: Colors.white),
      )),
      Platform.isIOS // manche iPhones verdecken den unteren Bereich mit einem Steuerelement -.-
          ? Container(
              height: 20,
              decoration: BoxDecoration(
                  color: DweTheme.yellow,
                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)]))
          : SizedBox()
    ]);
  }
}
