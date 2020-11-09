import 'package:flutter/material.dart';
import 'package:sammel_app/model/User.dart';

Future showCreateUserDialog(
        {BuildContext context,
        User user}) =>
    showDialog(
      context: context,
      child: CreateUserDialog(user),
    );

class CreateUserDialog extends StatefulWidget {

  User user;

  CreateUserDialog(user)
  {
    this.user = user;
  }

  @override
  State<StatefulWidget> createState() {
    return CreateUserState(this.user);
  }
}

class CreateUserState extends State<CreateUserDialog> {

  User user;

  CreateUserState(User user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: Key('create user dialog'),
      title: Text('Enter User details'),
      content: SingleChildScrollView(
          child: ListBody(children: [
        TextField(
          key: Key('user name input'),
          decoration: InputDecoration.collapsed(
            hintText: 'Enter user name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          keyboardType: TextInputType.multiline,
          onChanged: (input) => user.name = input,
        ),
      ])),
      actions: [
        FlatButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.pop(
                context, user);
          },
        ),
        FlatButton(
          key: Key('venue dialog finish button'),
          child: Text("Fertig"),
          onPressed: () {
            if(user.name != "")
              {
                Navigator.pop(context, user);
              }
          },
        ),
      ],
    );
  }
}
