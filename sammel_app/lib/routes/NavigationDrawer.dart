import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/services/RoutingService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'package:sammel_app/routes/ActionCreator.dart';
import 'package:sammel_app/routes/TermineSeite.dart';

import 'ActionCreator.dart';

class NavigationDrawer extends StatelessWidget {
  final Type youAreHere;
  RoutingService routingProvider;

  NavigationDrawer(Type this.youAreHere);

  @override
  Widget build(BuildContext context) {
    if (routingProvider == null)
      routingProvider = Provider.of<RoutingService>(context);
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
                        selected: youAreHere == TermineSeite,
                        onTap: () =>
                            routeTo(context, TermineSeite, TermineSeite.NAME)),
                    menuEntry(
                        key: Key('create termin button'),
                        title: 'Zum Sammeln einladen',
                        subtitle: 'Eine Sammel-Aktion ins Leben rufen',
                        selected: youAreHere == ActionCreator,
                        onTap: () => routeTo(
                            context, ActionCreator, ActionCreator.NAME)),
                    menuEntry(
                        title: 'Fragen und Antworten',
                        subtitle: 'Tipps, Tricks und Argumentationshilfen',
                        onTap: () => Navigator.pop(context)),
                  ],
                ))));
  ***REMOVED***

  Container menuEntry(
      {Key key,
      String title = '',
      String subtitle = '',
      bool selected = false,
      var onTap***REMOVED***) {
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
            onTap: onTap));
  ***REMOVED***

  routeTo(BuildContext context, Type type, String name) {
    Navigator.pop(context); // Schließe Drawer

    // Kein Routing wenn wir schon auf der Seite sind
    if (type == youAreHere) {
      print('### Breche ab');
      return;
    ***REMOVED***

    if (routingProvider.hasRouteFor(type)) {
      print('### Rekonstruiere Route');
      Navigator.push(context, routingProvider.getRouteFor(type));
    ***REMOVED*** else {
      print('### Erzeuge neue Route');
      Navigator.pushNamed(context, name);
      routingProvider.register(type, ModalRoute.of(context));
    ***REMOVED***
  ***REMOVED***
***REMOVED***
