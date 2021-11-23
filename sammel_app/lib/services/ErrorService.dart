import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/services/AuthFehler.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DeserialisationException.dart';
import 'package:sammel_app/shared/MessageException.dart';
import 'package:sammel_app/shared/ServerException.dart';

import 'AccessException.dart';
import 'GeoService.dart';

class ErrorService {
  static BuildContext? _context;
  static List<List<String>> errorQueue = [];
  static List<String> displayedTypes = [];

  static const EMAIL =
      '\n\nWenn du Hilfe brauchst, schreib uns doch einfach per Mail an support@expedition-grundeinkommen.de';

  static void setContext(context) {
    ErrorService._context = context;
    List<List<String>> queueCopy = List<List<String>>.from(errorQueue);
    errorQueue.clear();
    queueCopy.forEach((error) =>
        showErrorDialog(error[0], error[1], key: Key('error dialog')));
  ***REMOVED***

  static handleError(error, StackTrace stacktrace, {String? context***REMOVED***) async {
    print('Fehler aufgetreten: $error\n$stacktrace');

    if (context != null) context = context.tr();

    var errorMessage = '';
    try {
      errorMessage = tr(error.message);
    ***REMOVED*** catch (_) {***REMOVED***
    if (error is NoUserAuthException) {
      pushError('Dein Account konnte nicht authentifziert werden.',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***

    if (error is InvalidUserException) {
      pushError('Dein Account konnte nicht authentifziert werden.',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***

    if (error is AuthFehler) {
      pushError('Fehler bei Nutzer-Authentifizierung',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    if (error is AccessException) {
      pushError('Zugriff fehlgeschlagen',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    if (error is RestFehler) {
      pushError(
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    if (error is DeserialisationException) {
      pushError(
          'Bei der Kommunikation mit dem Server ist ein Fehler aufgetreten',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    if (error is OsmResponseException) {
      pushError(
          'Bei der Kommunikation mit einem Openstreetmap-Server ist ein Fehler aufgetreten',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    if (error is ServerException) {
      pushError(
          'Bei der Kommunikation mit dem Server ist ein technischer Fehler aufgetreten',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    if (error is ConnectivityException) {
      pushError('Ein Verbindungs-Problem ist aufgetreten',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    if (error is WarningException) {
      pushError('Warnung',
          [context, errorMessage, EMAIL].where((e) => e != null).join(' '));
      return;
    ***REMOVED***
    pushError('Ein Fehler ist aufgetreten',
        [context, EMAIL].where((e) => e != null).join(' '));
  ***REMOVED***

  static void pushError(String titel, String message) {
    if (_context == null)
      errorQueue.add([titel, message]);
    else
      showErrorDialog(titel, message, key: Key('error dialog'));
  ***REMOVED***

  static Future showErrorDialog(String title, String message,
      {key: Key***REMOVED***) async {
    if (displayedTypes.contains(title)) return;
    displayedTypes.add(title);
    showDialog(
        context: _context!,
        builder: (_) => AlertDialog(
              key: key,
              title: Text(title).tr(),
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
                ElevatedButton(
                  key: Key('error dialog close button'),
                  child: Text('Okay...'),
                  onPressed: () => Navigator.pop(_context!),
                )
              ],
            )).whenComplete(() => displayedTypes.remove(title));
  ***REMOVED***
***REMOVED***
