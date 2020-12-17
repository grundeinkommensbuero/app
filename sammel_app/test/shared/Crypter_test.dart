import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/Crypter.dart';

void main() {
  final plaintext = 'Hello World';

  test('decrypt decrypts encrypted message', () {
    var decrypted = decrypt({
      'encrypted': 'Base64',
      'payload': 'eyJjb250ZW50IjoiSGVsbG8gV29ybGQifQ=='
    });
    expect(decrypted['content'], plaintext);
  });

  test('decrypt decrypts null message', () {
    var decrypted = decrypt({'encrypted': 'Base64', 'payload': null});
    expect(decrypted.isEmpty, true);
  });

  test('decrypt returns unecrypted message', () {
    var decrypted = decrypt({
      'encrypted': 'Plain',
      'payload': {'content': 'Hello World'}
    });
    expect(decrypted['content'], 'Hello World');
  });

  test('decrypt returns message without encryption type', () {
    var decrypted = decrypt({'content': 'Hello World'});
    expect(decrypted['content'], 'Hello World');
  });
}
