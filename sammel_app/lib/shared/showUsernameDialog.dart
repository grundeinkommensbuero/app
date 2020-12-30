import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/services/UserService.dart';

Future<String> showUsernameDialog(
        {BuildContext context, bool hideHint = false***REMOVED***) =>
    showDialog(
      context: context,
      child: UsernameDialog(hideHint),
    );

class UsernameDialog extends StatefulWidget {
  bool hideHint;

  UsernameDialog(this.hideHint) : super(key: Key('username dialog'));

  @override
  State<StatefulWidget> createState() => UsernameDialogState();
***REMOVED***

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
        (widget.hideHint
            ? SizedBox()
            : Text(
                'Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben',
                key: Key('username dialog hint'))),
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
  ***REMOVED***

  Future<void> changeUserNameAndClose() async {
    try {
      await Provider.of<AbstractUserService>(context).updateUsername(username);
      Navigator.pop(context, username);
    ***REMOVED*** catch (e) {
      Navigator.pop(context, null);
    ***REMOVED***
  ***REMOVED***

  isValid() => isNotBlank(username);
***REMOVED***
