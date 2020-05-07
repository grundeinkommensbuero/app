import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/routes/ActionEditor.dart';

import 'NavigationDrawer.dart';

class ActionCreator extends StatefulWidget {
  static String NAME = 'Action Creator';

  @override
  State<StatefulWidget> createState() => ActionCreatorState();
}

class ActionCreatorState extends State<ActionCreator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('action creator'),
      extendBody: true,
      drawerScrimColor: Colors.black26,
      drawer: NavigationDrawer(ActionCreator),
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Zum Sammeln aufrufen'),
          Image.asset('assets/images/logo.png', width: 50.0)
        ],
      )),
      body: ActionEditor(null, key: Key('action editor creator')),
    );
  }

  void openCreateDialog(BuildContext context) {}
}
