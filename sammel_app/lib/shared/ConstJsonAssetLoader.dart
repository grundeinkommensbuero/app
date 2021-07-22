import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

class ConstJsonAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>?> load(String _, Locale locale) async =>
      languages[locale.languageCode];
***REMOVED***

const Map<String, Map<String, dynamic>> languages = {
  'en': en,
  'de': de,
  'ru': ru,
  'fr': fr,
***REMOVED***

const Map<String, dynamic> en = {
  "Liste": "List",
  "Karte": "Map",
  "Sammeln": "Collection",
  "Infoveranstaltung": "Information event",
  "Workshop": "Workshop",
  "Unbekannter Nachrichtentyp abgespeichert": "Unknown message type saved",
  "{kiez***REMOVED*** in {bezirk***REMOVED***\n Treffpunkt: {treffpunkt***REMOVED***":
      "{kiez***REMOVED*** in {bezirk***REMOVED***\n meeting point: {treffpunkt***REMOVED***",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***":
      "Unreadable push notification (participation) received: {message***REMOVED***",
  "Ein paar Worte über dich": "A few words about yourself",
  "Beschreibung: {beschreibung***REMOVED***": "Description: {beschreibung***REMOVED***",
  "Beschreibe die Aktion kurz": "Briefly describe the event",
  "Wähle die Art der Aktion": "Choose the event type",
  "von ": "from ",
  " bis ": " to ",
  "Wähle eine Uhrzeit": "Choose a time",
  "Jetzt": "Now",
  "Hier liegen öffentliche Unterschriften-Listen aus. Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\nFrage doch mal die Betreiber*innen deines Lieblings-Spätis!\n":
      "Public signature lists are displayed here. You can place signature lists in public places like cafes, bars, or shops. It’s important, however, that you regularly pick up the filled-in lists.\nAsk the owners of your favourite Spätis if you can leave one there!\n",
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
  "Anwenden": "Apply",
  "Aktualisieren": "Update",
  "alle Tage,": "any day,",
  "Alle Aktions-Arten,": "All event types,",
  "jederzeit": "all times",
  "überall": "everywhere",
  "Wähle Aktions-Art": "Choose the event type",
  "Fertig": "Finish",
  "Treffpunkt": "Meeting point",
  "Wähle auf der Karte einen Treffpunkt aus.":
      "Choose a meeting point on the map.",
  "Du kannst eine eigene Beschreibung angeben, z.B. \"Unter der Weltzeituhr\" oder \"Tempelhofer Feld, Eingang Kienitzstraße\":":
      "You can provde your own description, e.g. \"Under the Weltzeituhr\" or \"Tempelhofer Feld, 'Kienitzstraße entrance\"",
  "Abbrechen": "Cancel",
  "Aktionen": "Events",
  "Aktionen in einer Liste oder Karte anschauen":
      "See the events in a list or on the map",
  "Zum Sammeln einladen": "Set up a signature drive",
  "Fragen und Antworten": "Questions and Answers",
  "Dein Profil": "Your profile",
  "Eine Sammel-Aktion ins Leben rufen":
      "Invite others to go collecting with you",
  "Tipps und Argumente": "Tips and arguments",
  "Tipps, Tricks und Argumentationshilfen": "Argument tips and tricks",
  "Profil": "Profile",
  "Dein Name, dein Kiez und deine Einstellungen":
      "Your name, your area and your preferences",
  "sofort": "immediately",
  "täglich": "daily",
  "wöchentlich": "weekly",
  "nie": "never",
  "Sprache": "Language",
  "Dein Name": "Your name",
  "Dein Kiez": "Your area",
  "Mit deiner Kiez-Auswahl bestimmst du für welche Gegenden du über neue Aktionen informiert werden willst.":
      "By choosing areas you decide which new events you’ll be notified about.",
  "Deine Benachrichtigungen": "Your notifications",
  "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?":
      "How often do you want to be notified about new collection events in your area?",
  "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?":
      "How often do you want to be told about upcoming events?",
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\n\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "This app was developed by a small team of enthusiastic IT activists for Deutsche Wohnen & Co Enteignen and is under free license.\\n\\nIf you are interested in using the app for your own campaign, just write us an email or visit our website. You can also let us know about problems or errors with the app.",
  "Heute, ": "Today, ",
  "Morgen, ": "Tomorrow, ",
  "{prefix***REMOVED***{date***REMOVED*** um {zeit***REMOVED*** Uhr, ": "{prefix***REMOVED***{date***REMOVED*** at {zeit***REMOVED*** o’clock, ",
  "Aktionen konnten nicht geladen werden.": "Event could not be loaded.",
  "Aktion konnte nicht angelegt werden": "Event could not be displayed",
  "Okay...": "Okay...",
  "Zum Chat": "Go to chat",
  "Schließen": "Close",
  "Aktion konnte nicht geladen werden.": "Event could not be loaded.",
  "Mitmachen": "Participate",
  "Verlassen": "Leave",
  "Deine Aktion bearbeiten": "Edit your action",
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
      "Your version of the app is out-of-date. This is version {version***REMOVED***. You need to use at least {minClient***REMOVED*** or later for the app to work properly.",
  "Falsches Format": "Wrong format",
  "Listen-Orte konnten nicht geladen werden.":
      "List of locations could not be loaded.",
  "Teilnahmen und Absagen": "Participations and cancellations",
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
      "The referendum thrives on your participation! \n",
  "Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.":
      "If you can't find a suitable collection event, invite others to collect signatures together. Others can see your call to collect and join in. You can edit or delete the event at any time.",
  "Kontakt": "Contact",
  "Hier kannst du ein paar Worte über dich verlieren, \nvor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. \nBeachte dass alle Sammler*innen deine Angaben lesen können.":
      "You can say a few words about yourself here, \nespecially how to contact you so that others can arrange to collect signatures with you. \nMake sure that all collectors can read your information.",
  "Beschreibung": "Description",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw":
      "Briefly describe the event. Where do you want to collect signatures? What should the other collectors bring along? Can they join you later? etc.",
  "Wähle einen Tag": "Choose a day",
  "am ": "on ",
  "Gib einen Treffpunkt an": "Specify a meeting point",
  "Wann?": "When?",
  "Wo?": "Where?",
  "Was?": "What?",
  "Wer?": "Who?",
  "Benutzer*in-Name": "Username",
  "Anzahl Unterschriften": "Number of signatures",
  "Dauer": "Duration",
  "Situation": "Situation",
  "Spaßfaktor": "Fun factor",
  "Erzähl uns, was ihr erreicht habt! \n": "Tell us what you accomplished! \n",
  "Deine Rückmeldung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.":
      "Your feedback helps your Kiez Team identify the most effective collection events. Other Teams can also learn from your experiences.",
  "Anzahl Deiner Unterschriften": "Number of signatures",
  "Wie viele Leute waren bei der Aktion dabei?":
      "How many people participated in the event?",
  "Wie viele Unterschriften hast Du persönlich gesammelt?":
      "How many signatures did you personally collect?",
  "Wie fandest Du die Aktion?": "How did you like the event?",
  "sehr cool": "very cool",
  "gut": "good",
  "ganz okay": "okay",
  "mäßig": "mediocre",
  "doof": "dumb",
  "Wie viele Stunden habt ihr gesammelt?":
      "How many hours did you spend collecting?",
  "Wie viele Stunden warst Du sammeln?":
      "How many hours did you personally spend collecting?",
  "Auf die nächste halbe Stunde gerundet": "Round to the next half hour",
  "Wie viel hast Du gesammelt?": "How many did you collect?",
  "Anzahl Teilnehmer*innen": "Number of participants",
  "Anmerkungen": "Notes",
  "Kommentar": "Comments",
  "Optional: Sonstige Anmerkungen zu den Daten?":
      "Optional: Other notes on the information?",
  "Anmerkungen:": "Notes:",
  "Optional: Muss man noch etwas zu den Angaben wissen?":
      "Optional: Is there anything else you should share about the above data?",
  "Wie war die Situation? (Wetter, Veranstaltung in der Nähe, besonderer Anlass, ...)":
      "How was the situation? (weather, events in the area, a special occasion, ...)",
  "Situation:": "Situation:",
  "Optional: Wie war die Situation?": "Optional: How was the situation?",
  "Erzähl uns, was ihr erreicht habt!\n": " Tell us what you accomplished!\n",
  "{***REMOVED*** Unterschriften": {
    "zero": "{***REMOVED*** signatures",
    "one": "{***REMOVED*** signature",
    "two": "{***REMOVED*** signatures",
    "other": "{***REMOVED*** signatures"
  ***REMOVED***,
  "{***REMOVED*** Teilnehmer": {
    "zero": "{***REMOVED*** participants",
    "one": "{***REMOVED*** participants",
    "two": "{***REMOVED*** participants",
    "other": "{***REMOVED*** participants"
  ***REMOVED***,
  "News": "News",
  "Neues vom Volksbegehren und der Kampagne":
      "News from the referendum and the campaign",
  "Datenschutz": "Privacy",
  "Deine Daten": "Your Data",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.":
      "All the data you put into the app will be stored exclusively at system of the Deutsche Wohnen & Co. Enteignen campaign and will only be used for the purpose of this app and the campaign. Please take into account that many of the data that you input can be read by other users of this app. Chat messages can only be viewed by participants of the chat at message time. \nFor push notification functionality we depend on Google and Apple delivering infrastructure. Data that are transported this way are being encrypted. If you want us to remove all personal data you input please mail us at app@dwenteignen.de.",
  "Okay": "Okay",
  "deutsch": "deutsch",
  "englisch": "english",
  "": "",
  "Hier kannst du ein paar Worte über dich verlieren, vor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. Beachte dass alle Sammler*innen deine Angaben lesen können.":
      "You can say a few things about yourself here. It's especially helpful to say how to contact you. Please be aware that all users can read this information.",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammler*innen mitbringen? Kann man auch später dazustoßen?":
      "Add a short description of the drive. Where will you go collect, what should others bring, is it possible to join later?",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de":
      "All the data you put into the app will be stored exclusively at system of the Deutsche Wohnen & Co. Enteignen campaign and will only be used for the purpose of this app and the campaign. Please take into account that many of the data that you input can be read by other users of this app. Chat messages can only be viewed by participants of the chat at message time. \nFor push notification functionality we depend on Google and Appla delivering infrastructure. Data that are transported this way are being encrypted. If you want us to remove all personal data you input please mail us at app@dwenteignen.de",
  "Zu viele Tage": "Too many dates",
  "Bitte wähle {maxTage***REMOVED*** Tage oder weniger aus.":
      "Please select {maxTage***REMOVED*** days or fewer.",
  "Benachrichtigungs-Einstellungen": "Notification Configurations",
  "Benachrichtigungen einstellen": "Configure Notifications",
  "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe einfach lange auf eine Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
      "If you want to change Notifications to silent or disable certain notification categories, just long press a received notification. You will then be guided to the notification preferences for this app.",
  "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe auf die drei Punkte in einer Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
      "If you want to change Notifications to silent or disable certain notification categories, just press the three dots on a received notification. You will then be guided to the notification preferences for this app.",
  "Danke!": "Thanks!",
  "Vielen Dank, dass Du Eure Erfahrungen geteilt hast.":
      "Thanks for sharing your experiences.",
  "Plakatieren": "Placard",
  "Löschen": "Delete",
  "Bearbeiten": "Edit",
  "diese Aktion ist beendet": "this event has been finished",
  "Dein Bericht zu einer Aktion fehlt noch":
      "We're missing your feedback for an action",
  "Berichten": "Feedback",
  "Zur Aktion": "Go to action",
  "Über Aktion berichten": "Report on the action",
  "Kundgebung": "Manifestation",
  "eigene": "own",
  "Nur eigene Aktionen anzeigen": "Only show my actions",
  "Eigene Aktionen immer anzeigen": "Always show my actions",
  "Eigene Aktionen": "Own actions",
  "lade...": "loading...",
  "Na gut": "Allright",
  "In den Kalender": "Add to Calendar",
  '{typ***REMOVED*** in {ortsteil***REMOVED***': '{typ***REMOVED*** at {ortsteil***REMOVED***',
  "Teilen": "Share",
  '{typ***REMOVED*** in {ortsteil***REMOVED***, {treffpunkt***REMOVED*** am {zeitpunkt***REMOVED***\n{url***REMOVED***':
      '{typ***REMOVED*** in {ortsteil***REMOVED***, {treffpunkt***REMOVED*** at {zeitpunkt***REMOVED***\n{url***REMOVED***',
  'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.':
      'The action could not been found. Maybe it has been deleted.',
  'Ein Fehler ist aufgetreten': 'An error occured',
***REMOVED***

const Map<String, dynamic> ru = {
  "Liste": "Список",
  "Karte": "Карта",
  "Sammeln": "Собрать подписи",
  "Infoveranstaltung": "Информационное мероприятие",
  "Workshop": "Семинар",
  "Unbekannter Nachrichtentyp abgespeichert":
      "Сохранено сообщение неизвестного типа",
  "{kiez***REMOVED*** in {bezirk***REMOVED***\n Treffpunkt: {treffpunkt***REMOVED***":
      "{kiez***REMOVED*** в {bezirk***REMOVED***\n место встречи: {treffpunkt***REMOVED***",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***":
      "Принято нечитаемое Push-сообщение (участие): {message***REMOVED***",
  "Ein paar Worte über dich": "Несколько слов о тебе",
  "Beschreibung: {beschreibung***REMOVED***": "Описание: {beschreibung***REMOVED***",
  "Beschreibe die Aktion kurz": "Кратко опиши акцию",
  "Wähle die Art der Aktion": "Выбери вид акции",
  "von ": "с ",
  " bis ": " по ",
  "Wähle eine Uhrzeit": "Выбери время",
  "Jetzt": "Сейчас",
  "Hier liegen öffentliche Unterschriften-Listen aus. Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\nFrage doch mal die Betreiber*innen deines Lieblings-Spätis!\n":
      "Здесь выложены публичные списки подписей. Ты сам(а) можешь выкладывать списки подписей в общественных местах, например, в кафе, барах или магазинах. Важно, чтобы ты регулярно забирал(а) заполненные списки.\nНо сначала спроси разрешение у владельцев твоих любых ночных магазинов!\n",
  "Du kannst den Ort auf ": "Ты можешь место в ",
  " eintragen.": " записать.",
  "Du kannst den Ort eintragen auf:\n": "Ты можешь записать место в:\n",
  "Nachricht eingeben...": "Ввести сообщение...",
  "Jemand": "Кто-то",
  " ist der Aktion beigetreten": " присоединился к акции",
  " hat die Aktion verlassen": " покинул акцию",
  "\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen":
      "\nНовые участники не могут читать старые сообщения",
  "gerade eben": "только что",
  "{***REMOVED*** Minuten": {
    "zero": "{***REMOVED*** минут",
    "one": "{***REMOVED*** минута",
    "two": "{***REMOVED*** минуты",
    "other": "{***REMOVED*** мин. "
  ***REMOVED***,
  "{***REMOVED*** Stunden": {
    "zero": "{***REMOVED*** часов",
    "one": "{***REMOVED*** час",
    "two": "{***REMOVED*** часа",
    "other": "{***REMOVED*** час."
  ***REMOVED***,
  "Teilnehmer*innen": "Участники",
  "Keine Teilnehmer*innen": "Участников нет",
  "{count***REMOVED*** Teilnehmer*innen im Chat": "{count***REMOVED*** участников в чате",
  "+ {count***REMOVED*** weitere Teilnehmer*innen": "+ еще {count***REMOVED*** участников",
  "Neue Chat-Nachricht": "Новое сообщение в чате",
  "Öffne die App um sie zu lesen": "Открой приложение, чтобы прочитать",
  "Durchsuchen": "Просмотреть",
  "Anwenden": "Применить",
  "Aktualisieren": "Обновить",
  "alle Tage,": "все дни,",
  "Alle Aktions-Arten,": "Все виды акций,",
  "jederzeit": "в любое время",
  "überall": "везде",
  "Wähle Aktions-Art": "Выбери виды акций",
  "Fertig": "Готово",
  "Treffpunkt": "Место встречи",
  "Wähle auf der Karte einen Treffpunkt aus.": "Выбери на карте место встречи.",
  "Du kannst eine eigene Beschreibung angeben, z.B. \"Unter der Weltzeituhr\" oder \"Tempelhofer Feld, Eingang Kienitzstraße\":":
      "Ты можешь дать собственное описание, например \"Под часами мира\" или \"Темпельхофер Фельд, 'Выход на Киницштрассе\"",
  "Abbrechen": "Отменить",
  "Aktionen": "Акции",
  "Aktionen in einer Liste oder Karte anschauen":
      "Посмотреть акции в списке или на карте",
  "Zum Sammeln einladen": "Пригласить на сбор подписей",
  "Fragen und Antworten": "Вопросы и ответы",
  "Dein Profil": "Твой профиль",
  "Eine Sammel-Aktion ins Leben rufen": "Создать акцию по сбору подписей",
  "Tipps und Argumente": "Советы и аргументы",
  "Tipps, Tricks und Argumentationshilfen":
      "Советы, приемы и подсказки по аргументации",
  "Profil": "Профиль",
  "Dein Name, dein Kiez und deine Einstellungen":
      "Твое имя, твой район и твои настройки",
  "sofort": "немедленно",
  "täglich": "ежедневно",
  "wöchentlich": "еженедельно",
  "nie": "никогда",
  "Sprache": "Язык",
  "Dein Name": "Твое имя",
  "Dein Kiez": "Твой район",
  "Mit deiner Kiez-Auswahl bestimmst du für welche Gegenden du über neue Aktionen informiert werden willst.":
      "Указывая свой район, ты выбираешь местности, о новых акциях в которых ты хочешь получать информацию.",
  "Deine Benachrichtigungen": "Твои уведомления",
  "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?":
      "Как часто ты хочешь получать информацию о новых акциях по сбору подписей, которые проводятся в твоем районе, и насколько актуальными должны быть акции?",
  "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?":
      "Как часто ты хочешь получать информацию о предстоящих акциях?",
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.":
      "Данное приложение было разработано небольшой командой энтузиастов из ИТ-индустрии для кампании «Национализируем Deutsche Wohnen & Co («Дойче Вонен унд Ко»)» и распространяется по свободной лицензии.\\n\\nЕсли ты заинтересован в использовании данного приложения для целей твоей народной инициативы, то просто напиши нам на электронную почту или посети наш сайт. По этим же каналам ты можешь сообщать нам об ошибках в приложении и о связанных с ним проблемах.",
  "Heute, ": "Сегодня, ",
  "Morgen, ": "Завтра, ",
  "{prefix***REMOVED***{date***REMOVED*** um {zeit***REMOVED*** Uhr, ": "{prefix***REMOVED***{date***REMOVED*** в {zeit***REMOVED***, ",
  "Aktionen konnten nicht geladen werden.": "Не удалось загрузить акции.",
  "Aktion konnte nicht angelegt werden": "Не удалось создать акцию",
  "Okay...": "Хорошо...",
  "Zum Chat": "В чат",
  "Schließen": "Закрыть",
  "Aktion konnte nicht geladen werden.": "Не удалось загрузить акцию.",
  "Mitmachen": "Участвовать",
  "Verlassen": "Уйти",
  "Deine Aktion bearbeiten": "Править твою акцию",
  "Aktion konnte nicht gespeichert werden.": "Не удалось сохранить акцию.",
  "Aktion konnte nicht gelöscht werden.": "Не удалось удалить акцию.",
  "Aktion konnte nicht erzeugt werden.": "Не удалось сформировать акцию.",
  "Aktion Löschen": "Удалить акцию",
  "Möchtest du diese Aktion wirklich löschen?":
      "Ты действительно хочешь удалить эту акцию?",
  "Ja": "Да",
  "Nein": "Нет",
  "Es scheint keine Internet-Verbindung zu bestehen.":
      "Кажется, пропало соединение с интернетом.",
  "Die Internet-Verbindung scheint sehr langsam zu sein.":
      "Кажется, соединение с интернетом слишком медленное.",
  "Der Server antwortet leider nicht. Möglicherweise ist er überlastet, versuch es doch später nochmal":
      "К сожалению, сервер не отвечает. Возможно, он перегружен, повтори попытку позднее",
  "Ein Verbindungsproblem ist aufgetreten: ":
      "Возникла проблема с соединением: ",
  "Der Server hat leider gerade technische Probleme: ":
      "К сожалению, на сервере сейчас технические проблемы: ",
  "Der Server reagiert nicht, obwohl eine Internet-Verbindung besteht. Vielleicht gibt es ein technisches Problem, bitte versuch es später nochmal. ":
      "Сервер не реагирует, хотя соединение с интернетом установлено. Возможно, возникла техническая проблема, повтори попытку позднее. ",
  "Das Internet scheint nicht erreichbar zu sein: ":
      "Кажется, отсутствует доступ к интернету: ",
  "Es ist ein Fehler aufgetreten beim Verifizieren deines Benutzer*in-Accounts. Probiere es eventuell zu einem späteren Zeitpunkt noch einmal oder versuche die App nochmal neu zu installieren, wenn du keine eigenen Aktionen betreust.":
      "При проверке подлинности твоей учетной записи пользователя возникла проблема. Повтори попытку позднее или переустанови приложение, если ты не курируешь собственные акции.",
  "SSL-Zertifikat konnte nicht geladen werden":
      "Не удалось загрузить SSL-сертификат",
  "Deine App-Version ist veraltet. Dies ist die Version {version***REMOVED***, du musst aber mindestens Version {minClient***REMOVED*** benutzen, damit die App richtig funktioniert.":
      "Используемая тобой версия приложения устарела. Это версия {version***REMOVED***, но для правильной работы приложения необходимо использовать как минимум версию {minClient***REMOVED***.",
  "Falsches Format": "Неверный формат",
  "Listen-Orte konnten nicht geladen werden.":
      "Не удалось загрузить внесенные в списки места.",
  "Teilnahmen und Absagen": "Участия и отказы",
  "Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst":
      "Уведомления о сторонниках акций, в которых ты участвуешь",
  "Änderungen an Aktionen": "Изменения акций",
  "Änderungen an Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst":
      "Уведомления в случае изменения акций либо отказа от акций, в которых ты участвуешь",
  "Aktionen-Chats": "Чаты акций",
  "Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst":
      "Уведомления о новых сообщениях в чатах акций, в которых ты участвуешь",
  "Infos": "Информация",
  "Allgemeine Infos": "Общие сведения",
  "Nachricht von {name***REMOVED***": "Сообщение от {name***REMOVED***",
  "Problem beim Einrichten von Push-Nachrichten":
      "Проблема с настройкой Push-сообщений",
  "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.":
      "Не удалось установить соединения со службой Push-уведомлений Google. Так бывает в случае использования операционной системы, не привязанной к Google. Поэтому приложение может принимать уведомления, только когда оно открыто.",
  "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert":
      "При извлечении сообщений произошла ошибка. В связи с этим регулярное извлечение сообщений отключено",
  "Fehler beim Anmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Ошибка при подписке на уведомления по {topics***REMOVED***",
  "Fehler beim Abmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Ошибка при отписке от уведомлений по {topics***REMOVED***",
  "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.":
      "Для отправки Push-сообщений на устройства должен быть указан хотя бы один получатель.",
  "Push-Nachricht an Geräte konnte nicht versandt werden":
      "Не удалось отправить Push-сообщение на устройства",
  "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.":
      "Для отправки Push-сообщений в темы должна быть указана тема.",
  "Push-Nachricht an Thema konnte nicht versandt werden":
      "Не удалось отправить Push-сообщение в тему",
  "Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.":
      "Для отправки Push-сообщений в акции должен быть указан идентификатор акции.",
  "Push-Nachricht an Aktion konnte nicht versandt werden.":
      "Не удалось отправить Push-сообщение в акцию.",
  "Teilnahme ist fehlgeschlagen.": "Произошел сбой участия.",
  "Absage ist fehlgeschlagen.": "Произошел сбой отказа.",
  "Neue Aktionen": "Новые акции ",
  "Gelöschte Aktionen": "Удаленные акции",
  "Eine neue Benutzer*in wird angelegt.": "Создается новый пользователь.",
  "Anlegen einer neuen Benutzer*in ist gescheitert.":
      "Не удалось создать нового пользователя.",
  "Benutzer*indaten konnte nicht überprüft werden.":
      "Не удалось проверить данные пользователя.",
  "Benutzer*in-Name konnte nicht geändert werden.":
      "Не удалось изменить имя пользователя.",
  "Bezirke oder Kieze auswählen": "Выбрать районы или кварталы",
  "Mo": "пн.",
  "Di": "вт.",
  "Mi": "ср.",
  "Do": "чт.",
  "Fr": "пт.",
  "Sa": "сб.",
  "So": "вс.",
  "Startzeit": "Время начала",
  "Endzeit": "Время окончания",
  "Weiter": "Дальше",
  "Keine Auswahl": "Выбор отсутствует",
  "Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben":
      "Для выполнения данной акции ты должен завести себе имя пользователя",
  "am {tage***REMOVED***,": " {tage***REMOVED***,",
  "Auswählen": "Выбрать",
  "Auswahl übernehmen": "Применить выбор",
  "Das Volksbegehren lebt von deiner Beteiligung! \n":
      "Народная инициатива невозможна без твоего участия! \n",
  "Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.":
      "Если ты не можешь найти подходящую акцию по сбору подписей, то пригласи других на совместный сбор подписей. Другие могут видеть твой призыв к сбору подписей и принимать участие. Ты можешь в любой момент редактировать акцию или удалить её.",
  "Kontakt": "Контакт",
  "Hier kannst du ein paar Worte über dich verlieren, \nvor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. \nBeachte dass alle Sammler*innen deine Angaben lesen können.":
      "Здесь ты можешь кратко рассказать о себе, \nв первую очередь, как с тобой можно связаться, чтобы другие могли договориться с тобой о сборе подписей. \nОбрати внимание, что все сборщики могут ознакомиться с твоими данными.",
  "Beschreibung": "Описание",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw":
      "Приведи краткое описание акции. Куда ты хочешь отправиться за подписями, что должны принести с собой другие сборщики? Можно ли присоединиться позднее и т.п.",
  "Wähle einen Tag": "Выбери день",
  "am ": " ",
  "Gib einen Treffpunkt an": "Укажи место встречи",
  "Wann?": "Когда?",
  "Wo?": "Где?",
  "Was?": "Что?",
  "Wer?": "Кто?",
  "News": "Новости",
  "Neues vom Volksbegehren und der Kampagne":
      "Новое о народной инициативе и кампании",
  "Benutzer*in-Name": "Имя пользователя",
  "Anzahl Unterschriften": "Количество подписей",
  "Dauer": "Длительность",
  "Situation": "Обстановка",
  "Spaßfaktor": "Фактор развлечения",
  "Erzähl uns, was ihr erreicht habt! \n":
      "Расскажи нам о вашем результате! \n",
  "Deine Rückmeldung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.":
      "Твой отклик поможет команде твоего квартала выявлять наиболее эффективные акции по сбору подписей. Кроме того, вы поделитесь опытом с другими командами.",
  "Anzahl Deiner Unterschriften": "Количество твоих подписей",
  "Wie viele Leute waren bei der Aktion dabei?": "Сколько людей было на акции?",
  "Wie viele Unterschriften hast Du persönlich gesammelt?":
      "Сколько подписей ты лично собрал?",
  "Wie fandest Du die Aktion?": "Как, по-твоему, прошла акция?",
  "sehr cool": "очень круто",
  "gut": "хорошо",
  "ganz okay": "вполне нормально",
  "mäßig": "посредственно",
  "doof": "по-дурацки",
  "Wie viele Stunden habt ihr gesammelt?": "Сколько часов вы собирали подписи?",
  "Wie viele Stunden warst Du sammeln?": "Сколько часов ты собирал(а) подписи?",
  "Auf die nächste halbe Stunde gerundet":
      "Если округлить до ближайшего получаса",
  "Wie viel hast Du gesammelt?": "Сколько ты собрал(а)?",
  "Anzahl Teilnehmer*innen": "Количество участников ",
  "Anmerkungen": "Примечания",
  "Kommentar": "Комментарий",
  "Optional: Sonstige Anmerkungen zu den Daten?":
      "Опционально: Прочие примечания по данным?",
  "Anmerkungen: ": "Примечания: ",
  "Optional: Muss man noch etwas zu den Angaben wissen?":
      "Опционально: По данным нужно что-то ещё знать?",
  "Wie war die Situation? (Wetter, Veranstaltung in der Nähe, besonderer Anlass, ...)":
      "Какой была обстановка? (погода, мероприятие поблизости, особый повод, ...)",
  "Situation: ": "Обстановка: ",
  "Optional: Wie war die Situation?": "Опционально: Какой была обстановка?",
  "Erzähl uns, was ihr erreicht habt!\n": "Расскажи нам о вашем результате!\n",
  "{***REMOVED*** Unterschriften": {
    "zero": "{***REMOVED*** подписей",
    "one": "{***REMOVED*** подпись",
    "two": "{***REMOVED*** подписи",
    "others": "{***REMOVED*** другое",
  ***REMOVED***,
  "{***REMOVED*** Teilnehmer": {
    "zero": "{***REMOVED*** участников",
    "one": "{***REMOVED*** участник",
    "two": "{***REMOVED*** участника",
    "other": "{***REMOVED*** другое"
  ***REMOVED***,
  "Datenschutz": "Защита данных",
  "Deine Daten": "Твои данные",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an e@mail.com.":
      "Все данные, которые ты вводишь в приложение, хранятся исключительно на системах кампании «Национализируем Deutsche Wohnen & Co («Дойче Вонен унд Ко»)» и используются только в целях, связанных с приложением и кампанией. Но обращаем твое внимание на то, что другие пользователи могут читать многие из тех данных, которые ты вводишь в приложение. Сообщения в чате могут быть прочитаны только всеми участниками чата в момент появления сообщения.\n\nДля того чтобы была доступна функция Push-сообщений, мы вынуждены использовать инфраструктуру доставки сообщений, предоставляемую компанией Google и, в соответствующих случаях, компанией Apple. Передаваемые при этом данные передаются в зашифрованном виде. Если ты хочешь, чтобы все введенные тобой персональные данные были удалены, сообщи нам об этом по адресу: e@mail.com.",
  "Okay": "Хорошо",
  "Zu viele Tage": "Слишком большое количество дней",
  "Bitte wähle {maxTage***REMOVED*** Tage oder weniger aus.":
      "Выбери не больше {maxTage***REMOVED*** дней или меньшее количество дней.",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.":
      "Все данные, которые ты вводишь в приложение, хранятся исключительно на системах кампании «Национализируем Deutsche Wohnen & Co («Дойче Вонен унд Ко»)» и используются только в целях, связанных с приложением и кампанией. Но обращаем твое внимание на то, что другие пользователи могут читать многие из тех данных, которые ты вводишь в приложение. Сообщения в чате могут быть прочитаны только всеми участниками чата в момент появления сообщения.\n\nДля того чтобы была доступна функция Push-сообщений, мы вынуждены использовать инфраструктуру доставки сообщений, предоставляемую компанией Google и, в соответствующих случаях, компанией Apple. Передаваемые при этом данные передаются в зашифрованном виде. Если ты хочешь, чтобы все введенные тобой персональные данные были удалены, сообщи нам об этом по адресу: app@dwenteignen.de.",
  "deutsch": "немецкий язык",
  "englisch": "английский язык",
  "": "",
  "Hier kannst du ein paar Worte über dich verlieren, vor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. Beachte dass alle Sammler*innen deine Angaben lesen können.":
      "Здесь ты можешь кратко рассказать о себе, в первую очередь, как с тобой можно связаться, чтобы другие могли договориться с тобой о сборе подписей. Обрати внимание, что все сборщики подписей могут ознакомиться с твоими данными.",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammler*innen mitbringen? Kann man auch später dazustoßen?":
      "Приведи краткое описание акции. Куда ты хочешь отправиться за подписями, что должны принести с собой другие сборщики? Можно ли присоединиться позднее?",
  "Benachrichtigungs-Einstellungen": "Настройки уведомлений",
  "Benachrichtigungen einstellen": "Настроить уведомления",
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\n\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "Если ты хочешь выключить звук уведомлений или полностью отключить уведомления определенных видов, то просто долго нажимай на полученное уведомление, и ты перейдешь в настройки уведомлений в данном приложении.",
  "Plakatieren": "расклеивать плакаты",
  "Löschen": "удалить",
  "Bearbeiten": "править",
  "diese Aktion ist beendet": "эта акция закончилась",
  "Dein Bericht zu einer Aktion fehlt noch":
      "твой отзыв о акции еще отсутствует",
  "Zur Aktion": "к акции",
  "Berichten": "отзыв",
  "Über Aktion berichten": "отзыв",
  // "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe einfach lange auf eine Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
  //     "If you want to change Notifications to silent or disable certain notification categories, just long press a received notification. You will then be guided to the notification preferences for this app.",
  // "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe auf die drei Punkte in einer Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
  //     "If you want to change Notifications to silent or disable certain notification categories, just press the three dots on a received notification. You will then be guided to the notification preferences for this app.",
  // "Kundgebung": "Manifestation",
  "Na gut": "Закрыть",
  "In den Kalender": "Добавить в календарь",
  '{typ***REMOVED*** in {ortsteil***REMOVED***': '{typ***REMOVED*** в {ortsteil***REMOVED***',
  "Teilen": "Поделиться",
  '{typ***REMOVED*** in {ortsteil***REMOVED***, {treffpunkt***REMOVED*** am {zeitpunkt***REMOVED***\n{url***REMOVED***':
      '{typ***REMOVED*** в {ortsteil***REMOVED***, {treffpunkt***REMOVED*** {zeitpunkt***REMOVED***\n{url***REMOVED***',
  'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.':
      'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.',
  'Ein Fehler ist aufgetreten': 'Произошла ошибка',
***REMOVED***

const Map<String, dynamic> fr = {
  "Liste": "Liste",
  "Karte": "Carte",
  "Sammeln": "Collecter",
  "Infoveranstaltung": "Réunion d’information",
  "Workshop": "Workshop",
  "Unbekannter Nachrichtentyp abgespeichert":
      "Message de type inconnu sauvegardé",
  "{kiez***REMOVED*** in {bezirk***REMOVED***\n Treffpunkt: {treffpunkt***REMOVED***":
      "{kiez***REMOVED*** dans {bezirk***REMOVED***\n Point de rencontre: {treffpunkt***REMOVED***",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***":
      "Notification push illisible (Participation) reçue: {message***REMOVED***",
  "Ein paar Worte über dich": "Quelques mots sur toi",
  "Beschreibung: {beschreibung***REMOVED***": "Déscription: {beschreibung***REMOVED***",
  "Beschreibe die Aktion kurz": "Décris brièvement l'action",
  "Wähle die Art der Aktion": "Choisis la forme de l'action",
  "von ": "de ",
  " bis ": " à ",
  "Wähle eine Uhrzeit": "Choisis un horaire",
  "Jetzt": "Maintenant",
  "Hier liegen öffentliche Unterschriften-Listen aus. Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\nFrage doch mal die Betreiber*innen deines Lieblings-Spätis!\n":
      "Ici se trouvent des formulaires de pétitions. Tu peux déposer toi même ces formulaires dans les lieux publics, ex. cafés, bars ou magasin. L'important est que tu viennes régulièrement chercher les pétitions signées.\nDemandes donc aux gérants de ton Späti préféré!\n",
  "Du kannst den Ort auf ": "Tu peux ",
  " eintragen.": " inscrire.",
  "Du kannst den Ort eintragen auf:\n": "Tu peux inscrire l’endroit sur:\n",
  "Nachricht eingeben...": "Formuler message...",
  "Jemand": "Quelqu’un",
  " ist der Aktion beigetreten": " a joint l'action",
  " hat die Aktion verlassen": " a quitté l'action",
  "\nNeue Teilnehmer*innen können ältere Nachrichten nicht lesen":
      "\nLes nouve.eaux.elles participant.e.s ne peuvent pas lire d'anciens messages",
  "gerade eben": "à l'instant",
  "{***REMOVED*** Minuten": {
    "zero": "{***REMOVED*** Minutes",
    "one": "{***REMOVED*** Minute",
    "two": "{***REMOVED*** Minutes",
    "other": "{***REMOVED*** Minutes"
  ***REMOVED***,
  "{***REMOVED*** Stunden": {
    "zero": "{***REMOVED*** Heure",
    "one": "{***REMOVED*** Heure",
    "two": "{***REMOVED*** Heures",
    "other": "{***REMOVED*** Heures"
  ***REMOVED***,
  "Teilnehmer*innen": "Participant.e.s",
  "Keine Teilnehmer*innen": "Aucun.e.s participant.e.s",
  "{count***REMOVED*** Teilnehmer*innen im Chat": "{count***REMOVED*** Participant.e.s dans le chat",
  "+ {count***REMOVED*** weitere Teilnehmer*innen": "+ {count***REMOVED*** autres participant.e.s",
  "Neue Chat-Nachricht": "Nouveau message",
  "Öffne die App um sie zu lesen": "Ouvre l'appli pour la lire",
  "Durchsuchen": "Rechercher",
  "Anwenden": "Appliquer",
  "Aktualisieren": "Actualiser",
  "alle Tage,": "Tous les jours,",
  "Alle Aktions-Arten,": "Tous types d'actions,",
  "jederzeit": "toujours",
  "überall": "partout",
  "Wähle Aktions-Art": "Choisis les types d'actions",
  "Fertig": "Terminé",
  "Treffpunkt": "Point de rencontre",
  "Wähle auf der Karte einen Treffpunkt aus.":
      "Choisis un point de rencontre sur la carte.",
  "Du kannst eine eigene Beschreibung angeben, z.B. \"Unter der Weltzeituhr\" oder \"Tempelhofer Feld, Eingang Kienitzstraße\":":
      "Tu peux donner ta propre déscription, ex. \"Sous l'horloge universelle\" ou \"Tempelhofer Feld, 'Entrée Kienitzstraße\"",
  "Abbrechen": "Quitter",
  "Aktionen": "Actions",
  "Aktionen in einer Liste oder Karte anschauen":
      "Voir actions sur une liste ou une carte",
  "Zum Sammeln einladen": "Inviter à collecter",
  "Fragen und Antworten": "Questions et réponses",
  "Dein Profil": "Ton profil",
  "Eine Sammel-Aktion ins Leben rufen": "Entreprendre une action de collecte",
  "Tipps und Argumente": "Conseils et arguments",
  "Tipps, Tricks und Argumentationshilfen":
      "Conseils, tuyaux, aide à l'argumentation",
  "Profil": "Profil",
  "Dein Name, dein Kiez und deine Einstellungen":
      "Ton nom, ton quartier et ta position",
  "sofort": "tout de suite",
  "täglich": "journalier",
  "wöchentlich": "hebdomadaire",
  "nie": "jamais",
  "Sprache": "langue",
  "Dein Name": "Ton nom",
  "Dein Kiez": "Ton quartier",
  "Mit deiner Kiez-Auswahl bestimmst du für welche Gegenden du über neue Aktionen informiert werden willst.":
      " Avec ton choix de quartier tu définis les zones pour lesquelles tu souhaites être tenu informé de nouvelles actions.",
  "Deine Benachrichtigungen": "Tes messages",
  "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?":
      "Avec quelle régularité souhaites-tu être tenu informé des nouvelles actions de collectes dans ton quartier?",
  "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?":
      "Avec quelle régularité souhaites-tu recevoir des Infos sur les futures actions?",
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\n\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "Cette appli a été développée par un petit groupe d'informaticien.ne.s activistes pour la campagne Deutsche Wohnen & Co. Enteignen - et se trouve sous licence libre.\\n\\n  Si tu es intéressé.e à utiliser cette appli pour un vote populaire, contactes nous simplement par email ou visite notre site web. Ainsi tu peux nous indiquer des erreurs ou dysfonctionnements encontrés avec l'appli.",
  "Heute, ": "Aujourd'hui, ",
  "Morgen, ": "Demain, ",
  "{prefix***REMOVED***{date***REMOVED*** um {zeit***REMOVED*** Uhr, ": "{prefix***REMOVED***{date***REMOVED*** à {zeit***REMOVED*** heure.s, ",
  "Aktionen konnten nicht geladen werden.":
      "Les actions n'ont pas pu être chargées.",
  "Aktion konnte nicht angelegt werden": "L'action n'a pas pu être établie",
  "Okay...": "Ok...",
  "Zum Chat": "Vers le Chat",
  "Schließen": "Fermer",
  "Aktion konnte nicht geladen werden.": "L'action n'a pas pu être chargée.",
  "Mitmachen": "Participer",
  "Verlassen": "Quitter",
  "Deine Aktion bearbeiten": "Éditer ton action",
  "Aktion konnte nicht gespeichert werden.":
      "L'action na pas pu être sauvegardée.",
  "Aktion konnte nicht gelöscht werden.": "L'action n'a pas pu être supprimée.",
  "Aktion konnte nicht erzeugt werden.": "L'action n'a pas pu être générée.",
  "Aktion Löschen": "Supprimer l'action",
  "Möchtest du diese Aktion wirklich löschen?":
      "Souhaites-tu vraiment supprimer cette action?",
  "Ja": "Oui",
  "Nein": "Non",
  "Es scheint keine Internet-Verbindung zu bestehen.":
      "La connection Internet semble inexistante.",
  "Die Internet-Verbindung scheint sehr langsam zu sein.":
      "La connection Internet semble être très lente.",
  "Der Server antwortet leider nicht. Möglicherweise ist er überlastet, versuch es doch später nochmal":
      "Le serveur ne répond pas. Il est probablement surchargé, réessayes plus tard",
  "Ein Verbindungsproblem ist aufgetreten: ":
      "Une erreur de connection est survenue: ",
  "Der Server hat leider gerade technische Probleme: ":
      "Le serveur a malheureusement un problème technique: ",
  "Der Server reagiert nicht, obwohl eine Internet-Verbindung besteht. Vielleicht gibt es ein technisches Problem, bitte versuch es später nochmal. ":
      "Le serveur ne réagit pas, même si la connection Internet est établie. Peut être existe-t-il un problème technique, réessayes plus tard ",
  "Das Internet scheint nicht erreichbar zu sein: ":
      "Internet semble indisponible: ",
  "Es ist ein Fehler aufgetreten beim Verifizieren deines Benutzer*in-Accounts. Probiere es eventuell zu einem späteren Zeitpunkt noch einmal oder versuche die App nochmal neu zu installieren, wenn du keine eigenen Aktionen betreust.":
      "Une erreur est survenue lors de la vérification de ton compte. Réessayes plus tard ou essayes de réinstaller l'appli si tu n'est pas en charge d'actions.",
  "SSL-Zertifikat konnte nicht geladen werden":
      "Certificat-SSL n'a pas pu être chargé",
  "Deine App-Version ist veraltet. Dies ist die Version {version***REMOVED***, du musst aber mindestens Version {minClient***REMOVED*** benutzen, damit die App richtig funktioniert.":
      "Ta version de l'appli est dépassée. Celle-ci est la version {version***REMOVED***, mais c'est au moins la version {minClient***REMOVED*** que tu nécessites pour que l'appli fonctionne correctement.",
  "Falsches Format": "Format incorrect",
  "Listen-Orte konnten nicht geladen werden.":
      "La liste des lieux n'a pas pu être chargée.",
  "Teilnahmen und Absagen": "Participations et annulations",
  "Benachrichtigungen über Mitstreiter*innen bei Aktionen an denen du teilnimmst":
      "Messages par le biais d'autres militant.e.s pour les actions auxquelles tu participes ",
  "Änderungen an Aktionen": "Modification des actions",
  "Änderungen an Benachrichtigungen wenn sich Aktionen geändert haben oder abgesagt wurden an denen du teilnimmst":
      "Changement des messages lorsque les actions auxquelles tu participes ont changé ou ont été annulé ",
  "Aktionen-Chats": "Chat d'actions",
  "Benachrichtigungen über neue Chat-Nachrichten zu Aktionen an denen du teilnimmst":
      "Communication des actions auxquelles tu participes par le biais de nouveaux messages dans le chat ",
  "Infos": "Infos",
  "Allgemeine Infos": "Infos générales",
  "Nachricht von {name***REMOVED***": "Message de {name***REMOVED***",
  "Problem beim Einrichten von Push-Nachrichten":
      "Problème à installer les notifications-push",
  "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.":
      "La connection au service Google-Push n'a pas pu être établie. Cela peut être le cas lorsque le système d'exploitation n'est pas de Google. Pour cette raison l'appli ne peut undrecevoir les notifications que lorsque l'appli est ouverte",
  "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert":
      "Une erreur est survenue lors du chargement des messages. Le chargement fréquent des messages sera donc désactivé",
  "Fehler beim Anmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Erreur lors du chargement des messages pour {topics***REMOVED***",
  "Fehler beim Abmelden der Benachrichtigungen zu {topics***REMOVED***":
      "Erreur lors de l'annulation des messages pour {topics***REMOVED***",
  "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.":
      "Pour les notifications push sur les dispositifs, un déstinataire doit être au moins indiqué.",
  "Push-Nachricht an Geräte konnte nicht versandt werden":
      "Notification push vers les dispositifs n'a pas pu être envoyé",
  "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.":
      "Pour les notifications push vers Topics, un Topic doit être indiqué.",
  "Push-Nachricht an Thema konnte nicht versandt werden":
      "Notification push vers Thème n’a pas pu être envoyé",
  "Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.":
      "Pour les notifications push d’actions, l’identifiant de l’action doit être indiqué.",
  "Push-Nachricht an Aktion konnte nicht versandt werden.":
      "Notification push vers action n’a pas pu être envoyée.",
  "Teilnahme ist fehlgeschlagen.": "Participation a échoué.",
  "Absage ist fehlgeschlagen.": "Annulation a échoué.",
  "Neue Aktionen": "Nouvelles actions",
  "Gelöschte Aktionen": "Actions supprimées",
  "Eine neue Benutzer*in wird angelegt.":
      "Un.e nouve.au/lle utilisat.eur.trice est enregistrée.",
  "Anlegen einer neuen Benutzer*in ist gescheitert.":
      "Enregistrement d\'un.e nouve.au.lle utilisat.eur.trice a échoué.",
  "Benutzer*indaten konnte nicht überprüft werden.":
      "Données d’utilisat.eur.trice n’a pas pu être vérifiées.",
  "Benutzer*in-Name konnte nicht geändert werden.":
      "Nom d’utilisat.eur.trice n’a pas pu être modifié.",
  "Bezirke oder Kieze auswählen": "Choisir les quartiers",
  "Mo": "Lu",
  "Di": "Ma",
  "Mi": "Me",
  "Do": "Je",
  "Fr": "Ve",
  "Sa": "Sa",
  "So": "Di",
  "Startzeit": "Début",
  "Endzeit": "Fin",
  "Weiter": "Continuer",
  "Keine Auswahl": "Aucune option",
  "Um diese Aktion auszuführen musst du dir einen Benutzer*in-Name geben":
      "Pour exécuter cette action définis d’abord un nom d’utilisat.eur.trice",
  "am {tage***REMOVED***,": "le {tage***REMOVED***,",
  "Auswählen": "Choisir",
  "Auswahl übernehmen": "Utiliser ce choix",
  "Das Volksbegehren lebt von deiner Beteiligung! \n":
      "Le vote populaire vit de ta participation! \n",
  "Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.":
      "Si tu ne trouves pas d’action de collecte appropriée, invites d’autres personnes. Elles pourront voir ton appel à la collecte et y participer. Tu peux à tout moment modifier ou supprimer l’action ",
  "Kontakt": "Contact",
  "Hier kannst du ein paar Worte über dich verlieren, \nvor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. \nBeachte dass alle Sammler*innen deine Angaben lesen können.":
      "Ici, tu peux te présenter en quelques mots, \nsurtout comment il est possible de te contacter afin d’organiser une rencontre entre toi et d’autres membres pour la collecte . \nRemarque: tout.es les collect.eur.rice.s peuvent lire tes messages",
  "Beschreibung": "Déscription",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw":
      "Décris brièvement l’action. Où veux-tu collecter, que doivent apporter les autres collect.eur.rice.s? Peut-on également joindre l’action plus tard? etc…",
  "Wähle einen Tag": "Choisis un jour",
  "am ": "le ",
  "Gib einen Treffpunkt an": "Indiques un point de rencontre",
  "Wann?": "Quand?",
  "Wo?": "Où?",
  "Was?": "Quoi?",
  "Wer?": "Qui?",
  "News": "Actualités",
  "Neues vom Volksbegehren und der Kampagne":
      "Actualité du vote populaire et de la campagne",
  "Benutzer*in-Name": "Nom d’utilisat.eur.rice",
  "Anzahl Unterschriften": "Nombre de signatures",
  "Dauer": "Durée",
  "Situation": "Situation",
  "Spaßfaktor": "Indice d’amusement",
  "Erzähl uns, was ihr erreicht habt! \n":
      "Racontes nous ce que vous avez atteint! \n",
  "Deine Rückmeldung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.":
      "Ton retour aide l’équipe de quartier à reconnaître les actions les plus efficaces. D’autres équipes peuvent également apprendre de vos actions.",
  "Anzahl Deiner Unterschriften": "Nombre de tes signatures",
  "Wie viele Leute waren bei der Aktion dabei?":
      "Combien de personnes étaient présentes à l’action?",
  "Wie viele Unterschriften hast Du persönlich gesammelt?":
      "Combien de signatures as-tu collectées personnellement?",
  "Wie fandest Du die Aktion?": "Comment as-tu trouvé l’action?",
  "sehr cool": "très cool",
  "gut": "bonne",
  "ganz okay": "ok",
  "mäßig": "moyen",
  "doof": "bof",
  "Wie viele Stunden habt ihr gesammelt?":
      "Durant combien d’heures avez-vous collecté?",
  "Wie viele Stunden warst Du sammeln?":
      "Combien d’heures as-Tu passé à collecter?",
  "Auf die nächste halbe Stunde gerundet":
      "En arrondissant à la demi-heure supérieure",
  "Wie viel hast Du gesammelt?": "Combien as-Tu collecté?",
  "Anzahl Teilnehmer*innen": "Nombre de participant.e.s",
  "Anmerkungen": "Remarques",
  "Kommentar": "Commentaires",
  "Optional: Sonstige Anmerkungen zu den Daten?":
      "Optionnel: autres remarques à propos des dates?",
  "Anmerkungen: ": "Remarques: ",
  "Optional: Muss man noch etwas zu den Angaben wissen?":
      "Optionnel: doit-on savoir quelque chose sur les indications?",
  "Wie war die Situation? (Wetter, Veranstaltung in der Nähe, besonderer Anlass, ...)":
      "Comment était la situation? (météo, activités dans les environs, occasion spéciale, ...)",
  "Situation: ": "Situation: ",
  "Optional: Wie war die Situation?": "optionnel, comment était la situation?",
  "Erzähl uns, was ihr erreicht habt!\n":
      "Racontes nous ce que vous avez atteint!\n",
  "{***REMOVED*** Unterschriften": {
    "zero": "{***REMOVED*** Signature",
    "one": "{***REMOVED*** Signature",
    "two": "{***REMOVED*** Signatures",
    "others": "{***REMOVED*** Signatures",
  ***REMOVED***,
  "{***REMOVED*** Teilnehmer": {
    "zero": "{***REMOVED*** Particpant.e",
    "one": "{***REMOVED***Participant.e",
    "two": "{***REMOVED***Participant.e.s",
    "other": "{***REMOVED***Participant.e.s"
  ***REMOVED***,
  "Datenschutz": "Protection des données",
  "Deine Daten": "Tes données",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an e@mail.com.":
      "Toutes les données que tu inscris dans l’appli seront uniquement sauvegardées et utilisées sur les systèmes de la campagne -Deutsche Wohnen & Co. Enteignen-. Considères toutefois, que beaucoup de données que tu partages peuvent être lues par d’autres utilisat.eur.rice.s de l’appli. Les messages du chat sont seulement lisibles pour les participant.e.s du chat au moment de leur rédaction. \n\nConcernant la fonction des notifications push, nous sommes dépendants d’une structure de gestion Google ou Apple. Les données véhiculées par ce biais sont cryptées. Si tu souhaites que toutes les données que tu as partagées soient supprimées, écris nous un mail à e@mail.com",
  "Okay": "OK",
  "Zu viele Tage": "Trop de jours",
  "Bitte wähle {maxTage***REMOVED*** Tage oder weniger aus.":
      "Choisis s’il te plaît {maxTage***REMOVED*** journées ou moins.",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.":
      "Toutes les données que tu inscris dans l’appli seront uniquement sauvegardées et utilisées sur les systèmes de la campagne -Deutsche Wohnen & Co. Enteignen-. Considères toutefois, que beaucoup de données que tu partages peuvent être lues par d’autres utilisat.eur.rice.s de l’appli. Les messages du chat sont seulement lisibles pour les participant.e.s du chat au moment de leur rédaction. \n\nConcernant la fonction des notifications push, nous sommes dépendants d’une structure de gestion Google ou Apple. Les données véhiculées par ce biais sont cryptées. Si tu souhaites que toutes les données que tu as partagées soient supprimées, écris nous un mail à  app@dwenteignen.de.",
  "deutsch": "allemand",
  "englisch": "anglais",
  "": "",
  "Hier kannst du ein paar Worte über dich verlieren, vor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. Beachte dass alle Sammler*innen deine Angaben lesen können.":
      "Ici, tu peux te présenter en quelques mots et écrire comment il est possible de te contacter afin d’organiser une rencontre entre toi et d’autres membres pour la collecte. Remarque: tout.es les collect.eur.rice.s peuvent lire tes messages.",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammler*innen mitbringen? Kann man auch später dazustoßen?":
      "Décris brièvement l’action. Où souhaites-tu collecter, que doivent apporter les autres collect.eur.rice.s? Peut-on joindre l’action plus tard?",
  "Benachrichtigungs-Einstellungen": "Réglage de la messagerie",
  "Benachrichtigungen einstellen": "Régler la messagerie",
  "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe einfach lange auf eine Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
      "Si tu souhaites régler la messagerie en mode discret ou désactiver certains types de messages, il te suffit d’appuyer longuement sur un message reçu afin d’accéder aux réglages de la messagerie pour l’appli.",
  "Danke!": "Merci!",
  "Vielen Dank, dass Du Eure Erfahrungen geteilt hast.":
      "Merci d’avoir partagé vos expériences.",
  "Plakatieren": "Coller des affiches",
  "Löschen": "Supprimer",
  "Bearbeiten": "Configurer",
  "diese Aktion ist beendet": "cette action est terminée",
  "Dein Bericht zu einer Aktion fehlt noch":
      "Ton commentaire pour une action est encore manquant",
  "Zur Aktion": "Vers l’action",
  "Berichten": "Commentaire",
  "Über Aktion berichten": "Commentaire",
  "Kundgebung": "Manifestation",
  // "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe auf die drei Punkte in einer Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
  //     "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe auf die drei Punkte in einer Benachrichtigung die du bekommen hast und du gelangst du den Benachrichtigungseinstellungen für diese App.",
  "Na gut": "Fermer",
  "In den Kalender": "Dans le calendrier",
  '{typ***REMOVED*** in {ortsteil***REMOVED***': '{typ***REMOVED*** à {ortsteil***REMOVED***',
  "Teilen": "Partagez",
  '{typ***REMOVED*** in {ortsteil***REMOVED***, {treffpunkt***REMOVED*** am {zeitpunkt***REMOVED***\n{url***REMOVED***':
      '{typ***REMOVED*** à {ortsteil***REMOVED***, {treffpunkt***REMOVED*** à {zeitpunkt***REMOVED***\n{url***REMOVED***',
  'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.':
      'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.',
  'Ein Fehler ist aufgetreten': 'Une erreur s\'est produite',
***REMOVED***

const Map<String, dynamic> de = {
  "Liste": "Liste",
  "Karte": "Karte",
  "Sammeln": "Sammeln",
  "Infoveranstaltung": "Infoveranstaltung",
  "Workshop": "Workshop",
  "Unbekannter Nachrichtentyp abgespeichert":
      "Unbekannter Nachrichtentyp abgespeichert",
  "{kiez***REMOVED*** in {bezirk***REMOVED***\n Treffpunkt: {treffpunkt***REMOVED***":
      "{kiez***REMOVED*** in {bezirk***REMOVED***\n Treffpunkt: {treffpunkt***REMOVED***",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***":
      "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message***REMOVED***",
  "Ein paar Worte über dich": "Ein paar Worte über dich",
  "Beschreibung: {beschreibung***REMOVED***": "Beschreibung: {beschreibung***REMOVED***",
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
  "Wähle Aktions-Art": "Wähle Aktions-Art",
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
  "Mit deiner Kiez-Auswahl bestimmst du für welche Gegenden du über neue Aktionen informiert werden willst.":
      "Mit deiner Kiez-Auswahl bestimmst du für welche Gegenden du über neue Aktionen informiert werden willst.",
  "Deine Benachrichtigungen": "Deine Benachrichtigungen",
  "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?":
      "Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?",
  "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?":
      "Wie häufig möchtest du Infos über anstehende Aktionen bekommen?",
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\n\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\n\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.",
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
  "Verlassen": "Verlassen",
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
  "News": "Neuigkeiten",
  "Neues vom Volksbegehren und der Kampagne":
      "Neues vom Volksbegehren und der Kampagne",
  "Benutzer*in-Name": "Benutzer*in-Name",
  "Anzahl Unterschriften": "Anzahl Unterschriften",
  "Dauer": "Dauer",
  "Situation": "Situation",
  "Spaßfaktor": "Spaßfaktor",
  "Erzähl uns, was ihr erreicht habt! \n":
      "Erzähl uns, was ihr erreicht habt! \n",
  "Deine Rückmeldung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.":
      "Deine Rückmeldung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.",
  "Anzahl Deiner Unterschriften": "Anzahl Deiner Unterschriften",
  "Wie viele Leute waren bei der Aktion dabei?":
      "Wie viele Leute waren bei der Aktion dabei?",
  "Wie viele Unterschriften hast Du persönlich gesammelt?":
      "Wie viele Unterschriften hast Du persönlich gesammelt?",
  "Wie fandest Du die Aktion?": "Wie fandest Du die Aktion?",
  "sehr cool": "sehr cool",
  "gut": "gut",
  "ganz okay": "ganz okay",
  "mäßig": "mäßig",
  "doof": "doof",
  "Wie viele Stunden habt ihr gesammelt?":
      "Wie viele Stunden habt ihr gesammelt?",
  "Wie viele Stunden warst Du sammeln?": "Wie viele Stunden warst Du sammeln?",
  "Auf die nächste halbe Stunde gerundet":
      "Auf die nächste halbe Stunde gerundet",
  "Wie viel hast Du gesammelt?": "Wie viel hast Du gesammelt?",
  "Anzahl Teilnehmer*innen": "Anzahl Teilnehmer*innen",
  "Anmerkungen": "Anmerkungen",
  "Kommentar": "Kommentar",
  "Optional: Sonstige Anmerkungen zu den Daten?":
      "Optional: Sonstige Anmerkungen zu den Daten?",
  "Anmerkungen: ": "Anmerkungen: ",
  "Optional: Muss man noch etwas zu den Angaben wissen?":
      "Optional: Muss man noch etwas zu den Angaben wissen?",
  "Wie war die Situation? (Wetter, Veranstaltung in der Nähe, besonderer Anlass, ...)":
      "Wie war die Situation? (Wetter, Veranstaltung in der Nähe, besonderer Anlass, ...)",
  "Situation: ": "Situation: ",
  "Optional: Wie war die Situation?": "Optional: Wie war die Situation?",
  "Erzähl uns, was ihr erreicht habt!\n":
      "Erzähl uns, was ihr erreicht habt!\n",
  "{***REMOVED*** Unterschriften": {
    "zero": "{***REMOVED*** Unterschriften",
    "one": "{***REMOVED*** Unterschrift",
    "two": "{***REMOVED*** Unterschriften",
    "others": "{***REMOVED*** Unterschriften",
  ***REMOVED***,
  "{***REMOVED*** Teilnehmer": {
    "zero": "{***REMOVED*** Teilnehmer*innen",
    "one": "{***REMOVED*** Teilnehmer*in",
    "two": "{***REMOVED*** Teilnehmer*innen",
    "other": "{***REMOVED*** Teilnehmer*innen"
  ***REMOVED***,
  "Datenschutz": "Datenschutz",
  "Deine Daten": "Deine Daten",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.":
      "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.",
  "Okay": "Okay",
  "Zu viele Tage": "Zu viele Tage",
  "Bitte wähle {maxTage***REMOVED*** Tage oder weniger aus.":
      "Bitte wähle {maxTage***REMOVED*** Tage oder weniger aus.",
  "deutsch": "deutsch",
  "englisch": "english",
  "": "",
  "Hier kannst du ein paar Worte über dich verlieren, vor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. Beachte dass alle Sammler*innen deine Angaben lesen können.":
      "Hier kannst du ein paar Worte über dich verlieren, vor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. Beachte dass alle Sammler*innen deine Angaben lesen können.",
  "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammler*innen mitbringen? Kann man auch später dazustoßen?":
      "Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammler*innen mitbringen? Kann man auch später dazustoßen?",
  "Benachrichtigungs-Einstellungen": "Benachrichtigungs-Einstellungen",
  "Benachrichtigungen einstellen": "Benachrichtigungen einstellen",
  "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe einfach lange auf eine Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
      "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe einfach lange auf eine Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.",
  "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe auf die drei Punkte in einer Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.":
      "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe auf die drei Punkte in einer Benachrichtigung die du bekommen hast und du gelangst du den Benachrichtigungseinstellungen für diese App.",
  "Danke!": "Danke!",
  "Vielen Dank, dass Du Eure Erfahrungen geteilt hast.":
      "Vielen Dank, dass Du Eure Erfahrungen geteilt hast.",
  "Plakatieren": "Plakatieren",
  "Löschen": "Löschen",
  "Bearbeiten": "Bearbeiten",
  "diese Aktion ist beendet": "diese Aktion ist beendet",
  "Dein Bericht zu einer Aktion fehlt noch":
      "Dein Bericht zu einer Aktion fehlt noch",
  "Zur Aktion": "Zur Aktion",
  "Berichten": "Feedback",
  "Über Aktion berichten": "Über Aktion berichten",
  "Kundgebung": "Kundgebung",
  "eigene": "eigene",
  "Nur eigene Aktionen anzeigen": "Nur eigene Aktionen anzeigen",
  "Eigene Aktionen immer anzeigen": "Eigene Aktionen immer anzeigen",
  "Eigene Aktionen": "Eigene Aktionen",
  "lade...": "lade...",
  "Na gut": "Na gut",
  "In den Kalender": "In den Kalender",
  "Teilen": "Teilen",
  '{typ***REMOVED*** in {ortsteil***REMOVED***': '{typ***REMOVED*** in {ortsteil***REMOVED***',
  '{typ***REMOVED*** in {ortsteil***REMOVED***, {treffpunkt***REMOVED*** am {zeitpunkt***REMOVED***\n{url***REMOVED***':
      '{typ***REMOVED*** in {ortsteil***REMOVED***, {treffpunkt***REMOVED*** am {zeitpunkt***REMOVED***\n{url***REMOVED***',
  'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.':
      'Die Aktion konnte nicht gefunden werden. Eventuell wurde sie gelöscht.',
  'Ein Fehler ist aufgetreten': 'Ein Fehler ist aufgetreten',
  'Haustürgespräche': 'Haustürgespräche' ,
  'Straßengespräche & Flyern': 'Straßengespräche & Flyern',
  'Kiezfest': 'Kiezfest'
***REMOVED***
