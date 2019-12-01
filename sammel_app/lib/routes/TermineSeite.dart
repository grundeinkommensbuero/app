import 'dart:convert';

import 'package:calendarro/calendarro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title***REMOVED***) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
***REMOVED***

class _TermineSeiteState extends State<TermineSeite> {
  static var termineService;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  bool initialized = false;
  List<Termin> termine = [];

  FilterWidget filterWidget;

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      termineService = Provider.of<TermineService>(context);
      filterWidget = FilterWidget(() => ladeTermine());
      ladeTermine();
      initialized = true;
    ***REMOVED***
    // TODO: Memory-Leak beheben
    return Scaffold(
      extendBody: true,
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
    );
  ***REMOVED***

  void ladeTermine() {
    termineService.ladeTermine(filterWidget.filter).then((termine) {
      setState(() {
        this.termine = termine;
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***

  oeffneFilter() {***REMOVED***
***REMOVED***

class FilterWidget extends StatefulWidget {
  void Function() onAnwenden;
  TermineFilter filter = TermineFilter.leererFilter();

  FilterWidget(void Function() this.onAnwenden, {Key key***REMOVED***) : super(key: key);

  @override
  _FilterWidget createState() => _FilterWidget();
***REMOVED***

class _FilterWidget extends State<FilterWidget> with TickerProviderStateMixin {
  var _zeroPadding = MaterialTapTargetSize.shrinkWrap;

  var buttonText = "Filter";
  var filterOffen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 100),
      child: Column(
        children: [
          !filterOffen
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => artAuswahl(),
                          child: Text(artButtonBeschriftung()),
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => {***REMOVED***,//tageAuswahl(),
                          child: Text("alle Tage,"),
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => zeitAuswahl(),
                          child: Text(uhrzeitButtonBeschriftung(widget.filter)),
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => ortAuswahl(),
                          child: Text(ortButtonBeschriftung(widget.filter)),
                        )),
                  ],
                ),
          SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Color.fromARGB(255, 129, 28, 98),
                textColor: Colors.amberAccent,
                materialTapTargetSize: _zeroPadding,
                child: Text(buttonText),
                onPressed: () => onClicked(),
              )),
        ],
      ),
    );
  ***REMOVED***

  String artButtonBeschriftung() {
    return widget.filter.typen != null && widget.filter.typen.isNotEmpty
        ? widget.filter.typen.join(", ")
        : "Alle Termin-Arten,";
  ***REMOVED***

  static String uhrzeitButtonBeschriftung(TermineFilter filter) {
    String beschriftung = '';
    if (filter.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToString(filter.von);
    if (filter.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToString(filter.bis);
    if (beschriftung.isEmpty) beschriftung = 'jederzeit';
    beschriftung += ',';
    return beschriftung;
  ***REMOVED***

  String ortButtonBeschriftung(TermineFilter filter) {
    if (filter?.orte == null || filter.orte.isEmpty) return "überall";
    return "in " + filter.orte.map((ort) => ort.ort).toList().join(", ");
  ***REMOVED***

  void onClicked() {
    setState(() {
      if (filterOffen) {
        buttonText = "Filter";
        filterOffen = false;
        widget.onAnwenden();
      ***REMOVED*** else {
        buttonText = "Anwenden";
        filterOffen = true;
      ***REMOVED***
    ***REMOVED***);
  ***REMOVED***

  artAuswahl() async {
    List<String> moeglicheTypen = ['Sammel-Termin', 'Info-Veranstaltung'];
    List<String> ausgewTypen = List<String>()..addAll(widget.filter.typen);
    await showDialog<List<String>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  title: const Text('Wähle Termin-Arten'),
                  children: <Widget>[
                    ...moeglicheTypen.map((typ) => CheckboxListTile(
                          value: ausgewTypen.contains(typ),
                          title: Text(typ),
                          onChanged: (neuerWert) {
                            setDialogState(() {
                              if (neuerWert) {
                                ausgewTypen.add(typ);
                              ***REMOVED*** else {
                                ausgewTypen.remove(typ);
                              ***REMOVED***
                            ***REMOVED***);
                          ***REMOVED***,
                        )),
                    RaisedButton(
                        child: Text('Fertig'),
                        onPressed: () => Navigator.pop(context))
                  ]);
            ***REMOVED***));

    setState(() {
      widget.filter.typen = ausgewTypen;
    ***REMOVED***);
  ***REMOVED***

  tageAuswahl() async {
    var jetzt = DateTime.now();
    await showDialog<List<int>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              List<int> ausgewOrte =
                  widget.filter.orte?.map((ort) => ort.id).toList();
              if (ausgewOrte == null) ausgewOrte = []; // Null-Sicherheit

              return SimpleDialog(children: <Widget>[
                Calendarro(
                  displayMode: DisplayMode.MONTHS,
                )
              ]);
            ***REMOVED***));
  ***REMOVED***

  zeitAuswahl() async {
    var von = await zeigeZeitAuswahl('von', widget.filter.von?.hour ?? 12);
    var bis = await zeigeZeitAuswahl('bis', widget.filter.bis?.hour ?? 12);

    setState(() {
      widget.filter.von = von;
      widget.filter.bis = bis;
    ***REMOVED***);
  ***REMOVED***

  Future<TimeOfDay> zeigeZeitAuswahl(String titel, int startStunde) =>
      showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: startStunde, minute: 0),
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: Container(
                  child: Column(
                children: <Widget>[Text(titel), child],
              )),
            );
          ***REMOVED***);

  ortAuswahl() async {
    var orte = await Provider.of<StammdatenService>(context).ladeOrte();
    List<BezirkItem> bezirke = erzeugeBezirkDaten(orte);
    await showDialog<List<int>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              List<int> ausgewOrte =
                  widget.filter.orte?.map((ort) => ort.id).toList();
              if (ausgewOrte == null) ausgewOrte = []; // Null-Sicherheit

              return SimpleDialog(
                  title: const Text('Wähle einen oder mehrere Orte'),
                  children: <Widget>[
                    ExpansionPanelList(
                        expansionCallback: (int index, bool ausgeklappt) {
                          setDialogState(() {
                            bezirke[index].ausgeklappt = !ausgeklappt;
                          ***REMOVED***);
                        ***REMOVED***,
                        children: expansionPanelListe(
                            orte, ausgewOrte, bezirke, setDialogState)),
                    RaisedButton(
                        child: Text('Fertig'),
                        onPressed: () => Navigator.pop(context, ausgewOrte))
                  ]);
            ***REMOVED***));

    setState(() {
      widget.filter.orte = bezirke
          .expand((bezirk) => bezirk.ortAuswahl.entries)
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
    ***REMOVED***);
  ***REMOVED***

  List<BezirkItem> erzeugeBezirkDaten(List<Ort> orte) {
    var bezirkNamen = orte.map((ort) => ort.bezirk).toSet();
    return bezirkNamen
        .map((name) => BezirkItem(
            name,
            Map<Ort, bool>()
              ..addEntries(orte.where((ort) => ort.bezirk == name).map((ort) =>
                  MapEntry(
                      ort,
                      widget.filter.orte
                          .any((filterOrt) => filterOrt.id == ort.id)))),
            false))
        .toList();
  ***REMOVED***

  List<ExpansionPanel> expansionPanelListe(List<Ort> orte, List<int> ausgewOrte,
      List<BezirkItem> bezirke, Function setdialogState) {
    return bezirke
        .map((item) => expansionPanel(item, orte, ausgewOrte, setdialogState))
        .toList();
  ***REMOVED***

  ExpansionPanel expansionPanel(BezirkItem bezirk, List<Ort> orte,
      List<int> ausgewOrte, Function setdialogState) {
    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) =>
            bezirkCheckbox(bezirk, orte, ausgewOrte, setdialogState),
        canTapOnHeader: true,
        isExpanded: bezirk.ausgeklappt,
        body: Column(
            children: bezirk.ortAuswahl.keys
                .map((ort) => ortCheckbox(ort, bezirk, setdialogState))
                .toList()));
  ***REMOVED***

  CheckboxListTile bezirkCheckbox(BezirkItem item, List<Ort> orte,
      List<int> ausgewOrte, Function setDialogState) {
    return CheckboxListTile(
      value: item.ortAuswahl.values.every((ausgewaehlt) => ausgewaehlt == true),
      title: Text(item.bezirk),
      onChanged: (bool ausgewaehlt) {
        setDialogState(() {
          if (ausgewaehlt) {
            item.ortAuswahl.keys.forEach((ort) => item.ortAuswahl[ort] = true);
          ***REMOVED*** else {
            item.ortAuswahl.keys.forEach((ort) => item.ortAuswahl[ort] = false);
          ***REMOVED***
        ***REMOVED***);
      ***REMOVED***,
    );
  ***REMOVED***

  bool alleOrteDesBezirksAusgewaehlt(
      String bezirk, List<Ort> orte, List<int> ausgewOrte) {
    return orte.every((ortStammdaten) =>
        ortStammdaten.bezirk != bezirk ||
        ausgewOrte.contains(ortStammdaten.id));
  ***REMOVED***

  CheckboxListTile ortCheckbox(Ort ort, BezirkItem bezirk, setDialogState) {
    return CheckboxListTile(
      value: bezirk.ortAuswahl[ort],
      title: Text('      ' + ort.ort),
      onChanged: (bool wurdeAusgewaehlt) {
        print('Wert: ' + wurdeAusgewaehlt.toString());
        print('Vorher: ' + bezirk.ortAuswahl[ort].toString());
        setDialogState(() => bezirk.ortAuswahl[ort] = wurdeAusgewaehlt);
        print('Nachher: ' + bezirk.ortAuswahl[ort].toString());
      ***REMOVED***,
    );
  ***REMOVED***
***REMOVED***

class BezirkItem {
  String bezirk;
  Map<Ort, bool> ortAuswahl;
  bool ausgeklappt;

  BezirkItem(this.bezirk, this.ortAuswahl, this.ausgeklappt);

  @override
  String toString() {
    return bezirk +
        ':' +
        ortAuswahl.entries
            .map((entry) =>
                jsonEncode(entry.key) + ' (' + entry.value.toString() + ') ')
            .toList()
            .toString() +
        ' (' +
        ausgeklappt.toString() +
        ')';
  ***REMOVED***
***REMOVED***
