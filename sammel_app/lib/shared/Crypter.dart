import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';

Map<String, String> encrypt(PushData data) =>
    {'payload': base64Encode(utf8.encode(jsonEncode(data.toJson())))};

Map<dynamic, dynamic> decrypt(Map<String, dynamic> data) =>
    jsonDecode(utf8.decode(base64Decode(data['payload'])));
