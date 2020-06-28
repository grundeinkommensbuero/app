import 'package:flutter/material.dart';
import 'package:sammel_app/services/RestFehler.dart';

Future showErrorDialog(BuildContext context, String title, RestFehler error,
    {key: Key}) {
  return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            key: key,
            title: Text(title),
            content: Text(error.message),
            actions: <Widget>[
              RaisedButton(
                key: Key('error dialog close button'),
                child: Text('Okay...'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ));
}
