import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

class ConstJsonAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String _, Locale locale) async =>
      languages[locale.languageCode];
}

const Map<String, Map<String, dynamic>> languages = {
  'en': en,
  'de': de,
  'ru': ru,
};

const Map<String, dynamic> en = {
  "Liste": "List",
  "Karte": "Map",
  "Sammeln": "Collection",
  "Infoveranstaltung": "Information event",
  "Workshop": "Workshop",
  "Unbekannter Nachrichtentyp abgespeichert": "Unknown message type saved",
  "{kiez} in {bezirk}\n Treffpunkt: {treffpunkt}":
      "{kiez} in {bezirk}\n meeting point: {treffpunkt}",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message}":
      "Unreadable push notification (participation) received: {message}",
  "Ein paar Worte über dich": "A few words about yourself",
  "Beschreibung: {beschreibung}": "Description: {beschreibung}",
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
  "{} Minuten": {
    "zero": "{} Minutes",
    "one": "{} Minute",
    "two": "{} Minutes",
    "other": "{} Minutes"
  },
  "{} Stunden": {
    "zero": "{} Hours",
    "one": "{} Hour",
    "two": "{} Hours",
    "other": "{} Hours"
  },
  "Teilnehmer*innen": "Participants",
  "Keine Teilnehmer*innen": "No participants",
  "{count} Teilnehmer*innen im Chat": "{count} participants in chat",
  "+ {count} weitere Teilnehmer*innen": "+ {count} other participants",
  "Neue Chat-Nachricht": "New chat message",
  "Öffne die App um sie zu lesen": "Open the app to read",
  "Durchsuchen": "Browse",
  "Anwenden": "Apply",
  "Aktualisieren": "Update",
  "alle Tage,": "any day,",
  "Alle Aktions-Arten,": "All event types,",
  "jederzeit": "all times",
  "überall": "everywhere",
  "Wähle Aktions-Arten": "Choose the event type",
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
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\\n\\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "This app was developed by a small team of enthusiastic IT activists for Deutsche Wohnen & Co Enteignen and is under free license.\\n\\nIf you are interested in using the app for your own campaign, just write us an email or visit our website. You can also let us know about problems or errors with the app.",
  "Heute, ": "Today, ",
  "Morgen, ": "Tomorrow, ",
  "{prefix}{date} um {zeit} Uhr, ": "{prefix}{date} at {zeit} o’clock, ",
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
  "Deine App-Version ist veraltet. Dies ist die Version {version}, du musst aber mindestens Version {minClient} benutzen, damit die App richtig funktioniert.":
      "Your version of the app is out-of-date. This is version {version}. You need to use at {minClient} or later, for the app to work properly.",
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
  "Nachricht von {name}": "Message from {name}",
  "Problem beim Einrichten von Push-Nachrichten":
      "Error when opening a push message",
  "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.":
      "A connection to the Google Push service could not be established. That can happen if, for example, a Google-free operating system is being used, in which case the app can only receive notifications while it’s open.",
  "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert":
      "An error occurred when retrieving messages. Regular message retrieval has been disabled",
  "Fehler beim Anmelden der Benachrichtigungen zu {topics}":
      "Error logging in to notifications about {topics}",
  "Fehler beim Abmelden der Benachrichtigungen zu {topics}":
      "Error logging out from notifications about {topics}",
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
  "am {tage},": "on {tage},",
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
  "{} Unterschriften": {
    "zero": "{} signatures",
    "one": "{} signature",
    "two": "{} signatures",
    "other": "{} signatures"
  },
  "{} Teilnehmer": {
    "zero": "{} participants",
    "one": "{} participants",
    "two": "{} participants",
    "other": "{} participants"
  },
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
  "Bitte wähle {maxTage} Tage oder weniger aus.":
      "Please select {maxTage} days or fewer.",
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
};

const Map<String, dynamic> ru = {
  "Liste": "Список",
  "Karte": "Карта",
  "Sammeln": "Собрать подписи",
  "Infoveranstaltung": "Информационное мероприятие",
  "Workshop": "Семинар",
  "Unbekannter Nachrichtentyp abgespeichert":
      "Сохранено сообщение неизвестного типа",
  "{kiez} in {bezirk}\n Treffpunkt: {treffpunkt}":
      "{kiez} в {bezirk}\n место встречи: {treffpunkt}",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message}":
      "Принято нечитаемое Push-сообщение (участие): {message}",
  "Ein paar Worte über dich": "Несколько слов о тебе",
  "Beschreibung: {beschreibung}": "Описание: {beschreibung}",
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
  "{} Minuten": {
    "zero": "{} минут",
    "one": "{} минута",
    "two": "{} минуты",
    "other": "{} мин. "
  },
  "{} Stunden": {
    "zero": "{} часов",
    "one": "{} час",
    "two": "{} часа",
    "other": "{} час."
  },
  "Teilnehmer*innen": "Участники",
  "Keine Teilnehmer*innen": "Участников нет",
  "{count} Teilnehmer*innen im Chat": "{count} участников в чате",
  "+ {count} weitere Teilnehmer*innen": "+ еще {count} участников",
  "Neue Chat-Nachricht": "Новое сообщение в чате",
  "Öffne die App um sie zu lesen": "Открой приложение, чтобы прочитать",
  "Durchsuchen": "Просмотреть",
  "Anwenden": "Применить",
  "Aktualisieren": "Обновить",
  "alle Tage,": "все дни,",
  "Alle Aktions-Arten,": "Все виды акций,",
  "jederzeit": "в любое время",
  "überall": "везде",
  "Wähle Aktions-Arten": "Выбери виды акций",
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
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\\n\\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "Данное приложение было разработано небольшой командой энтузиастов из ИТ-индустрии для кампании «Национализируем Deutsche Wohnen & Co («Дойче Вонен унд Ко»)» и распространяется по свободной лицензии.\\n\\nЕсли ты заинтересован в использовании данного приложения для целей твоей народной инициативы, то просто напиши нам на электронную почту или посети наш сайт. По этим же каналам ты можешь сообщать нам об ошибках в приложении и о связанных с ним проблемах.",
  "Heute, ": "Сегодня, ",
  "Morgen, ": "Завтра, ",
  "{prefix}{date} um {zeit} Uhr, ": "{prefix}{date} в {zeit}, ",
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
  "Deine App-Version ist veraltet. Dies ist die Version {version}, du musst aber mindestens Version {minClient} benutzen, damit die App richtig funktioniert.":
      "Используемая тобой версия приложения устарела. Это версия {version}, но для правильной работы приложения необходимо использовать как минимум версию {minClient}.",
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
  "Nachricht von {name}": "Сообщение от {name}",
  "Problem beim Einrichten von Push-Nachrichten":
      "Проблема с настройкой Push-сообщений",
  "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.":
      "Не удалось установить соединения со службой Push-уведомлений Google. Так бывает в случае использования операционной системы, не привязанной к Google. Поэтому приложение может принимать уведомления, только когда оно открыто.",
  "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert":
      "При извлечении сообщений произошла ошибка. В связи с этим регулярное извлечение сообщений отключено",
  "Fehler beim Anmelden der Benachrichtigungen zu {topics}":
      "Ошибка при подписке на уведомления по {topics}",
  "Fehler beim Abmelden der Benachrichtigungen zu {topics}":
      "Ошибка при отписке от уведомлений по {topics}",
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
  "am {tage},": " {tage},",
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
  "{} Unterschriften": {
    "zero": "{} подписей",
    "one": "{} подпись",
    "two": "{} подписи",
    "others": "{} другое",
  },
  "{} Teilnehmer": {
    "zero": "{} участников",
    "one": "{} участник",
    "two": "{} участника",
    "other": "{} другое"
  },
  "Datenschutz": "Защита данных",
  "Deine Daten": "Твои данные",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an e@mail.com.":
      "Все данные, которые ты вводишь в приложение, хранятся исключительно на системах кампании «Национализируем Deutsche Wohnen & Co («Дойче Вонен унд Ко»)» и используются только в целях, связанных с приложением и кампанией. Но обращаем твое внимание на то, что другие пользователи могут читать многие из тех данных, которые ты вводишь в приложение. Сообщения в чате могут быть прочитаны только всеми участниками чата в момент появления сообщения.\n\nДля того чтобы была доступна функция Push-сообщений, мы вынуждены использовать инфраструктуру доставки сообщений, предоставляемую компанией Google и, в соответствующих случаях, компанией Apple. Передаваемые при этом данные передаются в зашифрованном виде. Если ты хочешь, чтобы все введенные тобой персональные данные были удалены, сообщи нам об этом по адресу: e@mail.com.",
  "Okay": "Хорошо",
  "Zu viele Tage": "Слишком большое количество дней",
  "Bitte wähle {maxTage} Tage oder weniger aus.":
      "Выбери не больше {maxTage} дней или меньшее количество дней.",
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
  "Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtiungs-Arten ganz ausstellen willst, dann tippe einfach lange auf eine Benachrichtigung die du bekommen hast und du gelangst du den Benachrichtigungseinstellungen für diese App.":
      "Если ты хочешь выключить звук уведомлений или полностью отключить уведомления определенных видов, то просто долго нажимай на полученное уведомление, и ты перейдешь в настройки уведомлений в данном приложении.",
  "Plakatieren": "Plakatieren",
  "Löschen": "Löschen",
  "Bearbeiten": "Bearbeiten",
};

const Map<String, dynamic> de = {
  "Liste": "Liste",
  "Karte": "Karte",
  "Sammeln": "Sammeln",
  "Infoveranstaltung": "Infoveranstaltung",
  "Workshop": "Workshop",
  "Unbekannter Nachrichtentyp abgespeichert":
      "Unbekannter Nachrichtentyp abgespeichert",
  "{kiez} in {bezirk}\n Treffpunkt: {treffpunkt}":
      "{kiez} in {bezirk}\n Treffpunkt: {treffpunkt}",
  "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message}":
      "Unlesbare Push-Nachricht (Teilnahme) empfangen: {message}",
  "Ein paar Worte über dich": "Ein paar Worte über dich",
  "Beschreibung: {beschreibung}": "Beschreibung: {beschreibung}",
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
  "{} Minuten": {
    "zero": "{} Minuten",
    "one": "{} Minute",
    "two": "{} Minuten",
    "other": "{} Minuten"
  },
  "{} Stunden": {
    "zero": "{} Stunden",
    "one": "{} Stunde",
    "two": "{} Stunden",
    "other": "{} Stunden"
  },
  "Teilnehmer*innen": "Teilnehmer*innen",
  "Keine Teilnehmer*innen": "Keine Teilnehmer*innen",
  "{count} Teilnehmer*innen im Chat": "{count} Teilnehmer*innen im Chat",
  "+ {count} weitere Teilnehmer*innen": "+ {count} weitere Teilnehmer*innen",
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
  "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\\n\\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.":
      "Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\\n\\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.",
  "Heute, ": "Heute, ",
  "Morgen, ": "Morgen, ",
  "{prefix}{date} um {zeit} Uhr, ": "{prefix}{date} um {zeit} Uhr, ",
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
  "Deine App-Version ist veraltet. Dies ist die Version {version}, du musst aber mindestens Version {minClient} benutzen, damit die App richtig funktioniert.":
      "Deine App-Version ist veraltet. Dies ist die Version {version}, du musst aber mindestens Version {minClient} benutzen, damit die App richtig funktioniert.",
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
  "Nachricht von {name}": "Nachricht von {name}",
  "Problem beim Einrichten von Push-Nachrichten":
      "Problem beim Einrichten von Push-Nachrichten",
  "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.":
      "Es konnte keine Verbindung zum Google-Push-Service hergestellt werden. Das kann der Fall sein, wenn etwa ein Google-freies Betriebssystem genutzt wird. Darum kann die App nur Benachrichtigungen empfangen während sie geöffnet ist.",
  "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert":
      "Beim Abrufen von Nachrichten ist ein Fehler aufgetreten. Das regelmäßige Abrufen von Nachrichten wird deshalb deaktiviert",
  "Fehler beim Anmelden der Benachrichtigungen zu {topics}":
      "Fehler beim Anmelden der Benachrichtigungen zu {topics}",
  "Fehler beim Abmelden der Benachrichtigungen zu {topics}":
      "Fehler beim Abmelden der Benachrichtigungen zu {topics}",
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
  "am {tage},": "am {tage},",
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
  "{} Unterschriften": {
    "zero": "{} Unterschriften",
    "one": "{} Unterschrift",
    "two": "{} Unterschriften",
    "others": "{} Unterschriften",
  },
  "{} Teilnehmer": {
    "zero": "{} Teilnehmer*innen",
    "one": "{} Teilnehmer*in",
    "two": "{} Teilnehmer*innen",
    "other": "{} Teilnehmer*innen"
  },
  "Datenschutz": "Datenschutz",
  "Deine Daten": "Deine Daten",
  "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.":
      "Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.",
  "Okay": "Okay",
  "Zu viele Tage": "Zu viele Tage",
  "Bitte wähle {maxTage} Tage oder weniger aus.":
      "Bitte wähle {maxTage} Tage oder weniger aus.",
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
};
