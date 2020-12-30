import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/main.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/KiezPicker.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
***REMOVED***

class ProfilePageState extends State<ProfilePage> {
  var init = false;
  StorageService storageService;
  AbstractUserService userService;
  StammdatenService stammdatenService;
  String name = '';
  List<String> myKieze = [];
  String notification;

  static const notificationOptions = [
    'sofort',
    'täglich',
    'wöchentlich',
    'nie'
  ];

  @override
  Widget build(BuildContext context) {
    if (init == false) {
      storageService = Provider.of<StorageService>(context);
      userService = Provider.of<AbstractUserService>(context);
      stammdatenService = Provider.of<StammdatenService>(context);
      userService.user.listen((user) => setState(() => name = user.name));
      storageService
          .loadMyKiez()
          .then((kieze) => setState(() => myKieze = kieze));
      storageService
          .loadNotificationPreference()
          .then((pref) => setState(() => notification = pref));
      init = true;
    ***REMOVED***
    var kiezeCaption = (myKieze ?? []).join(', ');

    return Scaffold(
        body: Container(
            decoration: DweTheme.happyHouseBackground,
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: [
                ProfileItem(
                  title: "Dein Name",
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        name ?? '',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: (28.0 - ((name ?? '').length) / 4)),
                      )),
                  onPressed: (context) =>
                      showUsernameDialog(context: context, hideHint: true),
                ),
                SizedBox(height: 20.0),
                ProfileItem(
                    title: "Dein Kiez",
                    child: Container(
                        child: Column(children: [
                      Text(
                        kiezeCaption,
                        maxLines: 20,
                        style: TextStyle(
                            fontSize:
                                (28.0 - ((kiezeCaption ?? '').length) / 9)),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Mit deinen Kiezen bestimmst du wo du über neue Aktionen informiert werden willst.',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      )
                    ])),
                    onPressed: (_) => showKiezPicker()),
                SizedBox(height: 20.0),
                ProfileItem(
                    title: "Deine Benachtichtigungen",
                    child: Container(
                        child: Column(children: [
                      Text(notification ?? 'nie',
                          style: TextStyle(fontSize: 28.0)),
                      SizedBox(height: 10.0),
                      Text(
                        'Wie oft und aktuell willst du über neue Sammel-Aktionen in deinem Kiez informiert werden?',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      )
                    ])),
                    onPressed: (context) => showNotificationDialog(context))
              ],
            )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.info),
            onPressed: () => showAboutDialog(context)));
  ***REMOVED***

  showKiezPicker() async {
    var allLocations = await stammdatenService.kieze;
    var selection = (await KiezPicker(allLocations
                .where((kiez) => myKieze.contains(kiez.kiez))
                .toList())
            .showKiezPicker(context))
        .map((kiez) => kiez.kiez)
        .toList();
    storageService.saveMyKiez(selection);
    setState(() => myKieze = selection);
  ***REMOVED***

  showNotificationDialog(BuildContext context) async {
    var selection = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            key: Key('notification selection dialog'),
            contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
            titlePadding: EdgeInsets.all(15.0),
            title: const Text(
                'Wie häufig möchtest du Infos über anstehende Aktionen bekommen?'),
            children: []
              ..addAll(notificationOptions.map((option) => RadioListTile(
                    groupValue: notification,
                    value: option,
                    title: Text(option),
                    onChanged: (selected) => Navigator.pop(context, selected),
                  )))));

    storageService.saveNotificationPreference(selection);
    setState(() => notification = selection);
  ***REMOVED***
***REMOVED***

showAboutDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AboutDialog(
            applicationName: 'Deutsche Wohnen & Co. Enteignen',
            applicationIcon:
                Image.asset('assets/images/housy_info.png', width: 80.0),
            applicationVersion: version,
            children: [
              SizedBox(height: 15.0),
              Text(
                  'Diese App wurde von einem kleinen Team enthusiastischer IT-Aktivist*innen für die Deutsche Wohnen & Co. Enteignen - Kampagne entwickelt und steht unter einer freien Lizenz.\n\nWenn du Interesse daran hast diese App für dein Volksbegehren einzusetzen, dann schreibt uns doch einfach eine Mail oder besuche uns auf unserer Webseite. So kannst du uns auch Fehler und Probleme mit der App melden.'),
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
                        text: 'e@mail.com',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.indigo,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch('e@mail.com')))
              ])
            ],
          ));
***REMOVED***

class ProfileItem extends StatelessWidget {
  Widget child;
  String title;
  Function(BuildContext) onPressed;

  ProfileItem({Widget this.child, this.title = '', this.onPressed***REMOVED***) {
    assert(child != null);
  ***REMOVED***

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
                color: DweTheme.yellowLight),
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
                                color: Colors.black)),
                        SizedBox(height: 10.0),
                        child,
                        SizedBox(width: 15.0)
                      ])),
                  Icon(Icons.edit),
                ])));
  ***REMOVED***
***REMOVED***
