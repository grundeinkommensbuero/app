import 'package:flutter/material.dart';
import 'package:sammel_app/Routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import '../services/TermineService.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title***REMOVED***) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
***REMOVED***

class _TermineSeiteState extends State<TermineSeite> {
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  static final _termineService = TermineService();
  List<Termin> termine = [];

  _TermineSeiteState() {
    ladeTermine();
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    // TODO: Memory-Leak beheben
    return Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                color: Color.fromARGB(255, 129, 28, 98),
              ),
            ),
            Image.asset('assets/images/logo.png')
          ],
        )),
        body: Center(
            child: ListView(
                children:
                    termine.map((termin) => TerminCard(termin)).toList())));
  ***REMOVED***

  void ladeTermine() {
    _termineService.ladeTermine().then((termine) {
      setState(() {
        this.termine = termine;
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***
***REMOVED***
