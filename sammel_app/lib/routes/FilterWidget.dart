import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/KiezPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';

class FilterWidget extends StatefulWidget {
  final void Function(TermineFilter) onApply;

  FilterWidget(this.onApply, {Key key***REMOVED***) : super(key: key);

  @override
  FilterWidgetState createState() => FilterWidgetState();
***REMOVED***

class FilterWidgetState extends State<FilterWidget>
    with TickerProviderStateMixin {
  TermineFilter filter = TermineFilter.leererFilter();
  var _initialized = false;

  var _zeroPadding = MaterialTapTargetSize.shrinkWrap;

  var buttonText = "Filter";
  var expanded = false;

  StorageService storageService;
  List<Kiez> allLocations;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) initialize(context);

    return Column(
      children: [
        !expanded
            ? Container(color: Color.fromARGB(255, 149, 48, 118))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FilterElement(
                    key: Key("type button"),
                    child: Text(artButtonBeschriftung()),
                    selectionFunction: typeSelection,
                    resetFunction: resetType,
                  ),
                  FilterElement(
                    key: Key("days button"),
                    child: tageButtonBeschriftung(),
                    selectionFunction: daysSelection,
                    resetFunction: resetDays,
                  ),
                  FilterElement(
                      key: Key("time button"),
                      child: Text(uhrzeitButtonBeschriftung(filter)),
                      selectionFunction: timeSelection,
                      resetFunction: resetTime),
                  FilterElement(
                    key: Key("locations button"),
                    child: Text(ortButtonBeschriftung(filter)),
                    selectionFunction:
                        allLocations != null ? locationSelection : null,
                    resetFunction: resetLocations,
                  ),
                ],
              ),
        SizedBox(
            width: double.infinity,
            height: 50.0,
            child: RaisedButton(
              key: Key("filter button"),
              color: Color.fromARGB(255, 129, 28, 98),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.zero, bottom: Radius.elliptical(15.0, 20.0))),
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
    );
  ***REMOVED***

  // Kann nicht im Konstruktor ausgeführt werden, weil der Provider den context braucht, der ins build reingereicht wird
  void initialize(BuildContext context) {
    storageService = Provider.of<StorageService>(context);
    storageService.loadFilter().then((filter) => setState(() {
          this.filter = filter != null ? filter : TermineFilter.leererFilter();
          widget.onApply(filter); //lade initial Termine
        ***REMOVED***));
    Provider.of<StammdatenService>(context)
        .kieze
        .then((locations) => setState(() => allLocations = locations));
    _initialized = true;
  ***REMOVED***

  Text tageButtonBeschriftung() {
    if (filter.tage == null || filter.tage.isEmpty) {
      return Text("alle Tage,");
    ***REMOVED*** else {
      return Text("am " +
          filter.tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",");
    ***REMOVED***
  ***REMOVED***

  String artButtonBeschriftung() {
    return filter.typen != null && filter.typen.isNotEmpty
        ? filter.typen.join(", ")
        : "Alle Aktions-Arten,";
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
    return "in " + filter.orte.map((ort) => ort).toList().join(", ");
  ***REMOVED***

  void onApply() {
    setState(() {
      if (expanded) {
        buttonText = "Filter";
        expanded = false;
        widget.onApply(filter);
        storageService.saveFilter(filter);
      ***REMOVED*** else {
        buttonText = "Anwenden";
        expanded = true;
      ***REMOVED***
    ***REMOVED***);
  ***REMOVED***

  typeSelection() async {
    List<String> moeglicheTypen = ['Sammeln', 'Infoveranstaltung'];
    List<String> ausgewTypen = List<String>()
      ..addAll(filter.typen == null ? [] : filter.typen);
    await showDialog<List<String>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  key: Key('type selection dialog'),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.zero,
                  title: AppBar(
                      leading: null,
                      automaticallyImplyLeading: false,
                      title: const Text('Wähle Aktions-Arten')),
                  children:
                      List.of(moeglicheTypen.map((typ) => CheckboxListTile(
                            checkColor: Colors.black,
                            activeColor: DweTheme.yellowLight,
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
                          )))
                        ..add(RaisedButton(
                            child: Text('Fertig'),
                            onPressed: () => Navigator.pop(context))));
            ***REMOVED***));

    setState(() => filter.typen = ausgewTypen);
  ***REMOVED***

  resetType() => setState(() => filter.typen = []);

  daysSelection() async {
    var selectedDates = await showMultipleDatePicker(filter.tage, context,
        key: Key('days selection dialog'));
    setState(() {
      if (selectedDates != null)
        filter.tage = selectedDates..sort((dt1, dt2) => dt1.compareTo(dt2));
    ***REMOVED***);
  ***REMOVED***

  resetDays() => setState(() => filter.tage = []);

  timeSelection() async {
    TimeRange timeRange =
        await showTimeRangePicker(context, filter.von, filter.bis);
    setState(() {
      filter.von = timeRange.from;
      filter.bis = timeRange.to;
    ***REMOVED***);
  ***REMOVED***

  resetTime() => setState(() {
        filter.von = null;
        filter.bis = null;
      ***REMOVED***);

  locationSelection() async {
    var selectedLocations = await KiezPicker(allLocations
            .where((kiez) => filter.orte.contains(kiez.kiez))
            .toList())
        .showKiezPicker(context);

    if(selectedLocations == null) return;
    setState(() => filter.orte = selectedLocations.map((k) => k.kiez).toList());
  ***REMOVED***

  resetLocations() => setState(() => filter.orte = []);
***REMOVED***

class FilterElement extends StatelessWidget {
  final _zeroPadding = MaterialTapTargetSize.shrinkWrap;
  final Widget child;
  final Function selectionFunction;
  final Function resetFunction;

  FilterElement({key, this.child, this.selectionFunction, this.resetFunction***REMOVED***)
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: FlatButton(
            color: Color.fromARGB(255, 149, 48, 118),
            textColor: Colors.amberAccent,
            shape: Border(),
            materialTapTargetSize: _zeroPadding,
            padding: EdgeInsetsDirectional.zero,
            onPressed: selectionFunction,
            child: Container(
              color: Color.fromARGB(255, 149, 48, 118),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: child),
                                  Icon(
                                    Icons.create,
                                    size: 18.0,
                                  )
                                ]))),
                    FlatButton(
                      textColor: Colors.amberAccent,
                      shape: Border(
                          left: BorderSide(width: 2.0, color: DweTheme.purple)),
                      materialTapTargetSize: _zeroPadding,
                      onPressed: resetFunction,
                      child: Icon(
                        Icons.clear,
                        size: 18.0,
                      ),
                    )
                  ]),
            )));
  ***REMOVED***
***REMOVED***
