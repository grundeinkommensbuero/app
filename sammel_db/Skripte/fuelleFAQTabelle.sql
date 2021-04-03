insert into FAQ (id, inhalt) values (1,
'{"titel": "Wann geht''s los?",
"teaser": [
    {"type": "text", "content": "Am 26. Februar ist Sammelbeginn."***REMOVED******REMOVED***
],
"rest": [],
"order": 1.0,
"tags": ["Start","Beginn","Sammelphase"]***REMOVED***'
)
insert into FAQ (id, inhalt) values (2,
'{"titel": "Wie lange wird gesammelt?",
"teaser": [
    {"type": "text", "content": "Die Sammelphase geht vom 26. Februar bis 25. Juni 2021, also vier Monate. Dieser Zeitraum ist nicht verlängerbar."***REMOVED******REMOVED***
],
"rest": [],
"order": 1.0,
"tags": ["Start","Beginn","Sammelphase"]***REMOVED***'
)
insert into FAQ (id, inhalt) values (5,
'{"titel": "Wessen Unterschrift ist gültig?",
"teaser": [
    {"type": "text", "content": "Wahlberechtigt sind alle Berliner*innen mit deutschem Pass, die mindestens drei Monate in Berlin gemeldet und mindestens 18 Jahre alt sind. Die Unterschriften eines großen Teils der Einwohner*innen Berlins, werden also für ungültig erklärt. Das ist unserer Meinung nach höchst undemokratisch und ein politischer Skandal. Wir freuen uns jedoch über jede Unterstützung und finden es deshalb gut, wenn auch Personen unterschreiben, die nicht wahlberechtigt sind."***REMOVED***,
    {"type": "paragraph"***REMOVED***,
    {"type": "text", "content": "Eine Ausnahmeregelung gilt gemäß Wahlgesetz jedoch: "Personen, die nicht in einem Melderegister der Bundesrepublik Deutschland verzeichnet sind oder nicht seit drei Monaten vor dem Tag der Unterzeichnung im Melderegister in Berlin gemeldet sind, können das Volksbegehren ebenfalls unterzeichnen. Sie müssen mit der Unterzeichnung in einer amtlichen Auslegungsstelle oder im Bezirksamt durch Versicherung an Eides Statt gegenüber dem Bezirksamt glaubhaft machen, dass sie sich in den letzten drei Monaten überwiegend in Berlin aufgehalten haben."***REMOVED***,
    {"type": "text", "content": "''Erklärt eine zustimmungswillige Person, dass sie nicht schreiben kann, so ist die Eintragung von Amts wegen in einer amtlichen Auslegungsstelle oder im Bezirksamt unter Vermerk dieser Erklärung vorzunehmen''."***REMOVED***,
    {"type": "text", "content": "Wahlberechtigt sind alle Berliner*innen mit deutschem Pass, die mindestens drei Monate in Berlin gemeldet und mindestens 18 Jahre alt sind. Die Unterschriften eines großen Teils der Einwohner*innen Berlins, werden also für ungültig erklärt. Das ist unserer Meinung nach höchst undemokratisch und ein politischer Skandal. Wir freuen uns jedoch über jede Unterstützung und finden es deshalb gut, wenn auch Personen unterschreiben, die nicht wahlberechtigt sind."***REMOVED***,
    {"type": "paragraph"***REMOVED***,
    {"type": "text", "content": "Eine Ausnahmeregelung gilt gemäß Wahlgesetz jedoch: "***REMOVED***,
],
"rest": [],
"order": 5.0,
"tags": ["Start","Beginn","Sammelphase"]***REMOVED***'
)

update FAQ set inhalt =
'{"titel": "Wann geht''s los?",
"teaser": [
    {"type": "text", "content": "Am 26. Februar ist Sammelbeginn."***REMOVED******REMOVED***
],
"rest": [],
"order": 1.0,
"tags": ["Start","Beginn","Sammelphase"]***REMOVED***'
where id = 1
)