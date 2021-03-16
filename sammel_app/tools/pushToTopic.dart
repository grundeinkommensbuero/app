import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  var titel = 'Neue Version 1.2';
  var inhalt = '''Soeben ist unsere neue Version 1.2 veröffentlicht worden.
Die offensichtlichste Neuerung ist, dass Aktionen auf der Übersichtskarte jetzt zusammengefasst werden, um sie übersichtlicher und auf langsameren Geräten performanter zu machen.
Aus dem selben Grund werden die Solidarischen Orte nun erst angezeigt, wenn du näher heranzoomst.
Außerdem lassen sich nun mit dem Aktionen-Filter speziell Aktionen anzeigen, an denen du teilnimmst. Der Filter-Knopf ist nun grün, wenn ein Filter aktiv ist und ein Bug wurde behoben der verhinderte, dass vergangene Aktionen gelöscht werden konnten.
Viel Spaß mit der App!''';

  final body = {
    "data": {
      "type": "TopicChatMessage",
      "channel": "topic:global",
      "timestamp": "2021-03-08 23:45:00.000000",
      "text": '$titel\n\n$inhalt',
      "color": 4292668415,
      // DWE hellblau für App-Info
      // "color": 4294960680, // DWE mittelgelb für Deutsche Wohnen & Co. Enteignen
      "sender_name": "App-Info",
      "user_id": -1
    ***REMOVED***,
    "notification": {"title": titel, "body": inhalt***REMOVED***
  ***REMOVED***

  final response = await post(
      Uri(
          scheme: 'http',
          host: 'localhost',
          port: 18080,
          path: 'service/push/topic/global'),
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
