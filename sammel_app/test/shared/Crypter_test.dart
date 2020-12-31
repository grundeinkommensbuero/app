import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/Crypter.dart';

void main() {
  final plaintext = 'Hello World';

  test('decrypt converts base64 message', () {
    var decrypted = decrypt({
      'encrypted': 'Base64',
      'payload': 'eyJjb250ZW50IjoiSGVsbG8gV29ybGQifQ=='
    ***REMOVED***);
    expect(decrypted['content'], plaintext);
  ***REMOVED***);

  test('decrypt converts base64 null message', () {
    var decrypted = decrypt({'encrypted': 'Base64', 'payload': null***REMOVED***);
    expect(decrypted.isEmpty, true);
  ***REMOVED***);

  test('decrypt returns uncoded message', () {
    var decrypted = decrypt({
      'encrypted': 'Plain',
      'payload': {'content': 'Hello World'***REMOVED***
    ***REMOVED***);
    expect(decrypted['content'], 'Hello World');
  ***REMOVED***);

  test('decrypt returns message without coding type', () {
    var decrypted = decrypt({'content': 'Hello World'***REMOVED***);
    expect(decrypted['content'], 'Hello World');
  ***REMOVED***);

  test('decrypt decrypts aes message', () {
    var decrypted = decrypt({
      'encrypted': 'AES',
      'payload': 'v88JF1h2K1BvYCAqsUZGs51T1cE1OmowBJ0m0ioNuMM=',
      'nonce': 'f8U6qg+JFSFINyrBE/jhqQ=='
    ***REMOVED***);
    expect(decrypted['content'], plaintext);
  ***REMOVED***);

  test('decrypt decrypts aes null message', () {
    var decrypted = decrypt({
      'encrypted': 'AES',
      'payload': null,
      'nonce': 'bfgpdq3XdvnYI4cowQrjOQ=='
    ***REMOVED***);
    expect(decrypted.isEmpty, true);
  ***REMOVED***);

  test('create a secret key and nonce', () {
    List<int> bytes = aesCbc.newSecretKeySync().extractSync();
    print(base64.encode(bytes));
    print(base64Encode(aesCbc.newNonce().bytes));
    print(base64.decode('jpp/xDmqUhxF3X+lv0hre/AMwryUxZtpscdKS2+ofsc=').length);
  ***REMOVED***);

  test('create cypher text', () async {
    final cipher = CipherWithAppendedMac(aesCbc, Hmac(sha256));
    final SecretKey key = SecretKey(
        base64.decode('vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc='));
    final plaintext = utf8.encode('{"content": "Hello World"***REMOVED***');
    final nonce = Nonce(base64.decode('bfgpdq3XdvnYI4cowQrjOQ=='));
    var cypher = await cipher.encrypt(plaintext, secretKey: key, nonce: nonce);
    print(base64.encode(cypher));
  ***REMOVED***);
***REMOVED***
