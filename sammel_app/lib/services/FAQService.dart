import 'package:quiver/strings.dart';
import 'package:sammel_app/model/FAQItem.dart';

class FAQService {
  static List<FAQItem> loadItems(String? search) {
    if (search == null) search = '';

    if (search == '') {
      List<FAQItem> orderedItems =
          List<FAQItem>.of(items); // Kopie zum sortieren
      orderedItems.sort((item1, item2) => item1.id < item2.id ? -1 : 1);
      return orderedItems;
    ***REMOVED***

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
            // Schlagwörter haben schweres Gewicht
            weight[item] = weight[item]! + 100;
            break; // nicht mehrere Treffer pro Stichwort
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***);
    ***REMOVED***);

    // Suche im Titel
    searchWords.forEach((word) {
      items.forEach((item) {
        if (item.title.toLowerCase().contains(word))
          // Titel-Treffer haben mittleres Gewicht
          weight[item] = weight[item]! + 10;
      ***REMOVED***);
    ***REMOVED***);

    // Suche im Text
    searchWords.forEach((word) {
      items.forEach((item) {
        if (item.full.toLowerCase().contains(word))
          // niedriges Gewicht für Text-Treffer
          weight[item] = weight[item]! + 1;
      ***REMOVED***);
    ***REMOVED***);

    List<FAQItem> orderedItems = List<FAQItem>.of(items); // Kopie zum sortieren
    orderedItems.sort((item1, item2) =>
        Comparable.compare(weight[item1]!, weight[item2]!) * -1);

    return orderedItems;
  ***REMOVED***


  static List<FAQItem> items = [
    FAQItem.short(
        1,
        'Wann geht\'s los?',
        'Am **26. Februar** ist _Sammelbeginn_.',
        1.0,
        ['Start', 'Beginn', 'Sammelphase']),
    FAQItem(
        2,
        'Was sind die Stufen des Volksbegehrens?',
        '''Jedes Volksbegehren läuft in 3 Stufen ab.
Diese sind:''',
        '''\n\n
        | **Stufe** | **Erfolg** | **Zeitraum** |
| ------------ | ------------ | ------------ |
| Volksinitiative  | 50.000 Unterschriften  |   |
| Volksbegehren  | 170.000 Unterschriften  |   |
| Volksentscheid  | 613.000 Ja-Stimmen  |   |
''',
        2.0,
        [
          'Stufen',
          'Volksbegehren',
          'Volksinitiative',
          'Erfolg',
          'Unterschriften'
        ]),
    FAQItem(
        3,
        'Sammeltipps',
        '''Ein kurzer und inhaltlich einfacher Satz hat sich oft bewährt.

Ein paar Beispiele:
''',
        '''> "Hast Du schon von unserem Volksbegehren gehört?“ 
> „Möchtest Du für bezahlbare Mieten unterschreiben?“
> „Wir sammeln Unterschriften gegen zu hohe Mieten – möchten Sie unterschreiben?“

Nach kurzer Bedenkzeit der Person kann eine weitere erläuternder Satz nachgeschoben werden:

> „Wir sind von der Initiative gegen die Deutsche Wohnen und anderer Immobilienunternehmen“
> „Wir sind von der Initiative Deutsche Wohnen und Co enteignen.“''',
        3.0,
        ['Start', 'Beginn', 'Sammelphase']),
    FAQItem.short(
        4,
        'Feedback und Fehlermeldungen',
        '''Wenn du eine Fehler gefunden hast oder uns anderes Feedback zur App melden willst, dann schreib uns doch [per Mail](mailto:app@dwenteignen.de) oder öffne ein Bug-Ticket auf [der App-Webseite](https://www.gitlab.com/kybernetik/sammel-app)''',
        4.0,
        ['Start', 'Beginn', 'Sammelphase']),
  ];
***REMOVED***
