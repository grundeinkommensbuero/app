import 'dart:convert';
import 'package:cryptography/cryptography.dart';

final SecretKey key =
    SecretKey(base64.decode('vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc='));

Map<String, dynamic> decrypt(dynamic data) {
  if (data['encrypted'] == 'Base64') {
    if (data['payload'] == null) return {};
    var decodiert = jsonDecode(utf8.decode(base64Decode(data['payload'])));
    print('Codierte Push-Nachricht: ${decodiert}');
    return decodiert;
  }
  if (data['encrypted'] == 'AES') {
    if (data['payload'] == null) return {};
    final nonce = Nonce(base64.decode(data['nonce']));
    final decrypted = aesCbc.decryptSync(base64.decode(data['payload']),
        secretKey: key, nonce: nonce);
    final decoded = jsonDecode(utf8.decode(decrypted));
    print('Verschlüsselte Push-Nachricht: ${decoded}');
    return decoded;
  }
  if (data['encrypted'] == 'Plain') {
    if (data['payload'] == null) return {};
    print('Uncodierte Push-Nachricht: ${data['payload']}');
    return data['payload'];
  }
  print('Push-Nachricht nicht entschlüsselt: ${data}');
  return data;
}
