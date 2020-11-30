import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/UserService.dart';

Future<bool> showUsernameDialog({BuildContext context, User user}) =>
    showDialog(
      context: context,
      child: UsernameDialog(user),
    );

class UsernameDialog extends StatefulWidget {
  final User user;

  UsernameDialog(this.user);

  @override
  State<StatefulWidget> createState() => UsernameDialogState(user.name);
}

class UsernameDialogState extends State<UsernameDialog> {
  String name;

  UsernameDialogState(this.name);

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
          onChanged: (input) => setState(() => name = input),
        ),
      ])),
      actions: [
        FlatButton(
          key: Key('username dialog cancel button'),
          child: Text("Abbrechen"),
          onPressed: () => Navigator.pop(context, false),
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
      await Provider.of<AbstractUserService>(context).updateUsername(name);
    } catch (e) {
      Navigator.pop(context, false);
    }
    Navigator.pop(context, true);
  }

  isValid() => isNotBlank(name);
}
