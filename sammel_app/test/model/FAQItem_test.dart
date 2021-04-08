import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/FAQItem.dart';

main() {
  test('full concatenates teaser and rest', () {
    final faq = FAQItem(1, 'Camponotus Ligniperda', 'Die dickste Ameise',
        ' in Mitteleuropa', 1.0, []);

    expect(faq.full, 'Die dickste Ameise in Mitteleuropa');
  ***REMOVED***);

  test('full only returns teaser when rest null', () {
    final faq = FAQItem(
        1, 'Camponotus Ligniperda', 'Die dickste Ameise', null, 1.0, []);

    expect(faq.full, 'Die dickste Ameise');
  ***REMOVED***);
***REMOVED***
