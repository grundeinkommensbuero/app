import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'FilterWidget.dart';
import 'TerminDetailsWidget.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title***REMOVED***) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
***REMOVED***

class _TermineSeiteState extends State<TermineSeite> {
  static AbstractTermineService termineService;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  bool _initialized = false;
  List<Termin> termine = [];

  FilterWidget filterWidget;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) intialize(context);

    // TODO: Memory-Leak beheben
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title,
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 50.0,
          )
        ],
      )),
      body: Column(
        children: <Widget>[
          filterWidget,
          Expanded(
              child: ListView.builder(
                  itemCount: termine.length,
                  itemBuilder: (context, index) => ListTile(
                      title: TerminCard(termine[index]),
                      contentPadding: EdgeInsets.only(bottom: 0.1)))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          key: Key('create termin button'),
          onPressed: () {
            _displayStepper(context);
          ***REMOVED***,
          icon: Icon(
            Icons.add,
          ),
          label: Text("Zum Sammeln einladen"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  ***REMOVED***

  void intialize(BuildContext context) {
    termineService = Provider.of<AbstractTermineService>(context);
    filterWidget = FilterWidget(ladeTermine);
    _initialized = true;
  ***REMOVED***

  void ladeTermine(TermineFilter filter) {
    termineService.ladeTermine(filter).then((termine) {
      setState(() {
        this.termine = termine;
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***

  _displayStepper(BuildContext context) async {
    List<Future<Termin>> new_meetings = await showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
                titlePadding: EdgeInsets.zero,
                title: AppBar(
                  leading: null,
                  automaticallyImplyLeading: false,
                  title: Text('Aktion erstellen',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Color.fromARGB(255, 129, 28, 98))),
                ),
                contentPadding: EdgeInsets.all(10.0),
                children: <Widget>[
                  ActionEditor(() {
                    print('done');
                  ***REMOVED***)
                ]);
          ***REMOVED***);

    if(new_meetings != null) {
      setState(() {
        for (final termin in new_meetings) {
          termin.then((Termin termin) => termine.add(termin));
        ***REMOVED***
      ***REMOVED***);
    ***REMOVED***
  ***REMOVED***

  openTerminDetailsWidget(BuildContext context, Termin termin) async {
    var terminMitDetails = await termineService.getTerminMitDetails(termin.id);
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              title: AppBar(
                  leading: null,
                  automaticallyImplyLeading: false,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(terminMitDetails.getAsset(), width: 30.0),
                        Container(width: 10.0),
                        Text(terminMitDetails.typ,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: Color.fromARGB(255, 129, 28, 98))),
                      ])),
              key: Key('termin details dialog'),
              contentPadding: EdgeInsets.all(10.0),
              children: <Widget>[
                TerminDetailsWidget(terminMitDetails),
                RaisedButton(
                  key: Key('close termin details button'),
                  child: Text('Schließen'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  ***REMOVED***
***REMOVED***
