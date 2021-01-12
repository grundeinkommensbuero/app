import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  final body = {
    "data": {
      "type": "SimpleChatMessage",
      "channel": "global",
      "timestamp": "2020-01-12 03:32:00.000000",
      "timestamp": "2020-01-12 03:32:00.000000",
      "text": "text goes here",
      "color": "2137636880",
      "sender_name": "Deutsche Wohnen & Co. Enteignen",
      "user_id": -1
    },
    "notification": {"title": "Titel", "body": "Meldung"}
  };

  final response = await post(
      'http://127.0.0.1:18080/service/push/topic/global',
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
