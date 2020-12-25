import 'package:flutter/material.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/shared/ServerException.dart';

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

  static handleError(error, StackTrace stacktrace, {String additional***REMOVED***) {
    print('Fehler aufgetreten: $error\n$stacktrace');
    if (additional == null)
      additional = '';
    else
      additional = '$additional';

    if (error is AuthFehler) {
      pushMessage('Fehler bei Nutzer-Authentifizierung',
          '${error.message***REMOVED***$additional$EMAIL');
      return;
    ***REMOVED***
    if (error is RestFehler) {
      pushMessage(
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten',
          '${error.message***REMOVED***$additional$EMAIL');
      return;
    ***REMOVED***
    if (error is ServerException) {
      pushMessage(
          'Bei der Kommunikation mit dem Server ist ein technischer Fehler aufgetreten',
          '${error.message***REMOVED***$additional$EMAIL');
      return;
    ***REMOVED***
    pushMessage('Ein Fehler ist aufgetreten', '$additional$EMAIL');
  ***REMOVED***

  static void pushMessage(String titel, String message) {
    if (_context == null)
      messageQueue.add([titel, message]);
    else
      showErrorDialog(titel, message, key: Key('error dialog'));
  ***REMOVED***

  static Future showErrorDialog(String title, String message, {key: Key***REMOVED***) =>
      showDialog(
          context: _context,
          builder: (_) => AlertDialog(
                key: key,
                title: Text(title),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      height: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/housy_problem.png')))),
                  SizedBox(height: 10),
                  Text(message),
                ]),
                actions: <Widget>[
                  RaisedButton(
                    key: Key('error dialog close button'),
                    child: Text('Okay...'),
                    onPressed: () => Navigator.pop(_context),
                  )
                ],
              ));
***REMOVED***
