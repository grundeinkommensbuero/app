import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final Function openActionDetails;
  final Function isMyAction;

  ActionMap(this.termine, this.isMyAction, this.openActionDetails, {Key key})
      : super(key: key);

  @override
  ActionMapState createState() => ActionMapState();
}

class ActionMapState extends State<ActionMap> {
  ActionMapState();

  @override
  Widget build(BuildContext context) {
    return Text('Action Map');
  }
}