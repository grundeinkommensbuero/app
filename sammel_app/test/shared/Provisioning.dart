import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/Provisioning.dart';

main() {
  test('only Demo Mode should be committed', () => expect(mode, Mode.DEMO));

  test('no productive secret should be committed',
      () => expect(prodKey, 'Produktiv-Verschüsselungs-Key goes here'));

  test('no active clear button should be committed',
      () => expect(clearButton, false));
}
