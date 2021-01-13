import 'dart:convert';
import 'package:cryptography/cryptography.dart';

final SecretKey key =
    SecretKey(base64.decode('vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc='));

Map<dynamic, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64') {
    if (data['payload'] == null) return {***REMOVED***
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Codierte Push-Nachricht: ${decodiert***REMOVED***');
    return decodiert;
  ***REMOVED***
  if (data['encrypted'] == 'AES') {
    if (data['payload'] == null) return {***REMOVED***
    final nonce = Nonce(base64.decode(data['nonce']));
    final decrypted = aesCbc.decryptSync(base64.decode(data['payload']),
        secretKey: key, nonce: nonce);
    final decoded = jsonDecode(utf8.decode(decrypted));
    print('Verschlüsselte Push-Nachricht: ${decoded***REMOVED***');
    return decoded;
  ***REMOVED***
  if (data['encrypted'] == 'Plain') {
    if (data['payload'] == null) return {***REMOVED***
    print('Uncodierte Push-Nachricht: ${data['payload']***REMOVED***');
    try {
      print(jsonDecode(data['payload']));
    ***REMOVED***catch (e,s)
  {
    print("decoding error ${e***REMOVED***");
  ***REMOVED***

    print("success on decoding");
    print(data["payload"]);

    return data['payload'];
  ***REMOVED***
  print('Push-Nachricht nicht entschlüsselt: ${data***REMOVED***');
  return data;
***REMOVED***
