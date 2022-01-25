import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/Crypter.dart';

void main() {
  final plaintext = 'Hello World';

  test('decrypt converts base64 message', () async {
    var decrypted = await decrypt({
      'encrypted': 'Base64',
      'payload': 'eyJjb250ZW50IjoiSGVsbG8gV29ybGQifQ=='
    });
    expect(decrypted['content'], plaintext);
  });

  test('decrypt converts base64 null message', () async {
    var decrypted = await decrypt({'encrypted': 'Base64', 'payload': null});
    expect(decrypted.isEmpty, true);
  });

  test('decrypt returns uncoded message', () async {
    var decrypted = await decrypt({
      'encrypted': 'Plain',
      'payload': {'content': 'Hello World'}
    });
    expect(decrypted['content'], 'Hello World');
  });

  test('decrypt returns message without coding type', () async {
    var decrypted = await decrypt({'content': 'Hello World'});
    expect(decrypted['content'], 'Hello World');
  });

  test('decrypt decrypts aes message', () async {
    var decrypted = await decrypt({
      'encrypted': 'AES',
      'payload': 'v88JF1h2K1BvYCAqsUZGs51T1cE1OmowBJ0m0ioNuMM=',
      'nonce': 'f8U6qg+JFSFINyrBE/jhqQ=='
    });
    expect(decrypted['content'], plaintext);
  });

  test('decrypt decrypts aes null message', () async {
    var decrypted = await decrypt({
      'encrypted': 'AES',
      'payload': null,
      'nonce': 'bfgpdq3XdvnYI4cowQrjOQ=='
    });
    expect(decrypted.isEmpty, true);
  });

  test('create a secret key and nonce', () async {
    var algorithm = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    List<int> bytes = await (await algorithm.newSecretKey()).extractBytes();
    print(base64.encode(bytes));
    print(base64Encode(
        AesCbc.with256bits(macAlgorithm: Hmac.sha256()).newNonce()));
    print(base64.decode('jpp/xDmqUhxF3X+lv0hre/AMwryUxZtpscdKS2+ofsc=').length);
  });

  test('create cypher text', () async {
    final algorithm = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    final SecretKey key = SecretKey(
        base64.decode('vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc='));
    final plaintext = utf8.encode('{"content": "Hello World"}');
    var cypher = await algorithm.encrypt(plaintext,
        secretKey: key, nonce: base64.decode('bfgpdq3XdvnYI4cowQrjOQ=='));
    print(base64.encode(cypher.cipherText));
    print(base64.encode(cypher.nonce));
  });
}
