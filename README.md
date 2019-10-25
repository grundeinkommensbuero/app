# Sammel-App

Eine Demo des Prototypen, die ohne Server läuft liegt [hier](https://gitlab.com/ChemoCosmo/sammel-app/blob/master/App-Demo/dwe.apk).

# Projekt aufsetzen

Anleitung zum Einrichten des Projekts in IDEA Comunity Edition. 
Die Ultimate Edition ist äquivalent. Intellij Android Studio, RubyMine, etc. sind mit IDEA verwandt, möglicherweies klappt es damit genauso. 
In Eclipse oder anderen Entwicklungsumgebungen lässt sich das Projekt sicher auch zum Laufen kriegen, aber nicht nach dieser Anleitung.


1.  git installieren
*  https://git-scm.com/downloads
*  gibt es für Windows, Linux und Max
*  alle Default-Einstellungen bei der Installation sind okay
2.  Docker herunterladen und installieren
*  https://docs.docker.com/install
*  ACHTUNG: Docker ist unter Windows/Mac auf die Hardware-beschleunigte 
Virtualisierungstechnologie Hyper-V angewiesen. Diese kann aber nicht gleichzeitig
mit Intel HAXM laufen, ebenfalls eine Harcware-Beschleunigung für Virtualisierung.
Android Virtual Devices (siehe unten)  verlangt standardmäßig HAXM. Statt HAXM kann
jedoch auch Hyper-V benutzt werden. Siehe Fußnote A.
3.  IDEA Comunity Edition herunteladen:
*  https://www.jetbrains.com/idea/download/
*  gibt es für Windows, Linux und Mac
4.  Flutter SDK und Dart SDK herunterladen und entpacken
*  https://flutter.dev/docs/development/tools/sdk/releases
5.  IDEA Installieren und starten
*  alle vorgeschlagenen Default Plugins aktiviert lassen
*  keines der vorgeschlagenen Featured Plugins ist notwendig
7.  Im Startscreen auf Configure > Plugins und folgende Plugins installieren:
*  Dart
*  Flutter
8.  IDEA neu starten
7.  Im Startscreen Configure > Settings öffnen
8.  Unter Languages & Frameworks > Flutter
*  Als Flutter SDK-Pfad das Hauptverzeichnis des heruntergeladenen Flutter SDK angeben
*  das hat funkltioniert, wenn IDEA anschließend darunter die SDK Version anzeigt
9.  Prüfen ob IDEA die Dart-SDK korrekt ergänzt hat unter Languages & Frameworks > Dart
*  falls nicht, den Dart SDK Pfad angeben auf das Verzeichnix \bin\cache\dart-sdk im Flutter-SDk
10.  Android konfigurieren unter Appearance & Behaviour > System Settings > Android SDK
*  Entweder ein bestehendes Android SDK als Pfad angeben oder
*  das Android SDK installieren lassen mit einem Klick auf Edit hinter dem Pfad
*  Die Android-Machine 7.0 anwählen
Falls das Projekt bereits ausgecheckt wurde 6 und 7 überspringen und stattdessen
in IDEA mit File > Open das ausgecheckte Verzeichnis als Projekt öffnen
6.  Im Startscreen auf Configure > Settings > Version Control > Git
*  als Git Executable Pfad zu git-Datei (z.B. git.exe) eintragen
*  mit Button Test testen
*  Settings schließen
9.  Im Startscreen "Check out from Version Control" > Git
*  URL: https://gitlab.com/ChemoCosmo/sammel-app.git
*  Directory: ein beliebiges Verzeichnis für das Auschecken wählen
*  Clone
10.  Öffnen des Projekts bestätigen und waaarten bis IDEA nix mehr tut
11.  Keine Dateien aus dem .idea-Verzeichnis zu git hinzufügen oder committen
*  entsprechende Vorschläge von IDEA ablehnen
*  Datei .gitignore im .idea-Verzeichnis öffnen (siehe Projektbaum in "Projekt" am linken Rand)
*  `/.idea` und `dwe.iml` jeweils als neue Zeile ergänzen
12.  Die Datei pubspec.yaml in sammel_app öffnen und in der Flutter conmmands - Zeile oben `Packages get` ausführen
13.  Unter   


A: AVD mit Hyper-V betreiben: