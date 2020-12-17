import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/Crypter.dart';

void main() {
  final plaintext = 'Hello World';

  test('decrypt decrypts encrypted message', () {
    var decrypted = decrypt({
      'encrypted': 'Base64',
      'payload': 'eyJjb250ZW50IjoiSGVsbG8gV29ybGQifQ=='
    ***REMOVED***);
    expect(decrypted['content'], plaintext);
  ***REMOVED***);

  test('decrypt decrypts null message', () {
    var decrypted = decrypt({'encrypted': 'Base64', 'payload': null***REMOVED***);
    expect(decrypted.isEmpty, true);
  ***REMOVED***);

  test('decrypt returns unecrypted message', () {
    var decrypted = decrypt({
      'encrypted': 'Plain',
      'payload': {'content': 'Hello World'***REMOVED***
    ***REMOVED***);
    expect(decrypted['content'], 'Hello World');
  ***REMOVED***);

  test('decrypt returns message without encryption type', () {
    var decrypted = decrypt({'content': 'Hello World'***REMOVED***);
    expect(decrypted['content'], 'Hello World');
  ***REMOVED***);
***REMOVED***
