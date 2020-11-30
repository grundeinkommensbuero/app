import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/services/UserService.dart';

Future<String> showUsernameDialog({BuildContext context}) => showDialog(
      context: context,
      child: UsernameDialog(),
    );

class UsernameDialog extends StatefulWidget {
  UsernameDialog() : super(key: Key('username dialog'));

  @override
  State<StatefulWidget> createState() => UsernameDialogState();
}

class UsernameDialogState extends State<UsernameDialog> {
  String username;

  UsernameDialogState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: Key('create user dialog'),
      title: Text('Benutzer*in-Name'),
      content: SingleChildScrollView(
          child: Column(children: [
        Text(
            'Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben'),
        TextField(
          key: Key('user name input'),
          autofocus: true,
          maxLength: 40,
          onChanged: (input) => setState(() => username = input),
        ),
      ])),
      actions: [
        FlatButton(
          key: Key('username dialog cancel button'),
          child: Text("Abbrechen"),
          onPressed: () => Navigator.pop(context, null),
        ),
        FlatButton(
          key: Key('username dialog finish button'),
          child: Text("Fertig"),
          onPressed: isValid() ? () => changeUserNameAndClose() : null,
        ),
      ],
    );
  }

  Future<void> changeUserNameAndClose() async {
    try {
      await Provider.of<AbstractUserService>(context).updateUsername(username);
      Navigator.pop(context, username);
    } catch (e) {
      Navigator.pop(context, null);
    }
  }

  isValid() => isNotBlank(username);
}
