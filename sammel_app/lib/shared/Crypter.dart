import 'dart:convert';

Map<dynamic, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64') {
    if (data['payload'] == null) return {***REMOVED***
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Push-Nachricht entschlüsselt: ${decodiert***REMOVED***');
    return decodiert;
  ***REMOVED***
  if (data['encrypted'] == 'Plain') {
    if (data['payload'] == null) return {***REMOVED***
    print('Push-Nachricht unverschlüsselt: ${data['payload']***REMOVED***');
    return data['payload'];
  ***REMOVED***
  print('Push-Nachricht nicht entschlüsselt: ${data***REMOVED***');
  return data;
***REMOVED***
