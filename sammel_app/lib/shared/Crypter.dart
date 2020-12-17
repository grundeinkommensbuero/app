import 'dart:convert';

Map<dynamic, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64') {
    if (data['payload'] == null) return {};
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Push-Nachricht entschlüsselt: ${decodiert}');
    return decodiert;
  }
  if (data['encrypted'] == 'Plain') {
    if (data['payload'] == null) return {};
    print('Push-Nachricht unverschlüsselt: ${data['payload']}');
    return data['payload'];
  }
  print('Push-Nachricht nicht entschlüsselt: ${data}');
  return data;
}
