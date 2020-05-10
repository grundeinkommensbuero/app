import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionCreator.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'TermineSeite.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
***REMOVED***

class HomeState extends State<Home> {
  int navigation = 0;
  List<int> history = [0];
  GlobalKey actionPage = GlobalKey(debugLabel: 'action page');

  @override
  void initState() {
    super.initState();
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    var pages = [
      TermineSeite(key: actionPage),
      ActionCreator(newActionCreated)
    ];
    List<String> titles = ['Aktionen', 'Zum Sammeln aufrufen'];

    return WillPopScope(
      onWillPop: () => navigateBack(),
      child: Scaffold(
        key: Key('home page'),
        drawerScrimColor: Colors.black26,
        drawer: buildDrawer(),
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(titles[navigation]),
            Image.asset('assets/images/logo.png', width: 50.0)
          ],
        )),
        body: IndexedStack(children: pages, index: navigation),
      ),
    );
  ***REMOVED***

  Future<bool> navigateBack() async {
    if (history.isEmpty)
      return true;
    else {
      history.removeLast();
      setState(() => navigation = history.last);
      return false;
    ***REMOVED***
  ***REMOVED***

  SizedBox buildDrawer() {
    return SizedBox(
        width: 200.0,
        child: Drawer(
            key: Key('navigation drawer'),
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1.0],
                    colors: <Color>[DweTheme.yellow, Colors.yellowAccent],
                  ),
                ),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 0.0),
                  children: <Widget>[
                    Image.asset("assets/images/dwe.png"),
                    SizedBox(
                      height: 25.0,
                    ),
                    menuEntry(
                        title: 'Aktionen',
                        subtitle:
                            'Aktionen in einer Liste oder Karte anschauen',
                        index: 0),
                    menuEntry(
                        key: Key('create action button'),
                        title: 'Zum Sammeln einladen',
                        subtitle: 'Eine Sammel-Aktion ins Leben rufen',
                        index: 1),
                    menuEntry(
                        title: 'Fragen und Antworten',
                        subtitle: 'Tipps, Tricks und Argumentationshilfen',
                        index: 0),
                  ],
                ))));
  ***REMOVED***

  Container menuEntry(
      {Key key, String title = '', String subtitle = '', int index = 0***REMOVED***) {
    var selected = navigation == index;
    return Container(
        key: key,
        padding: EdgeInsets.symmetric(vertical: selected ? 15.0 : 10.0),
        decoration: BoxDecoration(
            color: selected ? DweTheme.purple : Colors.transparent),
        child: ListTile(
            title: Text(
              title,
              style: selected
                  ? DweTheme.menuCaptionSelected
                  : DweTheme.menuCaption,
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: selected ? Colors.amber : Colors.black54),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() => navigation = index);
              history.add(navigation);
            ***REMOVED***));
  ***REMOVED***

  newActionCreated(List<Termin> actions) =>
      actions.forEach((action) => (actionPage.currentState as TermineSeiteState)
          .createNewAction(actions[0]));
***REMOVED***
