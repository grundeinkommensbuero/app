import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  var titel = "Neue Version 1.1";
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
