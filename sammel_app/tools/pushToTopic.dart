import 'dart:convert';

import 'package:http/http.dart';

const authMap = {
  Mode.LOCAL: 'Basic MzpmZjdhOGI2Yi1lMTVhLTRmZWUtOWY3OS1kY2EwNmZkNmM4ODM=',
  Mode.TEST: 'Basic MzpmZjdhOGI2Yi1lMTVhLTRmZWUtOWY3OS1kY2EwNmZkNmM4ODM=',
  Mode.PROD: 'KEY NICHT EINCHECKEN!',
***REMOVED***

Future<void> main() async {
  var mode = Mode.PROD;
  var author = Author.APP;
  var titel = '47.342';
  var inhalt = '''Wir dürfen heute bekanntgeben: die Zahl der Unterschriften bis jetzt lautet: 47.342! Danke allen Sammler:innen. 😍
Es geht weiter bis 26.6.21. 🥳 Und dafür brauchen wir eure Unterstützung. Gemeinsam sind wir stark!''';

  assert(authMap[mode] != null, 'Authentifizierung eintragen');

  final body = {
    "data": {
      "type": "TopicChatMessage",
      "channel": "topic:global",
      "timestamp": DateTime.now().toString(),
      "text": '$titel\n\n$inhalt',
      "color": colorMap[author],
      "sender_name": nameMap[author],
      "user_id": -1
    ***REMOVED***,
    "notification": {"title": titel, "body": inhalt***REMOVED***
  ***REMOVED***

  final response = await post(
      Uri(
          scheme: protocolMap[mode],
          host: hostMap[mode],
          port: portMap[mode],
          path: '/service/push/topic/global'),
      headers: {
        "Authorization": authMap[mode]!,
        "Content-Type": "application/json",
        "Accept": "application/json"
      ***REMOVED***,
      body: jsonEncode(body));

  print(
      'Ergebnis: ${response.statusCode***REMOVED*** - ${response.body***REMOVED*** - ${response.reasonPhrase***REMOVED***');
***REMOVED***

enum Mode { LOCAL, TEST, PROD ***REMOVED***
enum Author { APP, DWE ***REMOVED***

***REMOVED***
  Mode.LOCAL: 'localhost',
***REMOVED***
  Mode.PROD: 'dwenteignen.party',
***REMOVED***

const protocolMap = {
  Mode.LOCAL: 'http',
  Mode.TEST: 'https',
  Mode.PROD: 'https',
***REMOVED***

***REMOVED***
  Mode.LOCAL: 18080,
***REMOVED***
***REMOVED***
***REMOVED***

const colorMap = {
  Author.APP: 4292668415,
  Author.DWE: 4294960680,
***REMOVED***

const nameMap = {
  Author.APP: 'App-Info',
  Author.DWE: 'Deutsche Wohnen & Co. Enteignen',
***REMOVED***