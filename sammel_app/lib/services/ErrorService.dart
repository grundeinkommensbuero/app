import 'package:flutter/material.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/RestFehler.dart';

class ErrorService {
  static BuildContext _context;
  static List<List<String>> messageQueue = List<List<String>>();

  static const EMAIL =
      '\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an e@mail.com';

  static void setContext(context) {
    ErrorService._context = context;
    List<List<String>> queueCopy = List<List<String>>.from(messageQueue);
    messageQueue.clear();
    queueCopy.forEach((error) =>
        showErrorDialog(error[0], error[1], key: Key('error dialog')));
  ***REMOVED***

  static handleError(e, {String additional***REMOVED***) {
    if (additional == null)
      additional = '';
    else
      additional = '. $additional';

    if (e is AuthFehler) {
      pushMessage(
          'Fehler bei Nutzer-Authentifizierung',
          '${e.message***REMOVED***${additional***REMOVED***$EMAIL');
      return;
    ***REMOVED***
    if (e is RestFehler) {
      pushMessage(
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten',
          '${e.message***REMOVED***${additional***REMOVED***$EMAIL');
      return;
    ***REMOVED***
    if (e is WrongResponseFormatException) {
      pushMessage(
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten',
          '${e.message***REMOVED***${additional***REMOVED***$EMAIL');
      return;
    ***REMOVED***
    pushMessage('Ein Fehler ist aufgetreten', '$additional$EMAIL');
  ***REMOVED***

  static void pushMessage(String titel, String message) {
    if (_context == null)
      messageQueue.add([titel, message]);
    else {
      print('Ein Fehler ist aufgetreten: $titel - $message');
      showErrorDialog(titel, message, key: Key('error dialog'));
    ***REMOVED***
  ***REMOVED***

  static Future showErrorDialog(String title, String message, {key: Key***REMOVED***) =>
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
***REMOVED***
