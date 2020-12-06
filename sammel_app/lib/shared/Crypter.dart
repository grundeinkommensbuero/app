import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';

Map<String, String> encrypt(PushData data) => {
      'encrypted': 'Base64',
      'payload': base64Encode(utf8.encode(jsonEncode(data.toJson())))
    ***REMOVED***

Map<dynamic, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64')
    return jsonDecode(utf8.decode(base64Decode(data['payload'])));
  if (data['encrypted'] == 'Plain')
    return jsonDecode(data['payload']);
  return data;
***REMOVED***
