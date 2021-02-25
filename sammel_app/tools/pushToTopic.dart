import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  var titel = 'Neue Version 1.1';
  var inhalt = '''Liebe Sammler*innen. Kurz vor dem offiziellen Sammel-Start gibt es noch einmal die neue App-Version 1.1
Die Version beinhaltet kleinere Fehlerbehebungen und wichtige Features, die es nicht mehr in die Release-Version geschafft hatten.
  
Achtung: Die alte Version 1.0 wird nun nicht mehr richtig funktionieren, darum aktualisiert die App unbedingt über euren App-Store!
  
Neuerungen in der Version 1.1:
  
Neue Sprachen:
• russisch
• französisch

Neue Features:
• Bedienungsanleitung in Fragen&Antworten-Seite
• Erinnerung für ausstehendes Feedback
• Aktionsliste scrollt automatisch zu anstehenden Aktionen
• Neue Aktionsarten: Plakatieren, Kundgebung
• Neue Artikel auf Fragen&Antworten-Seite
• App merkt sich Selbstbeschreibung
• Hinweis bei vergangenen Aktionen

Fehlerbehebungen:
• Fehler behoben durch den die App Chat-Nachrichten wieder 'vergessen' hat
• Termin-Darum nun veränderbar
• sinnvolle Dauer-Angabe bei Aktionen unter einer Stunde

Viel Spaß und Erfolg! Fehler und Anregungen könnt ihr weiterhin gerne an app@dwenteignen.de melden

Das App-Team :)''';

  final body = {
    "data": {
      "type": "TopicChatMessage",
      "channel": "topic:global",
      "timestamp": "2021-02-20 23:00:00.000000",
      "text": '$titel\n\n$inhalt',
      "color": 4292668415, // DWE hellblau für App-Info
      // "color": 4294960680, // DWE mittelgelb für Deutsche Wohnen & Co. Enteignen
      "sender_name": "App-Info",
      "user_id": -1
    ***REMOVED***,
    "notification": {"title": titel, "body": inhalt***REMOVED***
  ***REMOVED***

  final response = await post(
      'http://localhost:18080/service/push/topic/global',
      headers: {
        "Authorization":
            "Basic MzpmZjdhOGI2Yi1lMTVhLTRmZWUtOWY3OS1kY2EwNmZkNmM4ODM=",
        "Content-Type": "application/json",
        "Accept": "application/json"
      ***REMOVED***,
      body: jsonEncode(body));

  print(
      'Ergebnis: ${response.statusCode***REMOVED*** - ${response.body***REMOVED*** - ${response.reasonPhrase***REMOVED***');
***REMOVED***
