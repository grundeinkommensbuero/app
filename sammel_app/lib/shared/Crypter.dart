import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../Provisioning.dart';

final mac = MacAlgorithm.empty;
final algorithm = AesCbc.with256bits(macAlgorithm: mac);
final SecretKey key =
    SecretKey(base64.decode('vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc='));
final SecretKey pKey = SecretKey(base64.decode(prodKey));

Future<Map<String, dynamic>> decrypt(dynamic data) async {
  if (data['encrypted'] == 'Base64') {
    if (data['payload'] == null) return {***REMOVED***
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Codierte Push-Nachricht: $decodiert');
    return decodiert;
  ***REMOVED***
  if (data['encrypted'] == 'AES') {
    if (data['payload'] == null) return {***REMOVED***
    SecretBox secretBox = SecretBox(
        base64.decode(data['payload']),
        nonce: base64.decode(data['nonce']), mac: Mac.empty);
    final decrypted = await algorithm.decrypt(secretBox, secretKey: key);
    final decoded = jsonDecode(utf8.decode(decrypted));
    print('Verschlüsselte Push-Nachricht (test): $decoded');
    return decoded;
  ***REMOVED***
  if (data['encrypted'] == 'AES_PROD') {
    if (data['payload'] == null) return {***REMOVED***
    SecretBox secretBox = SecretBox(
        base64.decode(data['payload']),
        nonce: base64.decode(data['nonce']), mac: Mac.empty);
    final decrypted = await algorithm.decrypt(secretBox, secretKey: pKey);
    final decoded = jsonDecode(utf8.decode(decrypted));
    print('Verschlüsselte Push-Nachricht (prod): $decoded');
    return decoded;
  ***REMOVED***
  if (data['encrypted'] == 'Plain') {
    if (data['payload'] == null) return {***REMOVED***
    print('Uncodierte Push-Nachricht: ${data['payload']***REMOVED***');
    try {
      print(jsonDecode(data['payload']));
    ***REMOVED*** catch (e) {
      print("decoding error $e");
    ***REMOVED***

    return data['payload'];
  ***REMOVED***
  print('Push-Nachricht nicht entschlüsselt: $data');
  return data;
***REMOVED***
