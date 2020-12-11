import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';

Map<dynamic, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64') {
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Push-Nachricht entschlüsselt: ${decodiert}');
    return decodiert;
  }
  if (data['encrypted'] == 'Plain') {
    print('Push-Nachricht unverschlüsselt: ${data['payload']}');
    return jsonDecode(data['payload']);
  }
  print('Push-Nachricht nicht entschlüsselt: ${data}');
  return data;
}
