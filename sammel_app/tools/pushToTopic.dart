import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  final body = {
    "data": {
      "type": "TopicChatMessage",
      "channel": "topic:global",
      "timestamp": "2020-01-22 02:25:00.000000",
      "text": "Hallo liebe Tester*innen! Es gibt eine neue Version mit der Nummer 0.5.3.\nDies sind die neuen Bugfixes:\n- (manche) Chat-Benachrichtigungen nennen zugehörige Aktion\n- nur noch eine Benachrichtigungen pro Chat gleichzeitig\n- nur noch 100 Aktionen gleichzeitig anzeigen\n- neuer Hinweis-Dialog zu Benachrichtigungseinstellungen auf Profil-Seite\n- besser aufgelöste Logos\n- Fix bei Kiez-Auswahl auf mittlerer Zoomstufe\n- vergrößerndes Eingebefeld des Chats\n- GUI-Fehlerbehebung im Feedback-Formular",
      "color": 4292668415, // DWE hellblau für App-Info
      // "color": 4294960680, // DWE mittelgelb für Deutsche Wohnen & Co. Enteignen
      "sender_name": "App-Info",
      "user_id": -1
    },
    "notification": {"title": "Wieder eine neue Version! (0.5.3)", "body": "> Tipp mich an um die News-Seite zu zeigen! <."}
  };

  final response = await post(
      'https://dwe.idash.org/service/push/topic/global',
      headers: {
        "Authorization":
            "Basic MzpmZjdhOGI2Yi1lMTVhLTRmZWUtOWY3OS1kY2EwNmZkNmM4ODM=",
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(body));

  print(
      'Ergebnis: ${response.statusCode} - ${response.body} - ${response.reasonPhrase}');
}
