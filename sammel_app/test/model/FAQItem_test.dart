import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/FAQItem.dart';

main() {
  test('full concatenates teaser and rest', () {
    final faq = FAQItem(1, 'Camponotus Ligniperda', 'Die dickste Ameise',
        ' in Mitteleuropa', 1.0, []);

    expect(faq.full, 'Die dickste Ameise in Mitteleuropa');
  });

  test('full only returns teaser when rest null', () {
    final faq = FAQItem(
        1, 'Camponotus Ligniperda', 'Die dickste Ameise', null, 1.0, []);

    expect(faq.full, 'Die dickste Ameise');
  });

  test('deserializes correctly', () {
    var faqItem = FAQItem.fromJson(jsonDecode('{'
        '"id": 1,'
        '"title":"Camponotus Ligniperdus",'
        '"teaser": "Die dickste Ameise",'
        '"rest": " in Mitteleuropa",'
        '"order": 1.0,'
        '"tags": ["Holz", "Ameise", "rot", "schwarz"]'
        '}'));

    expect(faqItem.id, 1);
    expect(faqItem.title, "Camponotus Ligniperdus");
    expect(faqItem.teaser, "Die dickste Ameise");
    expect(faqItem.rest, " in Mitteleuropa");
    expect(faqItem.order, 1.0);
    expect(faqItem.tags, ["Holz", "Ameise", "rot", "schwarz"]);
  });

  test('deserializes correctly with null', () {
    var faqItem = FAQItem.fromJson(jsonDecode('{'
        '"id": 1,'
        '"title":"Camponotus Ligniperdus",'
        '"teaser": "Die dickste Ameise",'
        '"order": 1.0,'
        '"tags": ["Holz", "Ameise", "rot", "schwarz"]'
        '}'));

    expect(faqItem.id, 1);
    expect(faqItem.title, "Camponotus Ligniperdus");
    expect(faqItem.teaser, "Die dickste Ameise");
    expect(faqItem.rest, null);
    expect(faqItem.order, 1.0);
    expect(faqItem.tags, ["Holz", "Ameise", "rot", "schwarz"]);
  });

  test('serializes correctly', () {
    final json = FAQItem(1, "Camponotus Ligniperdus", "Die dickste Ameise",
        " in Mitteleuropa", 1.0, ['Holz', 'Ameise', 'rot', 'schwarz']).toJson();

    expect(
        jsonEncode(json),
        '{'
        '"id":1,'
        '"title":"Camponotus Ligniperdus",'
        '"teaser":"Die dickste Ameise",'
        '"rest":" in Mitteleuropa",'
        '"order":1.0,'
        '"tags":["Holz","Ameise","rot","schwarz"]'
        '}');
  });

  test('serializes correctly with null', () {
    final json = FAQItem(1, "Camponotus Ligniperdus", "Die dickste Ameise",
        null, 1.0, ['Holz', 'Ameise', 'rot', 'schwarz']).toJson();

    expect(
        jsonEncode(json),
        '{'
        '"id":1,'
        '"title":"Camponotus Ligniperdus",'
        '"teaser":"Die dickste Ameise",'
        '"rest":null,'
        '"order":1.0,'
        '"tags":["Holz","Ameise","rot","schwarz"]'
        '}');
  });
}
