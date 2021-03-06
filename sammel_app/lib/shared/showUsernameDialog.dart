import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/UserService.dart';

Future<String?> showUsernameDialog(
        {required BuildContext context, bool hideHint = false}) =>
    showDialog(
      context: context,
      builder: (context) => UsernameDialog(hideHint),
    );

class UsernameDialog extends StatefulWidget {
  final bool hideHint;

  UsernameDialog(this.hideHint) : super(key: Key('username dialog'));

  @override
  State<StatefulWidget> createState() => UsernameDialogState();
}

class UsernameDialogState extends State<UsernameDialog> {
  String? username;

  UsernameDialogState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: Key('create user dialog'),
      title: Text('Benutzer*in-Name').tr(),
      content: SingleChildScrollView(
          child: Column(children: [
        (widget.hideHint
            ? SizedBox()
            : Text('Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben',
                    key: Key('username dialog hint'))
                .tr()),
        TextField(
          key: Key('user name input'),
          autofocus: true,
          maxLength: 40,
          onChanged: (input) => setState(() => username = input),
        ),
      ])),
      actions: [
        TextButton(
          key: Key('username dialog cancel button'),
          child: Text("Abbrechen").tr(),
          onPressed: () => Navigator.pop(context, null),
        ),
        TextButton(
          key: Key('username dialog finish button'),
          child: Text("Fertig").tr(),
          onPressed: isValid() ? () => changeUserNameAndClose() : null,
        ),
      ],
    );
  }

  changeUserNameAndClose() async {
    try {
      await Provider.of<AbstractUserService>(context, listen: false)
          .updateUsername(username!);
      Navigator.pop(context, username);
    } catch (e) {
      ErrorService.handleError(e, StackTrace.current);
      Navigator.pop(context, null);
    }
  }

  isValid() => isNotBlank(username);
}
