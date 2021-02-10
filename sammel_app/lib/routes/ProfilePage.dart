import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/PushNotificationManager.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/KiezPicker.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Provisioning.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  var init = false;
  StorageService storageService;
  AbstractUserService userService;
  AbstractPushNotificationManager pushNotificationManager;
  User user;
  String token;
  List<String> myKieze = [];
  String interval;

  static const intervalOptions = ['sofort', 'täglich', 'wöchentlich', 'nie'];
  static const languageOptions = ['de', 'en', 'ru', 'fr'];

  var languages = {
    'de': 'deutsch',
    'en': 'englisch',
    'ru': 'русский',
    'fr': 'français',
  };

  @override
  Widget build(BuildContext context) {
    if (init == false) {
      storageService = Provider.of<StorageService>(context);
      userService = Provider.of<AbstractUserService>(context);
      pushNotificationManager =
          Provider.of<AbstractPushNotificationManager>(context);
      userService.user.listen((user) => setState(() => this.user = user));
      pushNotificationManager.pushToken
          .then((token) => setState(() => this.token = token));
      storageService
          .loadNotificationInterval()
          .then((pref) => setState(() => interval = pref ?? 'sofort'));
      storageService
          .loadMyKiez()
          .then((kieze) => setState(() => myKieze = kieze ?? []));
      init = true;
    }
    var kiezeCaption = (myKieze ?? []).join(', ');

    return Scaffold(
        body: Container(
            decoration: DweTheme.happyHouseBackground,
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: [
                ProfileItem(
                  title: "Sprache",
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                              languages[EasyLocalization.of(context)
                                      ?.locale
                                      ?.languageCode] ??
                                  'Keine',
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 28))
                          .tr()),
                  onPressed: showLanguageDialog,
                ),
                SizedBox(height: 20.0),
                ProfileItem(
                  title: "Dein Name",
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        user?.name ?? '',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: (28.0 - ((user?.name ?? '').length) / 4)),
                      )),
                  onPressed: (context) =>
                      showUsernameDialog(context: context, hideHint: true),
                ),
                SizedBox(height: 20.0),
                ProfileItem(
                    title: "Dein Kiez",
                    child: Container(
                        child: Column(children: [
                      Text(kiezeCaption,
                              maxLines: 20,
                              style: TextStyle(
                                  fontSize: 12 +
                                      16 / ((100 + kiezeCaption.length) / 100)))
                          .tr(),
                      SizedBox(height: 10.0),
                      Text(
                        'Mit deiner Kiez-Auswahl bestimmst du für welche Gegenden du über neue Aktionen informiert werden willst.',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      ).tr()
                    ])),
                    onPressed: (_) => showKiezPicker()),
                SizedBox(height: 20.0),
                ProfileItem(
                    title: "Deine Benachrichtigungen",
                    child: Container(
                        child: Column(children: [
                      Text(interval ?? 'lade...',
                              style: TextStyle(fontSize: 28.0))
                          .tr(),
                      SizedBox(height: 10.0),
                      Text(
                        'Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      ).tr()
                    ])),
                    onPressed: (context) => showNotificationDialog(context)),
                SizedBox(height: 20.0),
                ProfileItem(
                    title: "Benachrichtigungs-Einstellungen",
                    child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text('Benachrichtigungen einstellen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0))
                              .tr(),
                        ])),
                    onPressed: (context) => showNotificationInfoDialog(context),
                    editable: false),
                SizedBox(height: 20.0),
                ProfileItem(
                    title: "Deine Daten",
                    child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text('Datenschutz',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 28.0))
                              .tr(),
                        ])),
                    onPressed: (context) => showPrivacyDialog(context),
                    editable: false),
                SizedBox(height: 20.0),
                SelectableText('User-ID: ${user?.id}',
                    textAlign: TextAlign.center),
                SizedBox(height: 20.0),
              ],
            )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.info_outline_rounded,
                size: 40.0, color: DweTheme.yellow),
            onPressed: () => showAboutDialog(context)));
  }

  showKiezPicker() async {
    var selection = (await KiezPicker(
                (await Provider.of<StammdatenService>(context).kieze)
                    .where((kiez) => myKieze.contains(kiez.name))
                    .toSet())
            .showKiezPicker(context))
        ?.map((kiez) => kiez.name)
        ?.toList();

    if (selection != null && !ListEquality().equals(selection, myKieze)) {
      renewTopicSubscriptions(selection, interval);
      storageService.saveMyKiez(selection);
      setState(() => myKieze = selection);
    }
  }

  showLanguageDialog(BuildContext context) async {
    String selection = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            key: Key('language selection dialog'),
            contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
            titlePadding: EdgeInsets.all(15.0),
            title: const Text('Sprache').tr(),
            children: []..addAll(languageOptions.map((option) => RadioListTile(
                  groupValue: EasyLocalization.of(context).locale.languageCode,
                  value: option,
                  title: Text(languages[option]),
                  onChanged: (selected) => Navigator.pop(context, selected),
                )))));

    if (selection != null)
      EasyLocalization.of(context).locale = Locale(selection);
  }

  showNotificationDialog(BuildContext context) async {
    String selection = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            key: Key('notification selection dialog'),
            contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
            titlePadding: EdgeInsets.all(15.0),
            title: Text(
                    'Wie häufig möchtest du Infos über anstehende Aktionen bekommen?')
                .tr(),
            children: []..addAll(intervalOptions.map((option) => RadioListTile(
                  groupValue: interval,
                  value: option,
                  title: Text(option).tr(),
                  onChanged: (selected) => Navigator.pop(context, selected),
                )))));

    if (selection != null && selection != interval) {
      renewTopicSubscriptions(myKieze, selection);
      storageService.saveNotificationInterval(selection);
      setState(() => interval = selection);
    }
  }

  void renewTopicSubscriptions(List<String> newKieze, String newInterval) {
    if (interval != "nie")
      pushNotificationManager.unsubscribeFromKiezActionTopics(
          myKieze, interval);
    if (newInterval != "nie")
      pushNotificationManager.subscribeToKiezActionTopics(
          newKieze, newInterval);
  }
}

showNotificationInfoDialog(BuildContext context) {
  showDialog(
      context: context,
      child: SimpleDialog(
          key: Key('notification info dialog'),
          contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          titlePadding: EdgeInsets.all(15.0),
          title: Text('Benachrichtigungs-Einstellungen').tr(),
          children: [
            Image.asset(
              'assets/images/housy_info.png',
              height: 250,
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Text(Platform.isIOS
                        ? 'Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe auf die drei Punkte in einer Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.'
                        : 'Wenn du Benachrichtigungen leise stellen oder bestimmte Benachrichtigungs-Arten ganz ausstellen willst, dann tippe einfach lange auf eine Benachrichtigung die du bekommen hast und du gelangst zu den Benachrichtigungseinstellungen für diese App.')
                    .tr()),
            FlatButton(
                child: Text('Okay', textAlign: TextAlign.end).tr(),
                onPressed: () => Navigator.pop(context))
          ]));
}

showPrivacyDialog(BuildContext context) {
  showDialog(
      context: context,
      child: SimpleDialog(
          key: Key('privacy dialog'),
          contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          titlePadding: EdgeInsets.all(15.0),
          title: Text('Datenschutz').tr(),
          children: [
            Image.asset(
              'assets/images/housy_info.png',
              height: 250,
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                        'Alle Daten, die du in die App eingibst werden ausschließlich auf Systemem der Deutsche Wohnen & Co. Enteignen - Kampagne gespeichert und nur für die App und die Kampagne verwendet. Beachte jedoch, dass viele Daten, die du eingibst von anderen Nutzer*innen der App gelesen werden können. Chat-Nachrichten sind ausschließlich lesbar für alle Teilnehmer*innen des Chats zum Zeitpunkt der Nachricht.\n\nFür die Funktion der Push-Nachrichten sind wir auf den Einsatz einer Zustell-Infrastruktur von Google und ggf. Apple angewiesen. Daten die auf diesem Weg transportiert werden, werden verschlüsselt übertragen. Wenn du möchtest, dass alle persönlichen Daten, die du eingetragen hast gelöscht werden, schreibe uns bitte eine Mail an app@dwenteignen.de.')
                    .tr()),
            FlatButton(
                child: Text('Okay', textAlign: TextAlign.end).tr(),
                onPressed: () => Navigator.pop(context))
          ]));
}

class ProfileItem extends StatelessWidget {
  final Widget child;
  final String title;
  final Function(BuildContext) onPressed;
  var editable;

  ProfileItem(
      {this.child, this.title = '', this.onPressed, this.editable = true}) {
    assert(child != null);
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(1.0),
        onPressed: () => onPressed(context),
        child: Container(
            padding: EdgeInsets.only(
                top: 5.0, left: 10.0, right: 10.0, bottom: 20.0),
            decoration: BoxDecoration(
                border: Border.all(color: DweTheme.purple),
                borderRadius: BorderRadius.circular(10.0),
                color: DweTheme.yellowLight,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      spreadRadius: 1.0)
                ]),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(title,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black))
                            .tr(),
                        SizedBox(height: 10.0),
                        child,
                        SizedBox(width: 15.0)
                      ])),
                  editable ? Icon(Icons.edit) : SizedBox(),
                ])));
  }
}

showAboutDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AboutDialog(
            applicationName: 'Deutsche Wohnen & Co. Enteignen',
            applicationIcon:
                Image.asset('assets/images/logo_transparent.png', width: 40.0),
            applicationVersion: version,
            children: [
              SizedBox(
                  height: 230,
                  child: Image.asset('assets/images/housy_info.png')),
              SizedBox(height: 15.0),
              Text(
                  'Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\n\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreib uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.'),
              SizedBox(height: 15.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                RichText(
                    text: TextSpan(
                        text: 'Gitlab-Repository',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.indigo,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch(
                              'https://gitlab.com/kybernetik/sammel-app'))),
                RichText(
                    text: TextSpan(
                        text: 'app@dwenteignen.de',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.indigo,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch('mailto:app@dwenteignen.de')))
              ])
            ],
          ));
}
