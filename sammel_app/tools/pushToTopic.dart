import 'dart:convert';

import 'package:http/http.dart';

const authMap = {
  Mode.LOCAL: 'Basic MzpmZjdhOGI2Yi1lMTVhLTRmZWUtOWY3OS1kY2EwNmZkNmM4ODM=',
  Mode.TEST: 'Basic MzpmZjdhOGI2Yi1lMTVhLTRmZWUtOWY3OS1kY2EwNmZkNmM4ODM=',
  Mode.PROD: 'KEY NICHT EINCHECKEN!',
};

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
    },
    "notification": {"title": titel, "body": inhalt}
  };

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
      },
      body: jsonEncode(body));

  print(
      'Ergebnis: ${response.statusCode} - ${response.body} - ${response.reasonPhrase}');
}

enum Mode { LOCAL, TEST, PROD }
enum Author { APP, DWE }

const hostMap = {
  Mode.LOCAL: 'localhost',
  Mode.TEST: 'dwe.idash.org',
  Mode.PROD: 'dwenteignen.party',
};

const protocolMap = {
  Mode.LOCAL: 'http',
  Mode.TEST: 'https',
  Mode.PROD: 'https',
};

const portMap = {
  Mode.LOCAL: 18080,
  Mode.TEST: 443,
  Mode.PROD: 443,
};

const colorMap = {
  Author.APP: 4292668415,
  Author.DWE: 4294960680,
};

const nameMap = {
  Author.APP: 'App-Info',
  Author.DWE: 'Deutsche Wohnen & Co. Enteignen',
};