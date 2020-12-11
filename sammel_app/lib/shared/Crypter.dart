import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';

Map<dynamic, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64') {
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Push-Nachricht entschlüsselt: ${decodiert***REMOVED***');
    return decodiert;
  ***REMOVED***
  if (data['encrypted'] == 'Plain') {
    print('Push-Nachricht unverschlüsselt: ${data['payload']***REMOVED***');
    return jsonDecode(data['payload']);
  ***REMOVED***
  print('Push-Nachricht nicht entschlüsselt: ${data***REMOVED***');
  return data;
***REMOVED***
