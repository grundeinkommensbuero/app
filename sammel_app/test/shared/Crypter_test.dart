import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/Crypter.dart';

void main() {
  final plaintext = 'Hello World';

  test('decrypt converts base64 message', () {
    var decrypted = decrypt({
      'encrypted': 'Base64',
      'payload': 'eyJjb250ZW50IjoiSGVsbG8gV29ybGQifQ=='
    });
    expect(decrypted['content'], plaintext);
  });

  test('decrypt converts base64 null message', () {
    var decrypted = decrypt({'encrypted': 'Base64', 'payload': null});
    expect(decrypted.isEmpty, true);
  });

  test('decrypt returns uncoded message', () {
    var decrypted = decrypt({
      'encrypted': 'Plain',
      'payload': {'content': 'Hello World'}
    });
    expect(decrypted['content'], 'Hello World');
  });

  test('decrypt returns message without coding type', () {
    var decrypted = decrypt({'content': 'Hello World'});
    expect(decrypted['content'], 'Hello World');
  });

  test('decrypt decrypts aes message', () {
    var decrypted = decrypt({
      'encrypted': 'AES',
      'payload':
          'ZagL61xqlbsQngSOPk+kwk+r+xtY4w45rznrQvJX4/yOrqMtFdZeb7Pz6jG15YrVw1Sagn8zb1/7xMvYvg/BXw==',
      'nonce': 'bfgpdq3XdvnYI4cowQrjOQ=='
    });
    expect(decrypted['content'], plaintext);
  });

  test('decrypt decrypts aes null message', () {
    var decrypted = decrypt({
      'encrypted': 'AES',
      'payload': null,
      'nonce': 'bfgpdq3XdvnYI4cowQrjOQ=='
    });
    expect(decrypted.isEmpty, true);
  });

  test('create a secret key and nonce', () {
    final cipher = CipherWithAppendedMac(aesCbc, Hmac(sha256));
    List<int> bytes = cipher.newSecretKeySync().extractSync();
    print(base64.encode(bytes));
    print(base64Encode(cipher.newNonce().bytes));
  });

  test('create cypher text', () async {
    final cipher = CipherWithAppendedMac(aesCbc, Hmac(sha256));
    final SecretKey key = SecretKey(
        base64.decode('vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc='));
    final plaintext = utf8.encode('{"content": "Hello World"}');
    final nonce = Nonce(base64.decode('bfgpdq3XdvnYI4cowQrjOQ=='));
    var cypher = await cipher.encrypt(plaintext, secretKey: key, nonce: nonce);
    print(base64.encode(cypher));
  });
}
