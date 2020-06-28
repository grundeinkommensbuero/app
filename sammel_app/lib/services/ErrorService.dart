import 'package:flutter/material.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/RestFehler.dart';

class ErrorService {
  static BuildContext _context;
  static List<List<String>> messageQueue = List<List<String>>();

  static void setContext(context) {
    ErrorService._context = context;
    messageQueue.forEach((message) {
      messageQueue.remove(message);
      showErrorDialog(message[0], message[1]);
    });
  }

  static handleError(e) {
    if (e is AuthFehler) {
      pushMessage(
          'Der hinterlegte Benutzer konnte nicht authentifiziert werden',
          e.message);
    }
    if (e is RestFehler) {
      pushMessage(
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten',
          e.message);
    }
  }

  static void pushMessage(String titel, String message) {
    if (_context == null)
      messageQueue.add([titel, message]);
    else {
      print('Ein Fehler ist aufgetreten: $titel - $message');
      showErrorDialog(titel, message);
    }
  }

  static Future showErrorDialog(String title, String message, {key: Key}) =>
      showDialog(
          context: _context,
          builder: (_) => AlertDialog(
                key: key,
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  RaisedButton(
                    key: Key('error dialog close button'),
                    child: Text('Okay...'),
                    onPressed: () => Navigator.pop(_context),
                  )
                ],
              ));
}
