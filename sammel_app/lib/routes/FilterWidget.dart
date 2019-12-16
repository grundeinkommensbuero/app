import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/LocationPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';

class FilterWidget extends StatefulWidget {
  void Function(TermineFilter) onApply;
  TermineFilter filter = TermineFilter.leererFilter();

  FilterWidget(void Function(TermineFilter) this.onApply, {Key key***REMOVED***)
      : super(key: key);

  @override
  _FilterWidget createState() => _FilterWidget();
***REMOVED***

class _FilterWidget extends State<FilterWidget> with TickerProviderStateMixin {
  var _zeroPadding = MaterialTapTargetSize.shrinkWrap;

  var buttonText = "Filter";
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 100),
      child: Column(
        children: [
          !expanded
              ? Container(color: Color.fromARGB(255, 149, 48, 118))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        key: Key("type button"),
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => typeSelection(),
                          child: Text(artButtonBeschriftung()),
                        )),
                    SizedBox(
                        key: Key("days button"),
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => daysSelection(),
                          child: tageButtonBeschriftung(),
                        )),
                    SizedBox(
                        key: Key("time button"),
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => timeSelection(),
                          child: Text(uhrzeitButtonBeschriftung(widget.filter)),
                        )),
                    SizedBox(
                        key: Key("locations button"),
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => locationSelection(),
                          child: Text(ortButtonBeschriftung(widget.filter)),
                        )),
                  ],
                ),
          SizedBox(
              width: double.infinity,
              height: 50.0,
              child: RaisedButton(
                key: Key("filter button"),
                color: Color.fromARGB(255, 129, 28, 98),
                textColor: Colors.amberAccent,
                materialTapTargetSize: _zeroPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.playlist_add_check),
                    Text(buttonText,
                        key: Key('filter button text'), textScaleFactor: 1.2),
                    Icon(expanded ? Icons.done : Icons.arrow_drop_down),
                  ],
                ),
                onPressed: onApply,
              )),
        ],
      ),
    );
  ***REMOVED***

  Text tageButtonBeschriftung() {
    if (widget.filter.tage == null || widget.filter.tage.isEmpty) {
      return Text("alle Tage,");
    ***REMOVED*** else {
      return Text("am " +
          widget.filter.tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",");
    ***REMOVED***
  ***REMOVED***

  String artButtonBeschriftung() {
    return widget.filter.typen != null && widget.filter.typen.isNotEmpty
        ? widget.filter.typen.join(", ")
        : "Alle Termin-Arten,";
  ***REMOVED***

  static String uhrzeitButtonBeschriftung(TermineFilter filter) {
    String beschriftung = '';
    if (filter.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(filter.von);
    if (filter.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(filter.bis);
    if (beschriftung.isEmpty) beschriftung = 'jederzeit';
    beschriftung += ',';
    return beschriftung;
  ***REMOVED***

  String ortButtonBeschriftung(TermineFilter filter) {
    if (filter?.orte == null || filter.orte.isEmpty) return "überall";
    return "in " + filter.orte.map((ort) => ort.ort).toList().join(", ");
  ***REMOVED***

  void onApply() {
    setState(() {
      if (expanded) {
        buttonText = "Filter";
        expanded = false;
        widget.onApply(widget.filter);
      ***REMOVED*** else {
        buttonText = "Anwenden";
        expanded = true;
      ***REMOVED***
    ***REMOVED***);
  ***REMOVED***

  typeSelection() async {
    List<String> moeglicheTypen = ['Sammel-Termin', 'Info-Veranstaltung'];
    List<String> ausgewTypen = List<String>()..addAll(widget.filter.typen);
    await showDialog<List<String>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  key: Key('type selection dialog'),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.all(15.0),
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

  daysSelection() async {
    var selectedDates = await showMultipleDatePicker(
        widget.filter.tage, context,
        key: Key('days selection dialog'));
    setState(() {
      if (selectedDates != null)
        widget.filter.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
    ***REMOVED***);
  ***REMOVED***

  timeSelection() async {
    TimeRange timeRange = await showTimeRangePicker(
        context, widget.filter.von?.hour, widget.filter.bis?.hour);
    setState(() {
      widget.filter.von = timeRange.from;
      widget.filter.bis = timeRange.to;
    ***REMOVED***);
  ***REMOVED***

  locationSelection() async {
    var allLocations = await Provider.of<StammdatenService>(context).ladeOrte();

    var selectedLocations = await LocationPicker(
            locations: allLocations, key: Key('locations selection dialog'))
        .showLocationPicker(context, widget.filter.orte, multiple: true);

    setState(() {
      widget.filter.orte = selectedLocations;
    ***REMOVED***);
  ***REMOVED***
***REMOVED***
