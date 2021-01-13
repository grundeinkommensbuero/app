import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

class ConstJsonAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String _, Locale locale) async {
    print('Lade Sprache für ${locale.languageCode***REMOVED***');
    var translation = languages[locale.languageCode];
    return translation;
  ***REMOVED***
***REMOVED***

const Map<String, Map<String, dynamic>> languages = {'en': en, 'de': de***REMOVED***

const Map<String, dynamic> en = {
  "Liste": "List",
  "Karte": "Map",
  "Sammeln": "Collection",
  "Infoveranstaltung": "Information event",
  "Workshop": "Workshop",
  "Unbekannter Nachrichtentyp abgespeichert": "Unknown message type saved",
  "{kiez***REMOVED*** in {bezirk***REMOVED***\n ⛒ Treffpunkt: {treffpunkt***REMOVED***":
      "{kiez***REMOVED*** in {bezirk***REMOVED***\n ⛒ meeting point: {treffpunkt***REMOVED***",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***":
      "Unreadable push notification (participation) received: {message***REMOVED***",
  "Ein paar Worte über dich": "A few words about yourself",
  "Beschreibung: {beschreibung***REMOVED***": "Description: {***REMOVED***",
  "Beschreibe die Aktion kurz": "Briefly describe the event",
  "Wähle die Art der Aktion": "Choose the event type",
  "von ": "from ",
  " bis ": " to ",
  "Wähle eine Uhrzeit": "Choose a time",
  "Jetzt": "Now",
  "Hier liegen öffentliche Unterschriften-Listen aus. Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\nFrage doch mal die Betreiber*innen deines Lieblings-Spätis!\n":
      "Public signature lists are displayed here. You can place signature lists in public places like cafes, bars, or shops. It’s important, however, that you regularly pick up the filled-out lists.\nAsk the owners of your favourite Spätis if you can leave one there!\n",
  "Du kannst den Ort eintragen auf:\n": "You can record the place at:\n",
  "Nachricht eingeben...": "Enter message…",
  "Jemand": "Someone",
  " ist der Aktion beigetreten": " has joined the event",
  " hat die Aktion verlassen": " has left the event",
  "\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen":
      "\nNew participants can’t read older messages",
  "gerade eben": "just now",
  "{***REMOVED*** Minuten": {
    "zero": "{***REMOVED*** Minutes",
    "one": "{***REMOVED*** Minute",
    "two": "{***REMOVED*** Minutes",
    "other": "{***REMOVED*** Minutes"
  ***REMOVED***,
  "{***REMOVED*** Stunden": {
    "zero": "{***REMOVED*** Hours",
    "one": "{***REMOVED*** Hour",
    "two": "{***REMOVED*** Hours",
    "other": "{***REMOVED*** Hours"
  ***REMOVED***,
  "Teilnehmer*innen": "Participants",
  "Keine Teilnehmer*innen": "No participants",
  "{count***REMOVED*** Teilnehmer*innen im Chat": "{count***REMOVED*** participants in chat",
  "+ {count***REMOVED*** weitere Teilnehmer*innen": "+ {count***REMOVED*** other participants",
  "Neue Chat-Nachricht": "New chat message",
  "Öffne die App um sie zu lesen": "Open the app to read",
  "Durchsuchen": "Browse",
  "Anwenden": "Use",
  "Aktualisieren": "Update",
  "alle Tage,": "all days,",
  "Alle Aktions-Arten,": "All event types,",
  "jederzeit": "all times",
  "überall": "everywhere",
  "Wähle Aktions-Arten": "Choose the type of event",
  "Fertig": "Finished",
  "Treffpunkt": "Meeting point",
  "Wähle auf der Karte einen Treffpunkt aus.":
      "Choose a meeting point on the map.",
  "Du kannst eine eigene Beschreibung angeben, z.B. \"Unter der Weltzeituhr\" oder \"Tempelhofer Feld, Eingang Kienitzstraße\":":
      "You can provde your own description, e.g. \"Under the Weltzeituhr\" or \"Tempelhofer Feld, 'Kienitzstraße entrance\"",
  "Abbrechen": "Cancel",
  "Aktionen": "Events",
  "Aktionen in einer Liste oder Karte anschauen":
      "See the events in a list or on the map",
  "Zum Sammeln aufrufen": "Call people to a collection event",
  "Zum Sammeln einladen": "Invite people to a collection event",
  "Fragen und Antworten": "Questions and answers",
  "Dein Profil": "Your profile",
  "Eine Sammel-Aktion ins Leben rufen": "Create a collection event",
  "Tipps und Argumente": "Tips and arguments",
  "Tipps, Tricks und Argumentationshilfen": "Argument tips and tricks",
  "Profil": "Profile",
  "Dein Name, dein Kiez und deine Einstellungen":
      "Your name, your area and your preferences",
  "sofort": "now",
  "täglich": "daily",
  "wöchentlich": "weekly",
  "nie": "never",
  "Sprache": "Language",
  "Dein Name": "Your name",
  "Dein Kiez": "Your area",
  "Mit deinen Kiezen bestimmst du wo du über neue Aktionen informiert werden willst.":
      "By choosing areas you decide which new events you’ll be notified about.",
  "Deine Benachrichtigungen": "Your notifications",
  "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?":
      "How often do you want to be notified about new collection events events in your area?",
  "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?":
      "How often do you want to be told about upcoming events?",
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\\n\\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "This app was developed by a small team of enthusiastic IT activists for Deutsche Wohnen & Co Enteignen and is under free license.\\n\\nIf you are interested in using the app for your own campaign, just write us an email or visit our website. You can also let us know about problems or errors with the app",
  "Heute, ": "Today, ",
  "Morgen, ": "Tomorrow, ",
  "{prefix***REMOVED***{date***REMOVED*** um {zeit***REMOVED*** Uhr, ": "{prefix***REMOVED***{date***REMOVED*** at {zeit***REMOVED*** o’clock, ",
  "Aktionen konnten nicht geladen werden.": "Event could not be loaded.",
  "Aktion konnte nicht angelegt werden": "Event could not be displayed",
  "Okay...": "Okay...",
  "Zum Chat": "To chat",
  "Schließen": "Close",
  "Aktion konnte nicht geladen werden.": "Event could not be loaded.",
  "Mitmachen": "Participate",
  "Absagen": "Cancel",
  "Deine Aktion bearbeiten": "Work on your action",
  "Aktion konnte nicht gespeichert werden.": "Event could not be saved.",
  "Aktion konnte nicht gelöscht werden.": "Event could not be deleted.",
  "Aktion konnte nicht erzeugt werden.": "Event could not be generated.",
  "Aktion Löschen": "Delete event",
  "Möchtest du diese Aktion wirklich löschen?":
      "Do you really want to delete this event?",
  "Ja": "Yes",
  "Nein": "No",
  "Es scheint keine Internet-Verbindung zu bestehen.":
      "It looks like you’re not connected to the internet.",
  "Die Internet-Verbindung scheint sehr langsam zu sein.":
      "Your internet connection seems pretty slow.",
  "Der Server antwortet leider nicht. Möglicherweise ist er überlastet, versuch es doch später nochmal":
      "The server isn’t answering. It could be overloaded, so please try again later.",
  "Ein Verbindungsproblem ist aufgetreten: ":
      "A connection problem has occurred: ",
  "Der Server hat leider gerade technische Probleme: ":
      "Unfortunately the server is having technical problems: ",
  "Der Server reagiert nicht, obwohl eine Internet-Verbindung besteht. Vielleicht gibt es ein technisches Problem, bitte versuch es später nochmal. ":
      "The serving isn’t responding, even though there is an internet connection. There may be a technical problem. Please try again later. ",
  "Das Internet scheint nicht erreichbar zu sein: ":
      "It looks like the internet isn’t available ",
  "Es ist ein Fehler aufgetreten beim Verifizieren deines Benutzer*in-Accounts. Probiere es eventuell zu einem späteren Zeitpunkt noch einmal oder versuche die App nochmal neu zu installieren, wenn du keine eigenen Aktionen betreust.":
      "An error has occurred while verifying your user account. Please try again later or reinstall the app if you don’t have any events of your own saved.",
  "SSL-Zertifikat konnte nicht geladen werden":
      "SSL-certificate could not be loaded",
  "Deine App-Version ist veraltet. Dies ist die Version {version***REMOVED***, du musst aber mindestens Version {minClient***REMOVED*** benutzen, damit die App richtig funktioniert.":
      "Your version of the app is out-of-date. This is version {version***REMOVED***. You need to use at {minClient***REMOVED*** or later, for the app to work properly.",
  "Falsches Format": "Wrong format",
  "Listen-Orte konnten nicht geladen werden.":
      "List of locations could not be loaded.",
  "Teilnahmen und Absagen": "Participation and cancelation",
  "Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst":
      "Notifications about other participants at events you’re taking part in",
  "Änderungen an Aktionen": "Changes to an event",
  "Änderungen an Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst":
      "Changes to notifications when events you’re participating in have changed or been canceled.",
  "Aktionen-Chats": "Event chats",
  "Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst":
      "Notifications about new chat messages about events you’re taking part in",
  "Infos": "Info",
  "Allgemeine Infos": "General info",
  "Nachricht von {name***REMOVED***": "Message from {name***REMOVED***",
  "Problem beim Einrichten von Push-Nachrichten":
      "Error when opening a push message",
  "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.":
      "A connection to the Google Push service could not be established. That can happen if, for example, a Google-free operating system is being used, in which case the app can only receive notifications while it’s open.",
  "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert":
      "An error occurred when retrieving messages. Regular message retrieval has been disabled",
  "Fehler beim Anmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Error logging in to notifications about {topics***REMOVED***",
  "Fehler beim Abmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Error logging out from notifications about {topics***REMOVED***",
  "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.":
      "At least one recipient needs to be chosen for push messages to another device.",
  "Push-Nachricht an Geräte konnte nicht versandt werden":
      "Push notifications could not be sent to the device",
  "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.":
      "For push notifications about topics, you need to enter a topic",
  "Push-Nachricht an Thema konnte nicht versandt werden":
      "Push notification about a theme could not be sent",
  "Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.":
      "For push notifications about events, you need to enter the Event ID.",
  "Push-Nachricht an Aktion konnte nicht versandt werden.":
      "Push notification about event could not be sent.",
  "Teilnahme ist fehlgeschlagen.": "Participation failed.",
  "Absage ist fehlgeschlagen.": "Cancelation failed.",
  "Neue Aktionen": "New events",
  "Gelöschte Aktionen": "Deleted events",
  "Eine neue Benutzer*in wird angelegt.": "A new user has been created.",
  "Anlegen einer neuen Benutzer*in ist gescheitert.":
      "Creation of a new user has failed.",
  "Benutzer*indaten konnte nicht überprüft werden.":
      "User data could not be checked.",
  "Benutzer*in-Name konnte nicht geändert werden.":
      "Username could not be changed.",
  "Bezirke oder Kieze auswählen": "Choose the area or borough",
  "Mo": "Mon",
  "Di": "Tue",
  "Mi": "Wed",
  "Do": "Thu",
  "Fr": "Fri",
  "Sa": "Sat",
  "So": "Sun",
  "Startzeit": "Start time",
  "Endzeit": "End time",
  "Weiter": "Next",
  "Keine Auswahl": "No selection",
  "Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben":
      "To perform this action you need to give yourself a username",
  "am {tage***REMOVED***,": "on {tage***REMOVED***,",
  "Auswählen": "Select",
  "Auswahl übernehmen": "Apply selection",
  "Das Volksbegehren lebt von deiner Beteiligung! \n":
      "Das Volksbegehren lebt von deiner Beteiligung! \n",
  "Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.":
      "Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.",
  "Kontakt": "Kontakt",
  "Hier kannst du ein paar Worte über dich verlieren, \nvor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. \nBeachte dass alle Sammler*innen deine Angaben lesen können.":
      "Hier kannst du ein paar Worte über dich verlieren, \nvor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. \nBeachte dass alle Sammler*innen deine Angaben lesen können.",
  "Beschreibung": "Beschreibung",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw":
      "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw",
  "Wähle einen Tag": "Wähle einen Tag",
  "am ": "am ",
  "Gib einen Treffpunkt an": "Gib einen Treffpunkt an",
  "Wann?": "Wann?",
  "Wo?": "Wo?",
  "Was?": "Was?",
  "Wer?": "Wer?",
  "Benutzer*in-Name": "Benutzer*in-Name"
***REMOVED***

const Map<String, dynamic> de = {
  "Liste": "Liste",
  "Karte": "Karte",
  "Sammeln": "Sammeln",
  "Infoveranstaltung": "Infoveranstaltung",
  "Workshop": "Workshop",
  "Unbekannter Nachrichtentyp abgespeichert":
      "Unbekannter Nachrichtentyp abgespeichert",
  "{kiez***REMOVED*** in {bezirk***REMOVED***\n ⛒ Treffpunkt: {treffpunkt***REMOVED***":
      "{kiez***REMOVED*** in {bezirk***REMOVED***\n ⛒ Treffpunkt: {treffpunkt***REMOVED***",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***":
      "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***",
  "Ein paar Worte über dich": "Ein paar Worte über dich",
  "Beschreibung: {beschreibung***REMOVED***": "Beschreibung: {***REMOVED***",
  "Beschreibe die Aktion kurz": "Beschreibe die Aktion kurz",
  "Wähle die Art der Aktion": "Wähle die Art der Aktion",
  "von ": "von ",
  " bis ": " bis ",
  "Wähle eine Uhrzeit": "Wähle eine Uhrzeit",
  "Jetzt": "Jetzt",
  "Hier liegen öffentliche Unterschriften-Listen aus. Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\nFrage doch mal die Betreiber*innen deines Lieblings-Spätis!\n":
      "Hier liegen öffentliche Unterschriften-Listen aus. Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\nFrage doch mal die Betreiber*innen deines Lieblings-Spätis!\n",
  "Du kannst den Ort auf ": "Du kannst den Ort auf ",
  " eintragen.": " eintragen.",
  "Du kannst den Ort eintragen auf:\n": "Du kannst den Ort eintragen auf:\n",
  "Nachricht eingeben...": "Nachricht eingeben...",
  "Jemand": "Jemand",
  " ist der Aktion beigetreten": " ist der Aktion beigetreten",
  " hat die Aktion verlassen": " hat die Aktion verlassen",
  "\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen":
      "\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen",
  "gerade eben": "gerade eben",
  "{***REMOVED*** Minuten": {
    "zero": "{***REMOVED*** Minuten",
    "one": "{***REMOVED*** Minute",
    "two": "{***REMOVED*** Minuten",
    "other": "{***REMOVED*** Minuten"
  ***REMOVED***,
  "{***REMOVED*** Stunden": {
    "zero": "{***REMOVED*** Stunden",
    "one": "{***REMOVED*** Stunde",
    "two": "{***REMOVED*** Stunden",
    "other": "{***REMOVED*** Stunden"
  ***REMOVED***,
  "Teilnehmer*innen": "Teilnehmer*innen",
  "Keine Teilnehmer*innen": "Keine Teilnehmer*innen",
  "{count***REMOVED*** Teilnehmer*innen im Chat": "{count***REMOVED*** Teilnehmer*innen im Chat",
  "+ {count***REMOVED*** weitere Teilnehmer*innen": "+ {count***REMOVED*** weitere Teilnehmer*innen",
  "Neue Chat-Nachricht": "Neue Chat-Nachricht",
  "Öffne die App um sie zu lesen": "Öffne die App um sie zu lesen",
  "Durchsuchen": "Durchsuchen",
  "Anwenden": "Anwenden",
  "Aktualisieren": "Aktualisieren",
  "alle Tage,": "alle Tage,",
  "Alle Aktions-Arten,": "Alle Aktions-Arten,",
  "jederzeit": "jederzeit",
  "überall": "überall",
  "Wähle Aktions-Arten": "Wähle Aktions-Arten",
  "Fertig": "Fertig",
  "Treffpunkt": "Treffpunkt",
  "Wähle auf der Karte einen Treffpunkt aus.":
      "Wähle auf der Karte einen Treffpunkt aus.",
  "Du kannst eine eigene Beschreibung angeben, z.B. \"Unter der Weltzeituhr\" oder \"Tempelhofer Feld, Eingang Kienitzstraße\":":
      "Du kannst eine eigene Beschreibung angeben, z.B. \"Unter der Weltzeituhr\" oder \"Tempelhofer Feld, 'Eingang Kienitzstraße\"",
  "Abbrechen": "Abbrechen",
  "Aktionen": "Aktionen",
  "Aktionen in einer Liste oder Karte anschauen":
      "Aktionen in einer Liste oder Karte anschauen",
  "Zum Sammeln aufrufen": "Zum Sammeln aufrufen",
  "Zum Sammeln einladen": "Zum Sammeln einladen",
  "Fragen und Antworten": "Fragen und Antworten",
  "Dein Profil": "Dein Profil",
  "Eine Sammel-Aktion ins Leben rufen": "Eine Sammel-Aktion ins Leben rufen",
  "Tipps und Argumente": "Tipps und Argumente",
  "Tipps, Tricks und Argumentationshilfen":
      "Tipps, Tricks und Argumentationshilfen",
  "Profil": "Profil",
  "Dein Name, dein Kiez und deine Einstellungen":
      "Dein Name, dein Kiez und deine Einstellungen",
  "sofort": "sofort",
  "täglich": "täglich",
  "wöchentlich": "wöchentlich",
  "nie": "nie",
  "Sprache": "Sprache",
  "Dein Name": "Dein Name",
  "Dein Kiez": "Dein Kiez",
  "Mit deinen Kiezen bestimmst du wo du über neue Aktionen informiert werden willst.":
      "Mit deinen Kiezen bestimmst du wo du über neue Aktionen informiert werden willst.",
  "Deine Benachrichtigungen": "Deine Benachrichtigungen",
  "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?":
      "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?",
  "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?":
      "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?",
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\\n\\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\\n\\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.",
  "Heute, ": "Heute, ",
  "Morgen, ": "Morgen, ",
  "{prefix***REMOVED***{date***REMOVED*** um {zeit***REMOVED*** Uhr, ": "{prefix***REMOVED***{date***REMOVED*** um {zeit***REMOVED*** Uhr, ",
  "Aktionen konnten nicht geladen werden.":
      "Aktionen konnten nicht geladen werden.",
  "Aktion konnte nicht angelegt werden": "Aktion konnte nicht angelegt werden",
  "Okay...": "Okay...",
  "Zum Chat": "Zum Chat",
  "Schließen": "Schließen",
  "Aktion konnte nicht geladen werden.": "Aktion konnte nicht geladen werden.",
  "Mitmachen": "Mitmachen",
  "Absagen": "Absagen",
  "Deine Aktion bearbeiten": "Deine Aktion bearbeiten",
  "Aktion konnte nicht gespeichert werden.":
      "Aktion konnte nicht gespeichert werden.",
  "Aktion konnte nicht gelöscht werden.":
      "Aktion konnte nicht gelöscht werden.",
  "Aktion konnte nicht erzeugt werden.": "Aktion konnte nicht erzeugt werden.",
  "Aktion Löschen": "Aktion Löschen",
  "Möchtest du diese Aktion wirklich löschen?":
      "Möchtest du diese Aktion wirklich löschen?",
  "Ja": "Ja",
  "Nein": "Nein",
  "Es scheint keine Internet-Verbindung zu bestehen.":
      "Es scheint keine Internet-Verbindung zu bestehen.",
  "Die Internet-Verbindung scheint sehr langsam zu sein.":
      "Die Internet-Verbindung scheint sehr langsam zu sein.",
  "Der Server antwortet leider nicht. Möglicherweise ist er überlastet, versuch es doch später nochmal":
      "Der Server antwortet leider nicht. Möglicherweise ist er überlastet, versuch es doch später nochmal",
  "Ein Verbindungsproblem ist aufgetreten: ":
      "Ein Verbindungsproblem ist aufgetreten: ",
  "Der Server hat leider gerade technische Probleme: ":
      "Der Server hat leider gerade technische Probleme: ",
  "Der Server reagiert nicht, obwohl eine Internet-Verbindung besteht. Vielleicht gibt es ein technisches Problem, bitte versuch es später nochmal. ":
      "Der Server reagiert nicht, obwohl eine Internet-Verbindung besteht. Vielleicht gibt es ein technisches Problem, bitte versuch es später nochmal. ",
  "Das Internet scheint nicht erreichbar zu sein: ":
      "Das Internet scheint nicht erreichbar zu sein: ",
  "Es ist ein Fehler aufgetreten beim Verifizieren deines Benutzer*in-Accounts. Probiere es eventuell zu einem späteren Zeitpunkt noch einmal oder versuche die App nochmal neu zu installieren, wenn du keine eigenen Aktionen betreust.":
      "Es ist ein Fehler aufgetreten beim Verifizieren deines Benutzer*in-Accounts. Probiere es eventuell zu einem späteren Zeitpunkt noch einmal oder versuche die App nochmal neu zu installieren, wenn du keine eigenen Aktionen betreust.",
  "SSL-Zertifikat konnte nicht geladen werden":
      "SSL-Zertifikat konnte nicht geladen werden",
  "Deine App-Version ist veraltet. Dies ist die Version {version***REMOVED***, du musst aber mindestens Version {minClient***REMOVED*** benutzen, damit die App richtig funktioniert.":
      "Deine App-Version ist veraltet. Dies ist die Version {version***REMOVED***, du musst aber mindestens Version {minClient***REMOVED*** benutzen, damit die App richtig funktioniert.",
  "Falsches Format": "Falsches Format",
  "Listen-Orte konnten nicht geladen werden.":
      "Listen-Orte konnten nicht geladen werden.",
  "Teilnahmen und Absagen": "Teilnahmen und Absagen",
  "Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst":
      "Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst",
  "Änderungen an Aktionen": "Änderungen an Aktionen",
  "Änderungen an Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst":
      "Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst",
  "Aktionen-Chats": "Aktionen-Chats",
  "Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst":
      "Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst",
  "Infos": "Infos",
  "Allgemeine Infos": "Allgemeine Infos",
  "Nachricht von {name***REMOVED***": "Nachricht von {name***REMOVED***",
  "Problem beim Einrichten von Push-Nachrichten":
      "Problem beim Einrichten von Push-Nachrichten",
  "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.":
      "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.",
  "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert":
      "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert",
  "Fehler beim Anmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Fehler beim Anmelden der Benachrichtigungen zu {topics***REMOVED***",
  "Fehler beim Abmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Fehler beim Abmelden der Benachrichtigungen zu {topics***REMOVED***",
  "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.":
      "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.",
  "Push-Nachricht an Geräte konnte nicht versandt werden":
      "Push-Nachricht an Geräte konnte nicht versandt werden",
  "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.":
      "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.",
  "Push-Nachricht an Thema konnte nicht versandt werden":
      "Push-Nachricht an Thema konnte nicht versandt werden",
  "Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.":
      "Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.",
  "Push-Nachricht an Aktion konnte nicht versandt werden.":
      "Push-Nachricht an Aktion konnte nicht versandt werden.",
  "Teilnahme ist fehlgeschlagen.": "Teilnahme ist fehlgeschlagen.",
  "Absage ist fehlgeschlagen.": "Absage ist fehlgeschlagen.",
  "Neue Aktionen": "Neue Aktionen",
  "Gelöschte Aktionen": "Gelöschte Aktionen",
  "Eine neue Benutzer*in wird angelegt.":
      "Eine neue Benutzer*in wird angelegt.",
  "Anlegen einer neuen Benutzer*in ist gescheitert.":
      "Anlegen einer neuen Benutzer*in ist gescheitert.",
  "Benutzer*indaten konnte nicht überprüft werden.":
      "Benutzer*indaten konnte nicht überprüft werden.",
  "Benutzer*in-Name konnte nicht geändert werden.":
      "Benutzer*in-Name konnte nicht geändert werden.",
  "Bezirke oder Kieze auswählen": "Bezirke oder Kieze auswählen",
  "Mo": "Mo",
  "Di": "Di",
  "Mi": "Mi",
  "Do": "Do",
  "Fr": "Fr",
  "Sa": "Sa",
  "So": "So",
  "Startzeit": "Startzeit",
  "Endzeit": "Endzeit",
  "Weiter": "Weiter",
  "Keine Auswahl": "Keine Auswahl",
  "Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben":
      "Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben",
  "am {tage***REMOVED***,": "am {tage***REMOVED***,",
  "Auswählen": "Auswählen",
  "Auswahl übernehmen": "Auswahl übernehmen",
  "Das Volksbegehren lebt von deiner Beteiligung! \n":
      "Das Volksbegehren lebt von deiner Beteiligung! \\n",
  "Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.":
      "Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.",
  "Kontakt": "Kontakt",
  "Hier kannst du ein paar Worte über dich verlieren, \nvor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. \nBeachte dass alle Sammler*innen deine Angaben lesen können.":
      "Hier kannst du ein paar Worte über dich verlieren, \nvor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. \nBeachte dass alle Sammler*innen deine Angaben lesen können.",
  "Beschreibung": "Beschreibung",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw":
      "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw",
  "Wähle einen Tag": "Wähle einen Tag",
  "am ": "am ",
  "Gib einen Treffpunkt an": "Gib einen Treffpunkt an",
  "Wann?": "Wann?",
  "Wo?": "Wo?",
  "Was?": "Was?",
  "Wer?": "Wer?",
  "Benutzer*in-Name": "Benutzer*in-Name"
***REMOVED***
