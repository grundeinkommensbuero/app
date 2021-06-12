import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/FAQItem.dart';
import 'package:url_launcher/url_launcher.dart';

String bullet = "\u2022";
String textArgumente =
    '''1. weil Deutsche Wohnen und Co die Mieten immer weiter hochtreiben und hohe Mieten ihr Geschäftsziel sind. \n'''
    '''2. weil Deutsche Wohnen und Co mit den Mietsteigerungen auch die lokale Mietspiegel nach oben beeinflussen und andere Vermieter*innen Mietererhöhungen damit rechtfertigen. \n'''
    '''3. weil einige dieser Konzerne Milliardären gehören (Akelius, Covivio, Heimstaden, Pears Global, Grand City Properties), die sich auf Kosten der Berliner Bevölkerung weiter bereichern. \n'''
    '''4. weil Deutsche Wohnen und Co fast keine neuen Wohnungen bauen, sondern fast nur Häuser aufkaufen. Damit verschlimmern sie Wohnungsknappheit in Berlin. \n'''
    '''5. weil durch die Mietsteigerungen der Immobilienkonzerne immer mehr Menschen von Verdrängung betroffen sind. \n'''
    '''6. weil eine handvoll Eigentümer und Vorstandsvorsitzende über die Wohnungen hunderttausender in Berlin verfügen können und das im Kern undemokratisch ist. \n'''
    '''7. die überwiegende Mehrzahl der Wohnungen im Besitz der Deutsche Wohnen früher in kommunaler Hand waren (GSW und GEHAG). Wir wollen einfach unsere Häuser zurück. \n'''
    '''8. weil die Deutsche Wohnen die Häuser vergammeln lässt, keine ausreichende Instandhaltung betreibt (z.B. ständige, tagelange Heizungsausfälle im Winter), um sie später teuer zu modernisieren und die Bestandsmieter*innen damit zu vertreiben. \n'''
    '''9. weil Wohnen ein Grundbedürfnis ist und jeder Mensch das Recht haben sollte, keine Angst um die eigene Wohnung zu haben. \n'''
    '''10. weil die Konzerne mit sogenannten "Share Deals" beim Immobilienkauf die Grunderwerbssteuer umgehen und das Berlin jährlich Millionen Euro kostet''';

String textArgumenteShort =
    '''1. weil Deutsche Wohnen und Co die Mieten immer weiter hochtreiben und hohe Mieten ihr Geschäftsziel sind. \n'''
    '''2. weil Deutsche Wohnen und Co mit den Mietsteigerungen auch die lokale Mietspiegel nach oben beeinflussen und andere Vermieter*innen Mietererhöhungen damit rechtfertigen. \n'''
    '''...''';

String textWarumErstAb3000 =
    '''Ab ungefähr dieser Schwelle erreichen die Unternehmen eine relevante Stellung auf dem Wohnungsmarkt in Berlin, bei dem die Vergesellschaftung nach Art. 15 GG greifen kann. Ausserdem sind ab dieser Schwelle die Konzerne erfasst, die als Finanzunternehmen agieren, also mit dem Zweck der Vermarktung von Wohnraum auf dem internationalen Finanzmarkt. Kapital aus der ganzen Welt wird in den Berliner Immobilienmarkt, und vor allem in diese Unternehmen investiert, mit der Erwartung von hohen Renditen. Das heißt konkret, sie kaufen Aktien dieser Unternehmen, z.B. Vonovia. Macht Vonovia Gewinn, schütten sie einen Teil davon in Form von Dividenden an die Aktionär*innen aus. So fließt Geld von den Mieter*innen über Vonovia auch an reiche Aktionär*innen. Diese Form der Geldanlage ist besonders attraktiv für große ausländische Fonds.''';
String textWarumErstAb3000Short =
    '''Ab ungefähr dieser Schwelle erreichen die Unternehmen eine relevante Stellung auf dem Wohnungsmarkt in Berlin, bei dem die Vergesellschaftung nach Art. 15 GG greifen kann. Ausserdem sind ab dieser Schwelle die Konzerne erfasst, die als Finanzunternehmen agieren...''';

String textWasKostetSieVergesellschaftung =
    '''Wir schlagen das „Faire-Mieten-Modell“ vor, nach der die Entschädigungshöhe bei acht Milliarden Euro liegt. Klingt viel, ist aber sehr wenig im Vergleich zu den Gewinnen der Konzerne. Allein die Deutsche Wohnen machte 2019 einen Gewinn von 1,6 Milliarden Euro - zumeist auf Kosten der Berliner Mieter*innen.
Unser Modell geht vom Interesse der Allgemeinheit nach bezahlbaren Wohnraum aus und kalkuliert eine Miethöhe, die sich auch Menschen an der Armutsgrenze leisten können, konkret 3,70€ pro Quadratmeter nettokalt.
Für die Entschädigungssumme wird ein Kredit aufgenommen, der auf 43,5 Jahre gestreckt von den laufenden Mieteinnahmen refinanziert wird. Der Tilgungszeitraum 43,5 Jahre wird vom Berliner Senat in seiner Kostenschätzung vorgeschlagen.
In diesem Zeitraum bleibt die AöR handlungsfähig. Die Mieten sind kostendeckend und es können neue Projekte durchgeführt werden, bspw. Renovierungen und der Neubau von Wohnungen.''';
String textWasKostetDieVergesellschaftungShort =
    '''Wir schlagen das „Faire-Mieten-Modell“ vor, nach der die Entschädigungshöhe bei acht Milliarden Euro liegt. Klingt viel, ist aber sehr wenig im Vergleich zu den Gewinnen der Konzerne. Allein die Deutsche Wohnen machte 2019 einen Gewinn von 1,6 Milliarden Euro - zumeist auf Kosten der Berliner Mieter*innen.
Unser Modell geht vom Interesse der Allgemeinheit nach bezahlbaren Wohnraum aus und kalkuliert eine Miethöhe...''';

String sammelTipps1 =
    '''Ein kurzer und inhaltlich einfacher Satz hat sich oft bewährt.

Ein paar Beispiele:
"Hast Du schon von unserem Volksbegehren gehört?“ 
„Möchtest Du für bezahlbare Mieten unterschreiben?“
„Wir sammeln Unterschriften gegen zu hohe Mieten – möchten Sie unterschreiben?“

Nach kurzer Bedenkzeit der Person kann eine weitere erläuternder Satz nachgeschoben werden:

„Wir sind von der Initiative gegen die Deutsche Wohnen und anderer Immobilienunternehmen“ 
„Wir sind von der Initiative Deutsche Wohnen und Co enteignen.“''';

String sammelTipps1Short =
    '''Ein kurzer und inhaltlich einfacher Satz hat sich oft bewährt.

Ein paar Beispiele...''';

String sammelTipps3 =
    '''Einem großen Teil der Bevölkerung sind Begriffe wie „Spekulation“ und „Vergesellschaftung“ nicht ganz klar. Hilfreich sind daher einfachere Formulierungen: "Zurzeit werden einige wenige Unternehmer*innen mit den Mieten superreich, während die meisten Mieter*innen darunter leiden. Wir möchten, dass Wohnungen demokratisch verwaltet werden und zu gerechten Miete verfügbar sind."''';
String sammelTipps3Short =
    '''Einem großen Teil der Bevölkerung sind Begriffe wie „Spekulation“ und „Vergesellschaftung“ nicht ganz klar...''';

String argumentationTipps1 =
    '''Ja. Wir berufen uns auf Art. 15 des Grundgesetzes, der Vergesellschaftungen grundsätzlich ermöglicht. Es wurden bereits mehrere Gutachten erstellt, drei im Auftrag des Berliner Senats und eins vom wissenschaftlichen Dienst des Bundestages. Alle sagen: Vergesellschaftung ist möglich! Sie unterscheiden sie lediglich bei Fragen zur Entschädigung und Ausführung. 
Es ist zu erwarten, dass sich die Deutsche Wohnen und Co vor Gericht gegen ihre eigene Vergesellschaftung wehren möchten. Das sollte uns jedoch nicht davon abhalten, weiter politisch dafür zu kämpfen.''';

String argumentationTipps1Short =
    '''Ja. Wir berufen uns auf Art. 15 des Grundgesetzes, der Vergesellschaftungen grundsätzlich ermöglicht...''';

String beschlussText =
    '''In seltenen Fällen kann es passieren, dass ihr beim Sammeln auf das Vorzeigen des vollstädnigen Beschlusstext  der Landeswahlleitung angesprochen werdet. Gedruckte Exemplare gibt es im Kampagnenbüro (Graefestr. 14, 10967 Berlin), alternativ könnt ihr ihn auch unter diesem ''';

String textCounterArgument1 =
    '''Es werden keine günstigen Mieten garantiert, solange Wohnraum als Kapitalanlage genutzt wird. Beim aktuellen Wohnungsmarkt ist das Ziel nicht günstige Wohnraumversorgung für alle, sondern hoher Profit & Rendite der wenigen Aktionär*innen und Unternehmenseigentümer*innen.
Die Immobilienunternehmen nutzen die Wohnungsbestände als Kapitalanlage. Je höher also die Miete, desto höher deren Wert und damit der Wert des jeweiligen Unternehmens. Höhere Mieten sind also ihr Geschäftsziel!
Der Wohnungsneubau von privaten Immobilienunternehmen ist zumeist teuer oder in Form von Eigentumswohnungen, die sich ein Großteil der Bevölkerung nicht leisten kann. Durch die Vergesellschaftung bleiben die Mieten hingegen stabil in gemeinwirtschaftlicher und öffentlicher Hand.''';
String textCounterArgument1Short =
    '''Es werden keine günstigen Mieten garantiert, solange Wohnraum als Kapitalanlage genutzt wird. Beim aktuellen Wohnungsmarkt ist das Ziel nicht günstige Wohnraumversorgung für alle, sondern hoher Profit & Rendite der wenigen Aktionär*innen und Unternehmenseigentümer*innen.
Die Immobilienunternehmen...''';

String textCounterArgument2 =
    '''Die Vergesellschaftung soll die Stadt Berlin langfristig nichts kosten. Die Kredite trägt die neue Anstalt des öffentlichen Rechts, nicht der Berliner Haushalt. Sie Kredite werden auf 43,5 Jahre gestreckt und von den laufenden Mieteinnahmen getilgt. Die öffentliche Hand verliert nicht Geld, sondern das öffentliche Vermögen wird durch die vergesellschafteten Immobilien langfristig erhöht. 
DW & Co hingegen nutzen Steuerschlupflöcher, verursachen so Verluste von hunderten Millionen Euro, aber der Staat zahlt einen Teil der Mieten durch Sozialleistungen mit. Wir können uns also die Konzerne nicht leisten.''';
String textCounterArgument2Short =
    "Die Vergesellschaftung soll die Stadt Berlin langfristig nichts kosten. Die Kredite trägt die neue Anstalt des öffentlichen Rechts, nicht der Berliner Haushalt. Sie Kredite werden auf 43,5 Jahre gestreckt und von den laufenden Mieteinnahmen getilgt...";

String textCounterArgument3 =
    '''Enteignungen sind gängige Praxis in Deutschland mit dem Grundgesetz-Artikel 14. Es gibt hunderte Verfahren jedes Jahr. Aber bisher sind nur Familien, Landwirte und sonstige Einzelpersonen betroffen, beispielsweise beim Straßenbau oder für Kohletagebaue. Wir drehen den Spieß um, indem wir die Vergesellschaftung großer profitorientierter Immobilienkonzerne fordern.
Artikel 15 GG sieht die Vergesellschaftung im Sinne des Gemeinwohls explizit vor. Unser Ziel ist eine Demokratisierung des Wohnungssektors. Wir wollen eine demokratische und dezentrale Verwaltung der Wohnungen in der Anstalt öffentlichen Rechts. Die Mieter*innen sollen durch die Wahl eines Gesamtmieter*innenrat mitentscheiden können.''';
String textCounterArgument3Short =
    '''Enteignungen sind gängige Praxis in Deutschland mit dem Grundgesetz-Artikel 14. Es gibt hunderte Verfahren jedes Jahr. Aber bisher sind nur Familien, Landwirte und sonstige Einzelpersonen betroffen, beispielsweise beim Straßenbau oder für Kohletagebaue. Wir drehen den Spieß um, indem wir die Vergesellschaftung großer ...''';

String textCounterArgument4 =
    '''DW & Co Unternehmen bauen selbst fast keine neuen Wohnungen, sondern kaufen Wohnungen zumeist auf.
Eine Studie von 2019 zeigt, dass private Konzerne nur einen Bruchteil ihrer Ausgaben (ca. 1-5 %) in Neubau investieren, die Gewobag hingegen (als Beispiel eines landeseigenen Wohnungsunternehmens) 27 %. Einige der privaten Konzerne bauen schlicht gar keine neuen Wohnungen. Genossenschaften und landeseigene Wohnungsunternehmen bauen hingegen mehr und günstigere Wohnungen.
Langfristig sichern wir mit der Enteignung und Vergesellschaftung günstigen Wohnungsneubau ab. Mit der Anstalt öffentlichen Rechts entsteht ein großer gemeinwohlorientierter Akteur, der Neubau ankurbeln und sozial gestalten kann.''';
String textCounterArgument4Short =
    '''DW & Co Unternehmen bauen selbst fast keine neuen Wohnungen, sondern kaufen Wohnungen zumeist auf.
 Eine Studie von 2019 zeigt, dass private Konzerne nur einen Bruchteil ihrer Ausgaben (ca. 1-5 %) in Neubau investieren, die Gewobag...''';

String textClimate =
    '''Konzerne wie die Deutsche Wohnen nutzen die energetische Modernisierung bisher als Hebel, um die Mieten zu steigern. Diese Mietererhöhungen gelten auch dann weiter, wenn die Dämmung abbezahlt ist. Die gesparten Heizkosten sind oft gering, die verwendeten Materialien oft ökologisch fragwürdig.
In der Anstalt öffentlichen Rechts könnte diese Praxis sinnvoll angepasst werden: Dämmung nur dort, wo es Heizkosten spart und mit ökologisch verträglichen Materialien, finanziert aus allgemeinen Überschüssen und nicht durch enorme Mieterhöhungen.
Zusätzlich könnte demokratisch entschieden werden Photovoltaikanlagen auf den Dächern zu installieren, deren Solarstrom zu Vorzugspreisen direkt an die Mieter*innen geliefert wird. So treiben inzwischen auch einige landeseigene Unternehmen die Energiewende voran, ohne den Landeshaushalt zu belasten.
Die Gemeinwirtschaft im Wohnungsbereich könnte so erheblich zu einer sozial-ökologischen Transformation beitragen.''';
String textClimateShort =
    '''Konzerne wie die Deutsche Wohnen nutzen die energetische Modernisierung bisher als Hebel, um die Mieten zu steigern. Diese Mietererhöhungen gelten auch dann weiter, wenn die Dämmung abbezahlt ist. Die gesparten Heizkosten sind oft...''';

String textSenateNumbers =
    '''Die erste Zahl entspricht dem (spekulativ überhöhten) Marktwert der Wohnungsbestände. Das entspräche einem reinen Rückkauf zum Marktpreis. Der Marktpreis enthält die Wette, dass die Mieten in Berlin steigen werden und der hohe Kaufpreis der Wohnungen sich so im Laufe der Zeit für einen neuen Eigentümer lohnt.
Bei der zweiten Zahl sind zumindest die leistungslosen Wertsteigerungen des Bodens abgezogen.
Sinn und Zweck der Vergesellschaftung ist jedoch deutlich unter dem Marktwert zu entschädigen.
Andere Methoden zur Ermittlung der Entschädigungshöhe kommen auf 11 oder 18 Milliarden Euro. Aber selbst bei 18 Mrd. könnten wir eine Durchschnittsmiete von rund 5,50€ nettokalt garantieren.''';
String textSenateNumbersShort =
    'Die erste Zahl entspricht dem (spekulativ überhöhten) Marktwert der Wohnungsbestände. Das entspräche einem reinen Rückkauf zum Marktpreis. Der Marktpreis enthält die Wette, dass die Mieten in Berlin steigen...';

String textVergesellschaftungFinanziell =
    '''Bisher fließen auch Transferleistungen (Wohngeld, Kosten für Unterkunft bei Arbeitslosengeld, Sozialhilfe) auf das Konto von Immobilienunternehmen und damit an deren wohlhabende Aktionär*innen und die Finanzmärkte.
Durch die Vergesellschaftung würden die öffentlichen Kassen diese Kosten zum Teil einsparen. Außerdem würde das Geld an die AöR gehen und somit einer gemeinwohlorientierten Wirtschaftsform in Berlin erhalten bleiben.
Wegen der geringeren Mieten wird der regionale Wirtschaftskreislauf gestärkt. Denn statt für überhöhte Mieten geben die Menschen das Geld in anderen Bereichen aus, bspw. in der Gastronomie, für neue Anschaffungen oder Freizeitaktivitäten.''';
String textVergesellschaftungFinanziellShort =
    '''Bisher fließen auch Transferleistungen (Wohngeld, Kosten für Unterkunft bei Arbeitslosengeld, Sozialhilfe) auf das Konto von Immobilienunternehmen und damit an deren wohlhabende Aktionär*innen und die Finanzmärkte.
Durch die Vergesellschaftung würden...''';

String textWarumAoerKeineWbg =
    '''Die Geschäftsführungen der sechs landeseigenen Wohnungsbaugesellschaften sind nicht gewählt, sondern vom Berliner Senat eingesetzt. Ihre Rechtsformen sind GmbH und Aktiengesellschaft und bedeuten ebenso Geschäftsgeheimnis und Intransparenz. Die Geschäftsvorstände beziehen Jahresgehälter in Höhe von rund 300.000€. Die Verwaltungsentscheidungen werden nicht demokratisch getroffen.
Deshalb bevorzugen wir die Anstalt öffentlichen Rechts als Rechtsform. Sie kann eine direkte und demokratische Kontrolle der Wohnungsbestände sicherstellen. Im Verwaltungsrat der AöR sollen Mieter*innen und Beschäftigte eine wesentlich größere Entscheidungsbefugnis innehaben als die Senatsvertreter*innen.
Zudem ist bei einer AöR die Festlegung eines Privatisierungsverbotes möglich.''';
String textWarumAoerKeineWbgShort =
    '''Die Geschäftsführungen der sechs landeseigenen Wohnungsbaugesellschaften sind nicht gewählt, sondern vom Berliner Senat eingesetzt. Ihre Rechtsformen sind GmbH und Aktiengesellschaft und bedeuten ebenso Geschäftsgeheimnis und Intransparenz. Die Geschäftsvorstände beziehen Jahresgehälter in Höhe von rund 300.000€...''';

String textWarumAoer =
    '''Die Anstalt öffentlichen Rechts (AöR) ist eine eigenständige juristische Person für einen öffentlichen Zweck. Beispiele für Anstalten öffentlichen Rechts sind ZDF & ARD, die Berliner Bäderbetriebe oder öffentliche Krankenhäuser.
Als eigenständige Rechtspersönlichkeit soll die AöR ihre Aufgabe (günstige Wohnraumversorgung) unabhängig erfüllen. Eine erneute Privatisierung der Wohnungsbestände soll per Satzung ausgeschlossen werden.
Die Anstalt öffentlichen Rechts ermöglicht eine demokratische Mitbestimmung – wir streben einen Gesamtmieter*innenrat an, über den die Mieter*innen an Entscheidungen beteiligt werden. Das ist bei landeseigenen Wohnungsunternehmen nicht möglich. Die Angestellten der bisherigen Unternehmen behalten ihre Jobs, werden in die Anstalt öffentlichen Rechts übernommen und in die demokratischen Entscheidungsprozesse mit einbezogen.''';

String textWarumAoerShort =
    '''Die Anstalt öffentlichen Rechts (AöR) ist eine eigenständige juristische Person für einen öffentlichen Zweck. Beispiele für Anstalten öffentlichen Rechts sind ZDF & ARD, die Berliner Bäderbetriebe oder öffentliche Krankenhäuser.
Als eigenständige Rechtspersönlichkeit soll die AöR...''';

class FAQService {
  static List<FAQItem> items = [
    anleitung,
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
    FAQItem(
        5,
        'Wessen Unterschrift ist gültig?',
        Text(
            'Wahlberechtigt sind alle Berliner*innen mit deutschem Pass, die mindestens drei Monate in Berlin gemeldet und mindestens 18 Jahre alt sind. Die Unterschriften eines großen Teils der Einwohner*innen Berlins, werden also für ungültig erklärt. Das ist unserer Meinung nach höchst undemokratisch und ein politischer Skandal. Wir freuen uns jedoch über jede Unterstützung und finden es deshalb gut, wenn auch Personen unterschreiben, die nicht wahlberechtigt sind.\n\n'
            'Eine Ausnahmeregelung gilt gemäß Wahlgesetz jedoch: "Personen, die nicht in einem Melderegister der Bundesrepublik Deutschland verzeichnet sind oder nicht seit drei Monaten vor dem Tag der Unterzeichnung im Melderegister in Berlin gemeldet sind, können das Volksbegehren ebenfalls unterzeichnen. Sie müssen mit der Unterzeichnung in einer amtlichen Auslegungsstelle oder im Bezirksamt durch Versicherung an Eides Statt gegenüber dem Bezirksamt glaubhaft machen, dass sie sich in den letzten drei Monaten überwiegend in Berlin aufgehalten haben.\n'
            'Erklärt eine zustimmungswillige Person, dass sie nicht schreiben kann, so ist die Eintragung von Amts wegen in einer amtlichen Auslegungsstelle oder im Bezirksamt unter Vermerk dieser Erklärung vorzunehmen".'),
        Text(
            'Wahlberechtigt sind alle Berliner*innen mit deutschem Pass, die mindestens drei Monate in Berlin gemeldet und mindestens 18 Jahre alt sind. Die Unterschriften eines großen Teils der Einwohner*innen Berlins, werden also für ungültig erklärt. Das ist unserer Meinung nach höchst undemokratisch und ein politischer Skandal. Wir freuen uns jedoch über jede Unterstützung und finden es deshalb gut, wenn auch Personen unterschreiben, die nicht wahlberechtigt sind.\n\n'
            'Eine Ausnahmeregelung gilt gemäß Wahlgesetz jedoch: '),
        'Wahlberechtigt sind alle Berliner*innen mit deutschem Pass, die mindestens drei Monate in Berlin gemeldet und mindestens 18 Jahre alt sind. Die Unterschriften eines großen Teils der Einwohner*innen Berlins, werden also für ungültig erklärt. Das ist unserer Meinung nach höchst undemokratisch und ein politischer Skandal. Wir freuen uns jedoch über jede Unterstützung und finden es deshalb gut, wenn auch Personen unterschreiben, die nicht wahlberechtigt sind.\n\n'
            'Eine Ausnahmeregelung gilt gemäß Wahlgesetz jedoch: "Personen, die nicht in einem Melderegister der Bundesrepublik Deutschland verzeichnet sind oder nicht seit drei Monaten vor dem Tag der Unterzeichnung im Melderegister in Berlin gemeldet sind, können das Volksbegehren ebenfalls unterzeichnen. Sie müssen mit der Unterzeichnung in einer amtlichen Auslegungsstelle oder im Bezirksamt durch Versicherung an Eides Statt gegenüber dem Bezirksamt glaubhaft machen, dass sie sich in den letzten drei Monaten überwiegend in Berlin aufgehalten haben.\n'
            'Erklärt eine zustimmungswillige Person, dass sie nicht schreiben kann, so ist die Eintragung von Amts wegen in einer amtlichen Auslegungsstelle oder im Bezirksamt unter Vermerk dieser Erklärung vorzunehmen".',
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
        'Wie kann ich mich in einem Kiezteam oder in der Initiative einbringen?',
        createTextElementWithLink('Mehr Infos übers Mitmachen und Kontakte zu den Kiezteams findest du unter: ', 'dwenteignen.de/mitmachen', 'https://www.dwenteignen.de/mitmachen'),
        'Mehr Infos übers Mitmachen und Kontakte zu den Kiezteams findest du unter: ',
        ['Mitmachen', 'Partizipation', 'Kiezteam']),
    FAQItem.short(
        8,
        'Wo gibt es Sammelmaterial?',
        createTextElementWithLink2(
            'Material kannst du im Kampagnenbüro in der Graefestr. 14 und bei einigen solidarischen Orten abholen. Unterschriftenlisten als .pdf zum selber ausdrucken findest du auf ',
            'dwenteignen.de',
            'https://www.dwenteignen.de',
            ' (Die Größe und das Format muss unbedingt beigehalten werden!).'),
        'Material kannst du im Kampagnenbüro in der Graefestr. 14 und bei einigen solidarischen Orten abholen. Unterschriftenlisten als .pdf zum selber ausdrucken findest du auf',
        ['Flyer', 'Material', 'Plakat', 'Broschüre', 'Zeitung']),
    FAQItem.short(
        9,
        'Gibt es eine Übersicht der solidarischen Orte?',
        createTextElementWithLink(
            'Ja unter: ',
            'https://sammeln.dwenteignen.de/pages/karte',
            'https://sammeln.dwenteignen.de/pages/karte'),
        'Ja unter',
        ['Solidarische Orte', 'wo']),
    FAQItem(
        10,
        'Wo kann unterschrieben werden?',
        Column(children: [
          Text(
              'Unterschrieben werden kann in jedem Berliner Bezirksamt, in einigen solidarischen Orten und bei unseren Sammler*innen auf der Straße.'),
          Text('Auslegungstage und Öffnungszeiten der Bürgerämter:\n\n'
              'Montag von 8 bis 15 Uhr\n'
              'Dienstag und Donnerstag von 11 bis 18 Uhr\n'
              'Mittwoch und Freitag von 8 bis 13 Uhr\n\n'
              'Mitte\n'
              'Bürgeramt Rathaus Mitte, Karl-Marx-Allee 31, 10178 Berlin\n\n'
              'Friedrichshain-Kreuzberg\n'
              'Bezirkswahlamt, Frankfurter Allee 35/37, 10247 Berlin\n\n'
              'Pankow\n'
              'Bürgeramt Weißensee, Berliner Allee 252 – 260, 13088 Berlin\n'
              'Bürgeramt Karow / Buch, Franz-Schmidt-Str. 8-10, 13125 Berlin\n'
              'Bürgeramt Prenzlauer Berg, Fröbelstraße 17, Haus 6, 10405 Berlin\n'
              'Bürgeramt Pankow, Breite Str. 24a – 26, 13187 Berlin\n\n'
              'Charlottenburg-Wilmersdorf\n'
              'Rathaus Charlottenburg, Otto-Suhr-Allee 100, 10585 Berlin, – Eingangshalle -\n\n'
              'Spandau\n'
              'Bürgeramt Rathaus, Carl-Schurz-Straße 2/6, 13597 Berlin\n'
              'Steglitz-Zehlendorf\n\n'
              'Bürgeramt Steglitz, Schloßstrasse 37, 12163 Berlin\n'
              'Bürgeramt Rathaus Zehlendorf, Kirchstraße 1/3 (Eingang Teltower Damm), 14163 Berlin\n'
              'Bürgeramt Lankwitz, Gallwitzallee 87 (Polizeigebäude, 1. OG), 12249 Berlin\n\n'
              'Tempelhof-Schöneberg\n'
              'Rathaus Schöneberg (im Inneren zwischen Ein- und Ausgang), John-F.-Kennedy-Platz, 10820 Berlin\n'
              'Bürgeramt Lichtenrade, Briesingstraße 6, 12307 Berlin\n\n'
              'Neukölln\n'
              'Bürgeramt 1, Rathaus Neukölln, Karl-Marx-Str. 83-85 (Eingang: Donaustr. 29), 12043 Berlin\n\n'
              'Treptow-Köpenick\n'
              'Rathaus Treptow, Neue Krugallee 4 – Pförtnerloge, 12435 Berlin\n'
              'Rathaus Köpenick, Alt-Köpenick 21 – Büro für Bürgerinnen- und Bürgerbeteiligung R.66, 12555 Berlin\n\n'
              'Marzahn-Hellersdorf\n'
              'Stadtteilbibliothek Kaulsdorf im Forum Kienberg, Neue Grottkauer Straße 5, 12619 Berlin\n'
              'Stadtteilbibliothek Erich Weinert, Helene-Weigel-Platz 4, 12681 Berlin\n'
              'Mittelpunktbibliothek Ehm Welk, Alte Hellersdorfer Straße 125, 12629 Berlin\n'
              'Bezirkszentralbibliothek Mark Twain (im Freizeitforum Marzahn), Marzahner Promenade 55, 12679 Berlin\n\n'
              'Lichtenberg\n'
              'Bürgeramt 1 – Neu-Hohenschönhausen, Egon-Erwin-Kisch-Str. 106, 13059 Berlin\n'
              'Bürgeramt 2 – Lichtenberg, Normannenstr. 1-2, 10367 Berlin\n\n'
              'Reinickendorf\n'
              'Bürgeramt Rathaus, Eichborndamm 215, 13437 Berlin\n'
              'Bürgeramt Reinickendorf-Ost, Teichstraße 65, 13407 Berlin\n'
              'Bürgeramt Tegel, Berliner Straße 35, 13507 Berlin\n'
              'Bürgeramt Heiligensee, Ruppiner Chaussee 268, 13503 Berlin')
        ]),
        Text(
            'Unterschrieben werden kann in jedem Berliner Bezirksamt, in einigen solidarischen Orten und bei unseren Sammler*innen auf der Straße.\n'
            'Auslegungstage und Öffnungszeiten der Bürgerämter:\n\n'),
        'Unterschrieben werden kann in jedem Berliner Bezirksamt, in einigen solidarischen Orten und bei unseren Sammler*innen auf der Straße.',
        [
          'wo',
          'Unterschriften',
          'unterschreiben',
          'Listen',
          'Orte',
          'Bürgeramt',
          'Bürgerämter',
          'Öffnungszeiten'
        ]),
    FAQItem.text(
        11,
        'Kann ich auch digital unterschreiben?',
        'Nein, laut Berliner Wahlgesetz sind nur handschriftliche Unterschriften gültig. Du kannst jedoch die Liste selbst ausdrucken, unterschreiben und an uns schicken (vgl. Punkt 8.).',
        ['digital', 'Internet', 'online', 'E-Mail', 'Mail']),
    FAQItem.text(
        12,
        'Was passiert mit meiner Unterschrift?',
        'Die Unterschriftenlisten werden der Landeswahlleitung zur Überprüfung auf Gültigkeit und Zählung übergeben. Sie werden nicht veröffentlicht oder an Dritte weitergegeben.',
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
    FAQItem.short(
        15,
        'Wie funktioniert Sammeln in Pandemiezeiten?',
        createTextElementWithLink(
            'Die Gesundheit aller Sammler*innen und Unterschreibenden ist uns sehr wichtig. Im Kampagnenbüro gibt es dafür kostenlose FFP2-Masken und Desinfektionsmittel. Unser Hygienekonzept findest du auf ',
            'dwenteignen.de',
            'https://www.dwenteignen.de'),
        'Die Gesundheit aller Sammler*innen und Unterschreibenden ist uns sehr wichtig. Im Kampagnenbüro gibt es dafür kostenlose FFP2-Masken und Desinfektionsmittel. Unser Hygienekonzept findest du auf ',
        ['Corona', 'Pandemie', 'Gesundheit']),
    FAQItem(
        16,
        'Wie kann ich mich stärker einbringen',
        Column(children: [
          Text(
              'Wenn du dich noch stärker in die Kampagne und Organisation einbringen willst, '
              'besuch doch eins unserer Kiezteams! Du erreichst sie per Mail:\n\n'),
          createMailElement('kiezteam_wilmersdorf@dwenteignen.de'),
          createMailElement('kiezteam_zehlendorfsteglitz@dwenteignen.de'),
          createMailElement('kiezteam_kreuzberg@dwenteignen.de'),
          createMailElement('kiezteam_suedneukoelln@dwenteignen.de'),
          createMailElement('kiezteam_suedneukoelln@dwenteignen.de'),
          createMailElement('kiezteam_suedneukoelln@dwenteignen.de'),
          createMailElement('kiezteam_wedding@dwenteignen.de'),
          createMailElement('kiezteam_lichtenberg@dwenteignen.de'),
          createMailElement('kiezteam_neukoelln@dwenteignen.de'),
          createMailElement('kiezteam_friedrichshain@dwenteignen.de'),
          createMailElement('kiezteam_tempelhofschoeneberg@dwenteignen.de'),
          createMailElement('kiezteam_charlottenburg@dwenteignen.de'),
          createMailElement('kiezteam_moabit@dwenteignen.de'),
          createMailElement('kiezteam_prenzlauerberg@dwenteignen.de'),
          createMailElement('kiezteam_treptow@dwenteignen.de'),
          createMailElement('kiezteam_spandau@dwenteignen.de'),
          createMailElement('kiezteam_pankow@dwenteignen.de'),
          createMailElement('kiezteam_mitte@dwenteignen.de'),
          createMailElement('kiezteam_marzahn@dwenteignen.de'),
          createMailElement('hochschulen@dwenteignen.de',
              text:
                  'hochschulen@dwenteignen.de (Mobilisierung an Hochschulen)'),
        ]),
        Text(
            'Wenn du dich noch stärker in die Kampagne und Organisation einbringen willst, '
            'besuch doch eins unserer Kiezteams! Du erreichst sie per Mail:'),
        'Wenn du dich noch stärker in die Kampagne und Organisation einbringen willst, '
            'besuch doch eins unserer Kiezteams! Du erreichst sie per Mail',
        ['Kiezteam', 'Mitmachen', 'Organisation', 'Kontakt']),
    FAQItem(
        17,
        'Welche Unternehmen sollen vergesellschaftet werden?',
        Text(
            'Vergesellschaftet werden die Berliner Bestände aller auf Profit ausgerichteten Immobilienkonzerne mit mehr als 3000 Wohnungen. Dazu gehören die Deutsche Wohnen, Vonovia, Akelius, Covivio, Heimstaden, Pears Global, TAG Immobilien, Grand City Properties, BGP Investment, ADO Properties, Deutsche Vermögens- und Immobilienverwaltungs GmbH (DVI), IMW Immobilien, und Blackstone, der Investmentfonds Phoenix Spree und möglicherweise die Familienstiftung Becker & Kries.'),
        Text(
            'Vergesellschaftet werden die Berliner Bestände aller auf Profit ausgerichteten Immobilienkonzerne mit mehr als 3000 Wohnungen. Dazu gehören die Deutsche Wohnen, Vonovia, ...'),
        'Vergesellschaftet werden die Berliner Bestände aller auf Profit ausgerichteten Immobilienkonzerne mit mehr als 3000 Wohnungen. Dazu gehören die Deutsche Wohnen, Vonovia, Akelius, Covivio, Heimstaden, Pears Global, TAG Immobilien, Grand City Properties, BGP Investment, ADO Properties, Deutsche Vermögens- und Immobilienverwaltungs GmbH (DVI), IMW Immobilien, und Blackstone, der Investmentfonds Phoenix Spree und möglicherweise die Familienstiftung Becker & Kries.',
        [
          'Enteignung',
          'Vergesellschaftung',
          'Konzern',
          'Immobilienkapital',
          'Spekulation',
          'Unternehmen'
        ]),
    FAQItem.short(
        18,
        "Video: Was kostet die Vergesellschaftung?",
        GestureDetector(
          onTap: () => launch('https://www.youtube.com/watch?v=oijmRknMXOI'),
          child: Center(
              child: Image.asset(
            'assets/images/dw_video_enteignen_bezahlen.png',
            fit: BoxFit.cover,
            height: 110.0,
          )),
        ),
        textWasKostetSieVergesellschaftung,
        [
          "Gewinn",
          "Einsparung",
          "Sozialleistung",
          "Arbeitslosengeld",
          "Sozialhilfe",
          "Wohngeld"
        ]),
    FAQItem(19, "10 Kurzargumente - Warum enteignen?", Text(textArgumente),
        Text(textArgumenteShort), textArgumente, [
      "hohe Mieten",
      "Sanierung",
      "Neubau",
      "Eigentum",
      "Wem gehört die Stadt",
      "Wohnungsknappheit",
      "Hauskauf",
      "Demokratie",
      "Modernisierung",
      "Wohnen",
      "Share Deals"
    ]),
    FAQItem(
        21,
        "Was kostet uns die Vergesellschaftung?",
        Text(textWasKostetSieVergesellschaftung),
        Text(textWasKostetDieVergesellschaftungShort),
        textWasKostetSieVergesellschaftung, [
      "Finanzierung",
      "Vergesellschaftung",
      "Entschädigung",
      "Kosten",
      "Milliarden",
      "Mieten",
      "Kredit"
    ]),
    FAQItem(
        22,
        'Ist die Vergesellschaftung rechtlich überhaupt möglich?',
        Text(argumentationTipps1),
        Text(argumentationTipps1Short),
        argumentationTipps1, [
      'Argumentationstipps',
      'Vergesellschaftung',
      'Gutachten',
      'Entschädigung'
    ]),
    FAQItem(
        23,
        'Warum eine Anstalt öffentlichen Rechts und keine neue landeseigene Wohnungsbaugesellschaft?',
        Text(textWarumAoerKeineWbg),
        Text(textWarumAoerKeineWbgShort),
        textWarumAoerKeineWbg, [
      "landeseigen",
      "kommunal",
      "Wohnungsbaugesellschaft",
      "AöR",
      "Anstalt öffentlichen Rechts",
      "demokratisch"
    ]),
    FAQItem(
        24,
        'Was ist eine Anstalt öffentlichen Rechts und warum wollen wir diese Form?',
        Text(textWarumAoer),
        Text(textWarumAoerShort),
        textWarumAoer, [
      'AöR',
      'Verstaatlichung',
      'Vergesellschaftung',
      'Anstalt',
      'öffentlichen',
      'Rechts',
      'demokratische',
      'Mitbestimmung',
      'Privatisierung',
      'Jobs',
      'Mitarbeiter'
    ]),
    FAQItem(25, "Was bringt die Vergesellschaftung für den Klimaschutz?",
        Text(textClimate), Text(textClimateShort), textClimate, [
      "Klima",
      "Umwelt",
      "ökologisch",
      "Modernisierung",
      "Energiewende",
      "demokratisch",
      "Anstalt öffentlichen Rechts"
    ]),
    FAQItem(
        26,
        "Warum soll die Vergesellschaftung Unternehmen erst ab 3000 Wohnungen in Berlin betreffen?",
        Text(textWarumErstAb3000),
        Text(textWarumErstAb3000Short),
        textWarumErstAb3000, [
      "3000",
      "Konzern",
      "Unternehmen",
      "Aktie",
      "Rendite",
      "Dividende",
      "Finanzmarkt"
    ]),
    FAQItem.text(
        27,
        "Werden alle Wohnungen enteignet oder erst ab 3000?",
        "Von den Unternehmen, die mehr als 3000 Wohnungen besitzen, werden alle Wohnungen enteignet und vergesellschaftet.",
        ["3000", "Wohnungen", "Unternehmen", "alle"]),
    FAQItem.text(
        28,
        "Könnten sich die Unternehmen nicht in verschiedene Tochtergesellschaften mit jeweils maximal 2999 Wohnungen aufspalten, um der Vergesellschaftung zu entgehen?",
        "Das ist ein häufiger Trick von Unternehmen, beispielsweise um Steuern zu umgehen. Wir werden aber bei einem Vergesellschaftungsgesetz die Gesamtkonzernebene in den Blick nehmen, inklusive aller Tochtergesellschaften.",
        [
          "Unternehmen",
          "3000",
          "Vergesellschaftung",
          "Tochterunternehmen",
          "Tochtergesellschaft",
          "aufspalten",
          "aufteilen"
        ]),
    FAQItem(
        29,
        "Was bringt uns die Vergesellschaftung finanziell?",
        Text(textVergesellschaftungFinanziell),
        Text(textVergesellschaftungFinanziellShort),
        textVergesellschaftungFinanziell, [
      "Gewinn",
      "Einsparung",
      "Sozialleistung",
      "Arbeitslosengeld",
      "Sozialhilfe",
      "Wohngeld"
    ]),
    FAQItem.text(
        30,
        "Warum ist keine nominelle / symbolische Entschädigung (also 1€ pro Unternehmen oder pro Wohnung) möglich?",
        "Eine nominelle Entschädigung würden wir uns mit Blick auf die enormen Gewinne von DW & Co in den letzten Jahren zwar wünschen, aber die Vergesellschaftung erfordert jedoch laut Art. 14 GG Abs. 3 eine Entschädigung. Eine nominelle Entschädigung wäre dabei juristisch kaum möglich und würde wahrscheinlich sofort per Gerichtsverfahren kassiert werden.",
        ["Entschädigung", "nominell", "symbolisch", "Vergesellschaftung"]),
    FAQItem.short(
        31,
        'Müssen die Mieter*innen infolge der Enteignung ausziehen?',
        Text(
            'Nein. Im Prinzip ändert sich nur ihre Vermieterin in die Anstalt öffentlichen Rechts (AöR) und ihre Mieten sinken.'),
        'Nein. Im Prinzip ändert sich nur ihre Vermieterin in die Anstalt öffentlichen Rechts (AöR) und ihre Mieten sinken.',
        ['Enteignung', 'Auszug', 'ausziehen', 'Wohnung', 'wechseln']),
    FAQItem(
        32,
        'Sammeltipps: Erste Ansprache',
        Text(sammelTipps1),
        Text(sammelTipps1Short),
        sammelTipps1,
        ["Sammeltipps", "ansprechen", "sammeln", "erster Satz", "Ansprache"]),
    FAQItem(33, 'Sammeltipps: Niedrigschwellig argumentieren',
        Text(sammelTipps3), Text(sammelTipps3Short), sammelTipps3, [
      "Sammeltipps",
      'Vergesellschaftung',
      'Mieten',
      'einfach',
      'formulieren'
    ]),
    FAQItem(
        34,
        "Gegenargument: „Es muss einfach mehr gebaut werden!“ ",
        Text(textCounterArgument1),
        Text(textCounterArgument1Short),
        textCounterArgument1, [
      "Gemeinwohl",
      "Neubau",
      "Eigentum",
      "Wohnungsmarkt",
      "Kapital",
      "Spekulation"
    ]),
    FAQItem(
        35,
        "Gegenargument: „Die Vergesellschaftung ist zu teuer und Berlin kann sich das nicht leisten.“ ",
        Text(textCounterArgument2),
        Text(textCounterArgument2Short),
        textCounterArgument2, [
      "Finanzierung",
      "Vergesellschaftung",
      "Entschädigung",
      "Kosten",
      "Kredit",
      "Vermögen",
      "Verlust",
      "Steuern",
      "Haushalt"
    ]),
    FAQItem(
        36,
        "Gegenargument: „Enteignungen – wie in der DDR!“ ",
        Text(textCounterArgument3),
        Text(textCounterArgument3Short),
        textCounterArgument3, [
      "Recht",
      "DDR",
      "Grundgesetz",
      "Sozialismus",
      "Sowjetunion",
      "Unrecht",
      "Verfassung",
      "Demokratie"
    ]),
    FAQItem(
        37,
        "Gegenargument: „Durch Enteignung entsteht keine einzige neue Wohnung.“ ",
        Text(textCounterArgument4),
        Text(textCounterArgument4Short),
        textCounterArgument4, [
      "Bauen",
      "Neubau",
      "Wohnungen",
      "Gemeinwohl",
      "Konzern",
      "Unternehmen",
      "Spekulation"
    ]),
    FAQItem(
        38,
        'Der Senat spricht aber von 36, später von 29 Milliarden Euro! Woher dieser Unterschied?',
        Text(textSenateNumbers),
        Text(textSenateNumbersShort),
        textSenateNumbers, [
      "Senat",
      "Kostenschätzung",
      "Finanzierung",
      "Vergesellschaftung",
      "Entschädigung",
      "Kosten",
      "Milliarden"
    ]),
    FAQItem.short(
        39,
        "Wo finde ich den Beschlusstext?",
        createTextElementWithLink2(
            beschlussText,
            "Link",
            "https://www.berlin.de/landesverwaltungsamt/_assets/logistikservice/amtsblatt-fuer-berlin/abl_2021_06_0365_0436_online.pdf",
            " (S. 367-371) einsehen."),
        beschlussText,
        ["Beschlusstext"]),
  ];

  static Text createTextElementWithLink(
      String text, String linkText, String link) {
    return Text.rich(
        TextSpan(text: text, children: [createLinkElement(linkText, link)]));
  }

  static Text createTextElementWithLink2(
      String text, String linkText, String link, String textAfterLink) {
    return Text.rich(TextSpan(text: text, children: [
      createLinkElement(linkText, link),
      TextSpan(text: textAfterLink)
    ]));
  }

  static TextSpan createLinkElement(String text, String link) {
    return TextSpan(
        text: text,
        style: TextStyle(
            color: Colors.indigo, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()..onTap = () => launch(link));
  }

  static Text createMailElement(String link, {String? text}) {
    return Text.rich(TextSpan(
        text: text ?? link,
        style: TextStyle(
            color: Colors.indigo, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () => launch('mailto:$link')));
  }

  static var anleitung = FAQItem(
      0,
      'Bedienungsanleitung',
      Column(children: [
        Text(
            'Mit dieser App, kannst du dich mit anderen Sammler*innen vernetzen, '
            'austauschen und zu Aktionen verabreden. Du kannst dich über den neusten'
            'Stand der Kampagne informieren, sowie Argumentationstipps und Hintergrund-'
            'Infos bekommen.\n\nWie das funktioniert kannst du hier nachlesen.\n'),
        Image.asset('assets/images/aktionen-seite.png', width: 250),
        Text(
            '\nIn der Startansicht werden dir alle anstehenden Aktionen aufgelistet. '
            'Über der "Jetzt"-Zeile stehen Aktionen, die bereits in der Vergangenheit liegen.\n'
            'Aktionen an denen du teilnimmst werden grün dargestellt, Aktionen, die '
            'du selbst erstellt hast blau.\nMithilfe der Filter-Funktion kannst '
            'du die Anzeige einschränken auf Ort, Zeit, Datum und Art der Aktion.\n'
            'Der Aktualisieren-Knopf lädt alle Aktionen erneut.\n'
            'Die Aktionen kannst du dir außerdem noch einmal in einer '
            'Karten-Ansicht anschauen. Dort siehst du auch die "Solidarischen Orte", '
            'an denen Unterschriftenlisten ausliegen.\n\n'
            'Wenn du auf eine Aktion tippst, öffnet sich ein Fenster, das die '
            'Details der Aktion anzeigt.\n'),
        Image.asset('assets/images/aktionen-details-seite.png', width: 250),
        Text('\nHier kannst du:\n'),
        Text('• deine Teilnahme an Aktionen ankündigen\n'
            '• Zum Aktions-Chat gelangen\n'
            '• deine Teilnahme an Aktionen absagen\n'
            '• die Aktion in deinen Handy-Kalender übertragen'
            '• die Aktion teilen und als Link verschicken, der die App öffnet un die Aktion anzeigt'
            '• Bericht zu vergangenen AKtionen abgeben (mit wichtigen Infos für die Kiezteams)\n'
            '• und eigene Aktionen bearbeiten\n'
            '• oder löschen\n'),
        Image.asset('assets/images/chat-seite.png', width: 250),
        Text(
            '\nTippst du auf den Chat-Knopf, gelangst du in den Aktions-Chat der '
            'Aktion und kannst dich mit den anderen Teilnehmer*innen austauschen. '
            'Beachte, dass du keine Nachrichten sehen kannst, von bevor du der '
            'Aktion beigetreten bist. Informiere also neue Teilnehmer*innen immer '
            'über Absprachen, die ihr getroffen habt.\n'
            'In der Chat-Ansicht kannst du auch die Liste der Aktions-Teilnehmer*innen'
            'sehen, mithilfe des Teilnehmer*innen-Knopfs oben rechts.\n'),
        Text(
            'Wenn du in der Startansicht auf den Menü-Knopf in der oberen rechten '
            'Ecke tippst, gelangst du zum Menü. Dort kannst du die weiteren Seiten:\n'
            '• Zum Sammeln aufrufen\n'
            '• Fragen und Antworten\n'
            '• Neuigkeiten und\n'
            '• Dein Profil\n'
            'besuchen.\n'),
        Text('Zum Sammeln aufrufen',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
            'Hier kannst du eigene Aktionen ins Leben rufen. Und das ist wichtig,'
            'denn wenn niemand Aktionen ausruft, kommen sie auch nicht zustande. \n'
            'Warte also am Besten nicht darauf dass andere Aktionen erzeugen, sondern'
            'rufe auch selbst zum Sammeln in deinem Kiez auf.'
            'Fülle dazu die Felder "Wo", "Wann", "Was" und "Wer" aus und tippe den "Fertig"-Button an.\n'
            'Andere Nutzer*innen werden dann ggf. über die neue Aktion informiert.\n'),
        Text('Fragen und Antworten',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
            'Hier bist du gerade ;)\nHier kannst du Argumentationshilfen und Tipps '
            'bekommen. Manche Beiträge lassens sich durch tippen erweitern. Mit '
            'der "Durchsuchen"-Funktion kannst du die Beiträge sortieren, um '
            'schneller die Antwort auf deine Frage zu finden.\n'),
        Text('Neuigkeiten', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Hier wirst du gelegentlich Nachrichten der Kampagne über neue'
            'Entwicklungen zu lesen bekommen. Also schau regelmäßig rein!\n'),
        Text('Dein Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Hier kannst du verschiedene Einstellungen vornehmen. Zum Beispiel'
            'kannst du die Sprache der App ändern oder dir einen Namen geben.\n\n'
            'Eine Besonderheit ist die Benachrichtigungsfunktion: Mit "Mein Kiez" '
            'kannst du auswählen zu welche Orten du über neue Aktionen informiert'
            'werden willst. Du kannst die Orte noch genauer auswählen, wenn du '
            'weiter heinein-zoomst.\n'
            'Mit dem Benachrichtigungs-Intervall kannst du einstellen, wir oft du '
            'informiert werden willst:\n'
            '• "sofort" bedeutet, du wirst in dem Moment informiert, in dem eine '
            'neue Aktion in deinem Kiez erstellt wurde\n'
            '• "täglich" bedeutet du bekommst jeden Abend eine Zusammenfassung neuer'
            'Aktionen in dienem Kiez\n'
            '• "wöchentlich" bedeutet du bekommst einmal pro Woche eine Zusammenfassung '
            'anstehenden Aktionen in deinem Kiez\n\n'),
        Text(
            'Wenn immer noch Fragen offen sind oder diese Anleitung unverständlich '
            'oder falsch ist, dann schreib uns doch an:'),
        RichText(
            text: TextSpan(
                text: 'app@dwenteignen.de',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.indigo,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launch('mailto:app@dwenteignen.de'))),
        Text('und mache Verbesserungsvorschläge. Viel Erfolg und Spaß!')
      ]),
      Text(
          'Mit dieser App, kannst du dich mit anderen Sammler*innen vernetzen, '
          'austauschen und zu Aktionen verabreden. Du kannst dich über den neusten'
          'Stand der Kampagne informieren, sowie Argumentationstipps und Hintergrund-'
          'Infos bekommen.\nWie das funktioniert kannst du hier nachlesen.\n\n'
          'Tippe auf diesen Eintrag um mehr zu lesen.'),
      'Mit dieser App, kannst du dich mit anderen Sammler*innen vernetzen, '
          'austauschen und zu Aktionen verabreden. Du kannst dich über den neusten'
          'Stand der Kampagne informieren, sowie Argumentationstipps und Hintergrund-'
          'Infos bekommen.\n\nWie das funktioniert kannst du hier nachlesen. '
          'In der Startansicht werden dir alle anstehenden Aktionen aufgelistet. '
          'Über der "Jetzt"-Zeile stehen Aktionen, die bereits in der Vergangenheit liegen.\n'
          'Aktionen an denen du teilnimmst werden grün dargestellt, Aktionen, die '
          'du selbst erstellt hast blau.\nMithilfe der Filter-Funktion kannst '
          'du die Anzeige einschränken auf Ort, Zeit, Datum und Art der Aktion.\n'
          'Der Aktualisieren-Knopf lädt alle Aktionen erneut.\n'
          'Die Aktionen kannst du dir außerdem noch einmal in einer '
          'Karten-Ansicht anschauen. Dort siehst du auch die "Solidarischen Orte", '
          'an denen Unterschriftenlisten ausliegen.\n\n'
          'Wenn du auf eine Aktion tippst, öffnet sich ein Fenster, das die '
          'Details der Aktion anzeigt. '
          'Hier kannst du:'
          '• deine Teilnahme an Aktionen ankündigen\n'
          '• Zum Aktions-Chat gelangen\n'
          '• deine Teilnahme an Aktionen absagen\n'
          '• die Aktion in deinen Handy-Kalender übertragen'
          '• die Aktion teilen und als Link verschicken, der die App öffnet un die Aktion anzeigt'
          '• Bericht zu vergangenen AKtionen abgeben (mit wichtigen Infos für die Kiezteams)\n'
          '• und eigene Aktionen bearbeiten\n'
          '• oder löschen '
          'Tippst du auf den Chat-Knopf, gelangst du in den Aktions-Chat der '
          'Aktion und kannst dich mit den anderen Teilnehmer*innen austauschen. '
          'Beachte, dass du keine Nachrichten sehen kannst, von bevor du der '
          'Aktion beigetreten bist. Informiere also neue Teilnehmer*innen immer '
          'über Absprachen, die ihr getroffen habt.\n'
          'In der Chat-Ansicht kannst du auch die Liste der Aktions-Teilnehmer*innen'
          'sehen, mithilfe des Teilnehmer*innen-Knopfs oben rechts. '
          'Wenn du in der Startansicht auf den Menü-Knopf in der oberen rechten '
          'Ecke tippst, gelangst du zum Menü. Dort kannst du die weiteren Seiten:\n'
          '• Zum Sammeln aufrufen\n'
          '• Fragen und Antworten\n'
          '• Neuigkeiten und\n'
          '• Dein Profil\n'
          'besuchen.\n'
          'Zum Sammeln aufrufen '
          'Hier kannst du eigene Aktionen ins Leben rufen. Und das ist wichtig,'
          'denn wenn niemand Aktionen ausruft, kommen sie auch nicht zustande. \n'
          'Warte also am Besten nicht darauf dass andere Aktionen erzeugen, sondern'
          'rufe auch selbst zum Sammeln in deinem Kiez auf.'
          'Fülle dazu die Felder "Wo", "Wann", "Was" und "Wer" aus und tippe den "Fertig"-Button an.\n'
          'Andere Nutzer*innen werden dann ggf. über die neue Aktion informiert.'
          'Fragen und Antworten '
          'Hier bist du gerade ;)\nHier kannst du Argumentationshilfen und Tipps '
          'bekommen. Manche Beiträge lassens sich durch tippen erweitern. Mit '
          'der "Durchsuchen"-Funktion kannst du die Beiträge sortieren, um '
          'schneller die Antwort auf deine Frage zu finden. '
          'Neuigkeiten '
          'Hier wirst du gelegentlich Nachrichten der Kampagne über neue'
          'Entwicklungen zu lesen bekommen. Also schau regelmäßig rein! '
          'Dein Profil '
          'Hier kannst du verschiedene Einstellungen vornehmen. Zum Beispiel'
          'kannst du die Sprache der App ändern oder dir einen Namen geben.\n\n'
          'Eine Besonderheit ist die Benachrichtigungsfunktion: Mit "Mein Kiez" '
          'kannst du auswählen zu welche Orten du über neue Aktionen informiert'
          'werden willst. Du kannst die Orte noch genauer auswählen, wenn du '
          'weiter heinein-zoomst.\n'
          'Mit dem Benachrichtigungs-Intervall kannst du einstellen, wir oft du '
          'informiert werden willst:\n'
          '• "sofort" bedeutet, du wirst in dem Moment informiert, in dem eine '
          'neue Aktion in deinem Kiez erstellt wurde\n'
          '• "täglich" bedeutet du bekommst jeden Abend eine Zusammenfassung neuer'
          'Aktionen in dienem Kiez\n'
          '• "wöchentlich" bedeutet du bekommst einmal pro Woche eine Zusammenfassung '
          'anstehenden Aktionen in deinem Kiez '
          'Wenn immer noch Fragen offen sind oder diese Anleitung unverständlich '
          'oder falsch ist, dann schreib uns doch an: '
          'app@dwenteignen.de '
          'und mache Verbesserungsvorschläge. Viel Erfolg und Spaß!',
      [
        'Funktionen',
        'Hilfe',
        'Fehler',
        'erstellen',
        'löschen',
        'feedback',
        'filter'
      ]);

  static List<FAQItem> loadItems(String? search) {
    if (search == null) search = '';

    if (search == '') {
      List<FAQItem> orderedItems =
          List<FAQItem>.of(items); // Kopie zum sortieren
      orderedItems.sort((item1, item2) => item1.id < item2.id ? -1 : 1);
      return orderedItems;
    }

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
          }
        }
      });
    });

    // Suche im Titel
    searchWords.forEach((word) {
      items.forEach((item) {
        if (item.title.toLowerCase().contains(word))
          // Titel-Treffer haben mittleres Gewicht
          weight[item] = weight[item]! + 10;
      });
    });

    // Suche im Text
    searchWords.forEach((word) {
      items.forEach((item) {
        if (item.plainText.toLowerCase().contains(word))
          // niedriges Gewicht für Text-Treffer
          weight[item] = weight[item]! + 1;
      });
    });

    List<FAQItem> orderedItems = List<FAQItem>.of(items); // Kopie zum sortieren
    orderedItems.sort((item1, item2) =>
        Comparable.compare(weight[item1]!, weight[item2]!) * -1);

    return orderedItems;
  }
}
