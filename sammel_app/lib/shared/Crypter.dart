import 'dart:convert';
import 'package:cryptography/cryptography.dart';

import '../Provisioning.dart';

final SecretKey key =
    SecretKey(base64.decode('vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc='));

final SecretKey pKey = SecretKey(base64.decode(prodKey));

Map<String, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64') {
    if (data['payload'] == null) return {};
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Codierte Push-Nachricht: $decodiert');
    return decodiert;
  }
  if (data['encrypted'] == 'AES') {
    if (data['payload'] == null) return {};
    final nonce = Nonce(base64.decode(data['nonce']));
    final decrypted = aesCbc.decryptSync(base64.decode(data['payload']),
        secretKey: key, nonce: nonce);
    final decoded = jsonDecode(utf8.decode(decrypted));
    print('Verschlüsselte Push-Nachricht (test): $decoded');
    return decoded;
  }
  if (data['encrypted'] == 'AES_PROD') {
    if (data['payload'] == null) return {};
    final nonce = Nonce(base64.decode(data['nonce']));
    final decrypted = aesCbc.decryptSync(base64.decode(data['payload']),
        secretKey: pKey, nonce: nonce);
    final decoded = jsonDecode(utf8.decode(decrypted));
    print('Verschlüsselte Push-Nachricht (prod): $decoded');
    return decoded;
  }
  if (data['encrypted'] == 'Plain') {
    if (data['payload'] == null) return {};
    print('Uncodierte Push-Nachricht: ${data['payload']}');
    try {
      print(jsonDecode(data['payload']));
    } catch (e) {
      print("decoding error $e");
    }

    return data['payload'];
  }
  print('Push-Nachricht nicht entschlüsselt: $data');
  return data;
}
