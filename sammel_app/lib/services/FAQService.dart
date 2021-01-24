import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQService {
  static List<FAQItem> items = [
    FAQItem(
        1,
        'Wann geht\'s los?',
        Text('Am 26. Februar ist Sammelbeginn.'),
        Text('Am 26. Februar ist Sammelbeginn.'),
        'Am 26. Februar ist Sammelbeginn.',
        ['Start', 'Beginn', 'Sammelphase']),
    FAQItem.text(
        2,
        'Wie lange wird gesammelt?',
        'Die Sammelphase geht vom 26. Februar bis 25. Juni 2021, also vier Monate. Dieser Zeitraum ist nicht verlängerbar.',
        ['Ende', 'Abschluss', 'Sammelphase']),
    FAQItem.text(
        3,
        'Kann ich auch nach dem 25. Juni 2021 noch unterschreiben oder gesammelte Unterschriftenlisten abgeben?',
        'Nein, das ist leider nicht möglich.',
        ['Ende', 'Abschluss', 'Sammelphase', 'Ergebnis']),
    FAQItem.text(
        4,
        'Wieviel gültige Unterschriften sind überhaupt nötig?',
        'Es sind ca. 175.000 gültige Unterschriften nötig (laut Gesetz 7% der wahlberechtigten Bevölkerung Berlins). Das bedeutet, dass wir bei schätzungsweise 20% ungültigen insgesamt ca. 240.000 Unterschriften sammeln müssen.',
        [
          'Anzahl',
          'Gesamtzahl',
          'insgesamt',
          'Sammelphase',
          'Unterschriften',
          'Quorum',
          'Erfolg'
        ]),
    FAQItem.text(
        5,
        'Wessen Unterschrift ist gültig?',
        'Wahlberechtigt sind alle Berliner*innen mit deutschem Pass, die mindestens drei Monate in Berlin gemeldet sind und mindestens 18 sind. Ein großer Teil der Berliner*innen wird also nicht gezählt. Das ist ein politischer Skandal, für uns aber nicht änderbar. Deshalb sammeln wir auch sogenannte „politische“ Unterschriften, also auch Unterschriften von Berliner*innen, die nicht gezählt werden können, um den Rückhalt aller Berliner*innen zu zeigen.',
        [
          'Wer',
          'Gültigkeit',
          'Unterschriften',
          'Staatsangehörigkeit',
          'berechtigt',
          'Berechtigung',
        ]),
    FAQItem.text(
        6,
        'Wohin mit meinen gesammelten Unterschriftenlisten?',
        'Die Unterschriftenlisten können im Büro des Mietenvolksentscheid e.V.,  Warschauer Str. 23,  10243 Berlin (Montag-Freitag 10-19 Uhr) oder bei euren lokalen Kiezteams abgegeben werden.',
        ['Unterschriften', 'abgeben', 'Listen']),
    FAQItem.short(
        7,
        'Wie kann ich mich mehr in einem Kiezteam oder der Initiative einbringen?',
        Column(children: [
          Text('Mehr Infos übers Mitmachen findest du unter: '),
          RichText(
              text: TextSpan(
                  text: 'dwenteignen.de/mitmachen',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.indigo,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        () => launch('https://www.dwenteignen.de/mitmachen')))
        ]),
        'Mehr Infos findest du unter: dwenteignen.de/mitmachen',
        ['wer', 'gültig', 'Unterschrift']),
    FAQItem.short(
        8,
        'Wo gibt es Sammelmaterial?',
        Column(children: [
          Text(
              'Material kannst du im Kampagnenbüro in der Graefestr. 14 und bei einigen solidarischen Orten [link zur karte] abholen. Unterschriftenlisten als .pdf zum selber ausdrucken findest du auf'),
          RichText(
              text: TextSpan(
                  text: 'dwenteignen.de',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.indigo,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launch('https://www.dwenteignen.de')))
        ]),
        'Material kannst du im Kampagnenbüro in der Graefestr. 14 und bei einigen solidarischen Orten [link zur karte] abholen. Unterschriftenlisten als .pdf zum selber ausdrucken findest du auf',
        ['Flyer', 'Material', 'Plakat', 'Broschüre', 'Zeitung']),
    FAQItem.short(
        9,
        'Gibt es eine Übersicht der solidarischen Orte?',
        Row(children: [
          Text('Ja unter: '),
          RichText(
              text: TextSpan(
                  text: 'dwenteignen.de/mitmachen',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.indigo,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        () => launch('https://www.dwenteignen.de/mitmachen')))
        ]),
        'Wie viel Entschädigung muss den Wohnungskonzernen deren Wohnungen vergesellschaftet werden gezahlt werden? Diese Frage treibt viele um. Bereits in unserem Kurzgutachten haben wir festegstellt: Das ist eine politische Entscheidung! Sogar eine nominelle Entschädigung ist möglich.\n\n'
            'Wir haben verschiedene Modelle durchgerechnet. Von der nominellen Entschädigung bis zum Zweckentschädigungsmodell. Letzteres beruht darauf, dass nicht mehr Entschädigung gezahlt werden darf, als notwendig ist. Voraussetzung ist, dass der Vergesellschaftungszweck erfüllt wird. Die Überführung der Wohnungen in die Gemeinwirtschaft, so dass sie für alle leistbar sind. Der Zweck der Vergesellschaftung setzt der Entschädigungshöhe enge Grenzen.\n\n'
            'Mit verschiedenen Modellen kommen wir so auf eine Summe von 1,5 bis 2,4 Mrd, die vom Landeshaushalt direkt getragen werden müssten.\n\n'
            'Der Rest ist, wie allgemein üblich beim Erwerb von Immobilien, kreditfinanziert und wird über bezahlbare Mieten abbezahlt. Die gesamte Entschädigungssumme beläuft sich für 200.000 Wohnungen somit auf 7,3 bis 12 Mrd. Euro, exklusive der Möglichkeit der nominellen Entschädigung.',
        ['Unterschriftenlisten', 'Listen', 'öffentlich']),
    FAQItem.text(
        10,
        'Wo kann unterschrieben werden?',
        'Unterschrieben werden kann in jedem Berliner Bezirksamt, in einigen solidarischen Orten und bei unseren Sammler*innen auf der Straße.',
        ['wo', 'Unterschriften', 'unterschreiben', 'Listen', 'Orte']),
    FAQItem.text(
        11,
        'Kann ich auch digital unterschreiben?',
        'Nein, laut Berliner Wahlgesetz sind nur handschriftliche Unterschriften gültig.',
        ['digital', 'Internet', 'online', 'E-Mail', 'Mail']),
    FAQItem.text(
        12,
        'Was passiert mit meiner Unterschrift?',
        'Die Unterschriftenlisten werden der Landeswahlleitung zur Überprüfung auf Gültigkeit und Zählung übergeben. Sie werden nicht veröffentlicht.',
        ['Datenschutz', 'Privatsphäre', 'Sicherheit', 'Zählung', 'Auszählung']),
    FAQItem.text(
        13,
        'Was passiert wenn wir nicht genügend Unterschriften sammeln?',
        'Dann ist das Volksbegehren in seiner jetzigen Form gescheitert. Es gibt keine Möglichkeit die Sammlung zu wiederholen.',
        ['Misserfolg', 'verlieren', 'Niederlage', 'Quorum', 'Unterschriften']),
    FAQItem.text(
        14,
        'Was passiert wenn wir genügend Unterschriften gesammelt haben?',
        'Dann wird die dritte Stufe, der Volksentscheid, eingeleitet. Dieser findet als Abstimmung parallel zur Abgeordnentenhaus- und Bundestagswahl 2021 statt.',
        [
          'Unterschriften',
          'Erfolg',
          'danach',
          'Abstimmung',
          'Volksentscheid',
          'dritte Stufe'
        ]),
    FAQItem.text(
        15,
        'Umgang mit Corona',
        'Die Gesundheit aller Sammler*innen und Unterschreibenden ist uns wichtig. Im Kampagnenbüro gibt es dafür kostenlos FFP2-Masken. Alle Materialien werden von uns regelmäßig desinfiziert.',
        ['Corona', 'Pandemie', 'Gesundheit']),
    FAQItem.text(
        16,
        'Welche Unternehmen sollen vergesellschaftet werden?',
        'Vergesellschaftet werden die Berliner Bestände aller auf Profit ausgerichteten Immobilienkonzerne mit mehr als 3000 Wohnungen. Dazu gehören Deutsche Wohnen, Vonovia, Akelius, Covivio, Heimstaden, Pears Global, TAG Immobilien, Grand City Properties, BGP Investment, ADO Properties und noch einige weitere.',
        [
          'Enteignung',
          'Vergesellschaftung',
          'Konzern',
          'Immobilienkapital',
          'Spekulation'
        ]),
    FAQItem(
        17,
        '„Durch Enteignung entsteht keine einzige neue Wohnung.“',
        Text(
            '''- DW & Co Unternehmen bauen selbst fast keine neuen Wohnungen, sondern kaufen Wohnungen auf.
- Konkreter: Eine Studie von 2019 zeigt, dass private Konzerne nur einen Bruchteil ihrer Ausgaben (ca. 1-5%) in Neubau investieren, die Gewobag hingegen (als Beispiel einer landeseigenen Wohnungsunternehmens) 27%.  Einige der privaten Konzerne bauen schlicht gar keine neuen Wohnungen.
- Genossenschaften und landeseigene Wohnungsunternehmen bauen hingegen mehr und günstigere Wohnungen.
- Langfristig sichern Enteignung & Vergesellschaftung Wohnungsneubau also ab.'''),
        Text('''- DW & Co Unternehmen bauen selbst fast keine neuen Wohnungen, sondern kaufen Wohnungen auf.
- Konkreter: Eine Studie von 2019 zeigt, dass private Konzerne nur einen Bruchteil ihrer Ausgaben (ca. 1-5%) in Neubau investieren...'''),
        '''- DW & Co Unternehmen bauen selbst fast keine neuen Wohnungen, sondern kaufen Wohnungen auf.
- Konkreter: Eine Studie von 2019 zeigt, dass private Konzerne nur einen Bruchteil ihrer Ausgaben (ca. 1-5%) in Neubau investieren, die Gewobag hingegen (als Beispiel einer landeseigenen Wohnungsunternehmens) 27%.  Einige der privaten Konzerne bauen schlicht gar keine neuen Wohnungen.
- Genossenschaften und landeseigene Wohnungsunternehmen bauen hingegen mehr und günstigere Wohnungen.
- Langfristig sichern Enteignung & Vergesellschaftung Wohnungsneubau also ab.''',
        ['Bauen', 'Neubau', 'Konzern', 'Immobilienkapital', 'Spekulation']),
    FAQItem(
        18,
        '„Es muss einfach mehr gebaut werden!“',
        Text('- Das funktioniert nicht, solange Wohnraum als Kapitalanlage gilt. Beim aktuellen Wohnungsmarkt ist das Ziel nicht günstige Wohnraumversorgung für alle, sondern hoher Profit & Rendite der wenigen Aktionäre und Unternehmenseigentümer. \n- Die Immobilienunternehmen nutzen die Wohnungsbestände als Kapitalanlage. Je höher also die Miete, desto höher deren Wert und damit der Wert der ganzen Unternehmen – höhere Mieten sind also der Kern ihres Geschäfts.\n- Der Neubau von privaten Immobilienunternehmen ist zumeist teuer, luxuriös oder Eigentumswohnungen, die sich ein Großteil der Bevölkerung nicht leisten können.\n- Die Mieten bleiben stabil bei Wohnungen in gemeinwirtschaftlicher und öffentlicher Hand.'),
        Text(
            '- Das funktioniert nicht, solange Wohnraum als Kapitalanlage gilt. Beim aktuellen Wohnungsmarkt ist das Ziel nicht günstige Wohnraumversorgung für alle, sondern hoher Profit & Rendite der wenigen Aktionäre und Unternehmenseigentümer. \n- Die Immobilienunternehmen nutzen die Wohnungsbestände als...'),
        'Das funktioniert nicht, solange Wohnraum als Kapitalanlage gilt. Beim aktuellen Wohnungsmarkt ist das Ziel nicht günstige Wohnraumversorgung für alle, sondern hoher Profit & Rendite der wenigen Aktionäre und Unternehmenseigentümer. Die Immobilienunternehmen nutzen die Wohnungsbestände als Kapitalanlage. Je höher also die Miete, desto höher deren Wert und damit der Wert der ganzen Unternehmen – höhere Mieten sind also der Kern ihres Geschäfts.\n- Der Neubau von privaten Immobilienunternehmen ist zumeist teuer, luxuriös oder Eigentumswohnungen, die sich ein Großteil der Bevölkerung nicht leisten können. Die Mieten bleiben stabil bei Wohnungen in gemeinwirtschaftlicher und öffentlicher Hand.',
        [
          'Gemeinwohl',
          'Neubau',
          'Eigentum',
          'Wohnungsmarkt',
          'Kapital',
          'Spekulation'
        ]),
    FAQItem(
        19,
        'Kosten der Vergesellschaftung und Finanzierbarkeit',
        Text(
            '- Die Vergesellschaftung soll der Stadt Berlin langfristig nichts kosten – Kredite trägt eine neue Anstalt des öffentlichen Rechts, nicht der Berliner Haushal.\n- Die öffentliche Hand verliert nicht Geld, sondern das öffentliche Vermögen wird durch die vergesellschafteten Immobilien langfristig erhöht.\n- DW & Co nutzen Steuerschlupflöcher, verursachen so Verluste von hunderten Millionen Euro, der Staat zahlt somit einen Teil der Mieten durch Sozialleistungen mit. Wir können uns die Konzerne nicht leisten.\n- Die Immobilienunternehmen nutzen die Wohnungsbestände als Kapitalanlage. Je höher also die Miete, desto höher deren Wert und damit der Wert der ganzen Unternehmen – höhere Mieten sind also der Kern ihres Geschäfts.\n- Der Neubau von privaten Immobilienunternehmen ist zumeist teuer, luxuriös oder Eigentumswohnungen, die sich ein Großteil der Bevölkerung nicht leisten können.\n- Die Mieten bleiben stabil bei Wohnungen in gemeinwirtschaftlicher und öffentlicher Hand.'),
        Text(
            '- Die Vergesellschaftung soll der Stadt Berlin langfristig nichts kosten – Kredite trägt eine neue Anstalt des öffentlichen Rechts, nicht der Berliner Haushalt. \n- Die öffentliche Hand verliert nicht Geld, sondern...'),
        'Die Vergesellschaftung soll der Stadt Berlin langfristig nichts kosten – Kredite trägt eine neue Anstalt des öffentlichen Rechts, nicht der Berliner Haushal. Die öffentliche Hand verliert nicht Geld, sondern das öffentliche Vermögen wird durch die vergesellschafteten Immobilien langfristig erhöht. DW & Co nutzen Steuerschlupflöcher, verursachen so Verluste von hunderten Millionen Euro, der Staat zahlt somit einen Teil der Mieten durch Sozialleistungen mit. Wir können uns die Konzerne nicht leisten. Die Immobilienunternehmen nutzen die Wohnungsbestände als Kapitalanlage. Je höher also die Miete, desto höher deren Wert und damit der Wert der ganzen Unternehmen – höhere Mieten sind also der Kern ihres Geschäfts. Der Neubau von privaten Immobilienunternehmen ist zumeist teuer, luxuriös oder Eigentumswohnungen, die sich ein Großteil der Bevölkerung nicht leisten können.\n- Die Mieten bleiben stabil bei Wohnungen in gemeinwirtschaftlicher und öffentlicher Hand.',
        [
          'Finanzierung',
          'Vergesellschaftung',
          'Entschädigung',
          'Kosten',
          'Kriedit',
          'Vermögen',
          'Verlust',
          'Steuern',
          'Haushalt'
        ]),
    FAQItem(
        20,
        'Was ist eine Anstalt öffentlichen Rechts und warum wollen wir diese Form?',
        Text(
            '''- Es handelt sich um eine eigenständige juristische Person (öffentliche Institution) für einen öffentlichen Zweck. Beispiele für Anstalten öffentlichen Rechts sind ZDF & ARD, Berliner Bäderbetriebe, Öffentliche Krankenhäuser usw.
- Anstalten öffentlichen Rechts gehören nicht dem Staat und können daher nicht wieder privatisiert werden.
- Die Anstalten öffentlichen Rechts ermöglicht eine demokratische Mitbestimmung - wir streben einen Gesamtmieter*innenrat an. Das ist auch bei landeseigenen Wohnungsunternehmen nicht möglich.
- die Angestellten der Unternehmen behalten ihre Jobs und werden in die Anstalt öffentlichen Rechts übernommen und in die demokraitschen Entscheidungsprozesse mit einbezogen.'''),
        Text(
            '''- Es handelt sich um eine eigenständige juristische Person (öffentliche Institution) für einen öffentlichen Zweck. Beispiele für Anstalten öffentlichen Rechts sind ZDF & ARD, Berliner Bäderbetriebe, Öffentliche Krankenhäuser usw.
- Anstalten öffentlichen Rechts gehören nicht dem Staat...'''),
        '''- Es handelt sich um eine eigenständige juristische Person (öffentliche Institution) für einen öffentlichen Zweck. Beispiele für Anstalten öffentlichen Rechts sind ZDF & ARD, Berliner Bäderbetriebe, Öffentliche Krankenhäuser usw.
- Anstalten öffentlichen Rechts gehören nicht dem Staat und können daher nicht wieder privatisiert werden.
- Die Anstalten öffentlichen Rechts ermöglicht eine demokratische Mitbestimmung - wir streben einen Gesamtmieter*innenrat an. Das ist auch bei landeseigenen Wohnungsunternehmen nicht möglich.
- die Angestellten der Unternehmen behalten ihre Jobs und werden in die Anstalt öffentlichen Rechts übernommen und in die demokraitschen Entscheidungsprozesse mit einbezogen.''',
        [
          'AöR',
          'Verstaatlichung',
          'Vergesellschaftung',
          'Anstalt',
          'öffentlichen',
          'Rechts',
          'demokratische',
          'Mitbestimmung',
          'Privatisierung'
        ]),
    FAQItem(
        21,
        'Rechtliche Grundlage im Grundgesetz',
        Text(
            '''- Enteignungen sind gängige Praxis in Deutschland mit Grundgesetz-Artikel 14 & 15. Es gibt hunderte Verfahren jedes Jahr.
- Artikel 15 GG sieht die Vergesellschaftung im Sinne des Gemeinwohls explizit vor
- Aber bisher sind nur Familien, Landwirte usw. betroffen, beispielsweise bei Straßenbau oder Kohletagebau. Wir drehen den Spieß um, indem wir die Vergesellschaftung großer profitorientierter Immobilienkonzerne fordern.'''),
        Text(
            '''- Enteignungen sind gängige Praxis in Deutschland mit Grundgesetz-Artikel 14 & 15. Es gibt hunderte Verfahren jedes Jahr.
- Artikel 15 GG sieht die Vergesellschaftung im Sinne des Gemeinwohls explizit vor...'''),
        '''- Enteignungen sind gängige Praxis in Deutschland mit Grundgesetz-Artikel 14 & 15. Es gibt hunderte Verfahren jedes Jahr.
- Artikel 15 GG sieht die Vergesellschaftung im Sinne des Gemeinwohls explizit vor
- Aber bisher sind nur Familien, Landwirte usw. betroffen, beispielsweise bei Straßenbau oder Kohletagebau. Wir drehen den Spieß um, indem wir die Vergesellschaftung großer profitorientierter Immobilienkonzerne fordern.''',
        [
          'Recht',
          'Grundgesetz',
          'DDR',
          'Stalinismus',
          'Sowjetunion',
          'Unrecht',
          'Verfassung',
          'Demokratie',
        ]),
    FAQItem(
        22,
        'Mietendeckel - Ist Vergesellschaftung überhaupt noch notwendig?',
        Text(
            '''- Der Mietendeckel ist (leider) noch rechtlich unsicher - Das Bundesverfassungsgericht könnte ihn kippen.
- Der Mietendeckel gilt nur für fünf Jahre - und schon jetzt haben Politiker*innen wie Franziska Giffey (SPD) angedeutet, ihn nicht verlängern zu wollen. Dann drohen massenhaft Mieterhöhungen. 
- Beide Gesetze (Mietendeckel und Vergesellschaftung) können nebeneinander stehen.
- Der Mietendeckel reguliert, Vergesellschaftung denkt Wohnen neu: mit Mieten soll kein Profit mehr gemacht werden!'''),
        Text(
            '''- Der Mietendeckel ist (leider) noch rechtlich unsicher - Das Bundesverfassungsgericht könnte ihn kippen.
- Der Mietendeckel gilt nur für fünf Jahre - und schon jetzt haben Politiker*innen wie Franziska Giffey (SPD) angedeutet, ihn nicht verlängern zu wollen...'''),
        '''- Der Mietendeckel ist (leider) noch rechtlich unsicher - Das Bundesverfassungsgericht könnte ihn kippen.
- Der Mietendeckel gilt nur für fünf Jahre - und schon jetzt haben Politiker*innen wie Franziska Giffey (SPD) angedeutet, ihn nicht verlängern zu wollen. Dann drohen massenhaft Mieterhöhungen. 
- Beide Gesetze (Mietendeckel und Vergesellschaftung) können nebeneinander stehen.
- Der Mietendeckel reguliert, Vergesellschaftung denkt Wohnen neu: mit Mieten soll kein Profit mehr gemacht werden!''',
        [
          'Mietendeckel',
          'Vergesellschaftung',
          'Mieterhöhung',
          'Mietenstopp',
        ]),
  ];

  static List<FAQItem> loadItems(String search) {
    if (search == null) search = '';

    var searchWords = search
        .split(RegExp(r"\s+"))
        .map((word) => word.toLowerCase())
        .where((word) => isNotBlank(word));

    // Erzeugt eine Map die für jedes item das Gewicht (~ Anzahl Treffer) speichert
    Map<FAQItem, int> weight =
        Map.fromIterable(items, key: (item) => item, value: (_) => 0);

    // Suche in Schlagwörtern
    searchWords.forEach((word) {
      items.forEach((item) {
        for (var tag in item.tags) {
          if (tag.toLowerCase().contains(word)) {
            weight[item] += 100; // Schlagwörter haben schweres Gewicht
            break; // nicht mehrere Treffer pro Stichwort
          }
        }
      });
    });

    // Suche im Titel
    searchWords.forEach((word) {
      items.forEach((item) {
        if (item.title.toLowerCase().contains(word))
          weight[item] += 10; // Titel-Treffer haben mittleres Gewicht
      });
    });

    // Suche im Text
    searchWords.forEach((word) {
      items.forEach((item) {
        if (item.plainText.toLowerCase().contains(word))
          weight[item] += 1; // Text-Treffer haben niedriges Gewicht
      });
    });

    List<FAQItem> orderedItems = List<FAQItem>.of(items); // Kopie zum sortieren
    orderedItems.sort((item1, item2) =>
        Comparable.compare(weight[item1], weight[item2]) * -1);

    return orderedItems;
  }
}
