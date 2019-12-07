import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sammel_app/model/Ort.dart';

Future<List<Ort>> showMultipleLocationPicker(
    BuildContext context, final List<Ort> previousLocations, final allLocations,
    {bool multiple = false***REMOVED***) async {
  List<BezirkItem> districs =
      erzeugeBezirkDaten(List.from(previousLocations), allLocations);
  await showDialog<List<int>>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
            List<int> selectedLocations =
                previousLocations?.map((ort) => ort.id).toList();
            if (selectedLocations == null)
              selectedLocations = []; // Null-Sicherheit

            return SimpleDialog(
                title: multiple
                    ? const Text('Wähle einen oder mehrere Orte')
                    : const Text('Wähle einen Ort'),
                children: <Widget>[
                  ExpansionPanelList(
                      expansionCallback: (int index, bool expanded) {
                        setDialogState(() {
                          districs[index].expanded = !expanded;
                        ***REMOVED***);
                      ***REMOVED***,
                      children: expansionPanelListe(
                          context,
                          allLocations,
                          selectedLocations,
                          districs,
                          setDialogState,
                          multiple)),
                  multiple
                      ? RaisedButton(
                          child: Text('Fertig'),
                          onPressed: () => Navigator.pop(context))
                      : RaisedButton(
                          child: Text('Keine Auswahl'),
                          onPressed: () {
                            eraseSelections(districs);
                            Navigator.pop(context);
                          ***REMOVED***,
                        )
                ]);
          ***REMOVED***));
  return districs
      .expand((bezirk) => bezirk.ortAuswahl.entries)
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();
***REMOVED***

List<BezirkItem> erzeugeBezirkDaten(
    List<Ort> selectedLocations, List<Ort> allLocations) {
  var bezirkNamen = allLocations.map((ort) => ort.bezirk).toSet();
  return bezirkNamen
      .map((name) => BezirkItem(
          name,
          Map<Ort, bool>()
            ..addEntries(allLocations.where((ort) => ort.bezirk == name).map(
                (ort) => MapEntry(
                    ort,
                    selectedLocations
                        .any((filterOrt) => filterOrt.id == ort.id)))),
          false))
      .toList();
***REMOVED***

List<ExpansionPanel> expansionPanelListe(
    BuildContext context,
    List<Ort> orte,
    List<int> ausgewOrte,
    List<BezirkItem> districts,
    Function setdialogState,
    bool multiple) {
  return districts
      .map((item) => expansionPanel(
          context, item, orte, ausgewOrte, setdialogState, districts, multiple))
      .toList();
***REMOVED***

ExpansionPanel expansionPanel(
    BuildContext context,
    BezirkItem disctrict,
    List<Ort> locations,
    List<int> selLoc,
    Function setDialogState,
    List<BezirkItem> districts,
    bool multiple) {
  return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) => multiple
          ? disctrictCheckbox(disctrict, locations, selLoc, setDialogState)
          : disctrictPanel(disctrict, locations, selLoc, setDialogState),
      canTapOnHeader: true,
      isExpanded: disctrict.expanded,
      body: Column(
          children: disctrict.ortAuswahl.keys
              .map((ort) => multiple
                  ? locationCheckbox(ort, disctrict, setDialogState)
                  : locationButton(context, ort, disctrict, districts))
              .toList()));
***REMOVED***

ListTile disctrictPanel(BezirkItem item, List<Ort> orte,
    List<int> selectedLocations, Function setDialogState) {
  return ListTile(
    title: Text(item.bezirk),
  );
***REMOVED***

CheckboxListTile disctrictCheckbox(BezirkItem item, List<Ort> locations,
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
      ortStammdaten.bezirk != bezirk || ausgewOrte.contains(ortStammdaten.id));
***REMOVED***

CheckboxListTile locationCheckbox(Ort ort, BezirkItem bezirk, setDialogState) {
  return CheckboxListTile(
    value: bezirk.ortAuswahl[ort],
    title: Text('      ' + ort.ort),
    onChanged: (bool wurdeAusgewaehlt) {
      setDialogState(() => bezirk.ortAuswahl[ort] = wurdeAusgewaehlt);
    ***REMOVED***,
  );
***REMOVED***

ListTile locationButton(BuildContext context, Ort location, BezirkItem district,
    List<BezirkItem> districts) {
  return ListTile(
    title: FlatButton(
        padding: EdgeInsets.zero,
        child: Text('      ' + location.ort),
        textTheme: district.ortAuswahl[location]
            ? ButtonTextTheme.accent
            : ButtonTextTheme.normal,
        onPressed: () {
          eraseSelections(districts);
          district.ortAuswahl[location] = true;
          return Navigator.pop(context);
        ***REMOVED***),
  );
***REMOVED***

void eraseSelections(List<BezirkItem> districts) {
  districts.forEach((district) => district.ortAuswahl.keys
      .forEach((location) => district.ortAuswahl[location] = false));
***REMOVED***

class BezirkItem {
  String bezirk;
  Map<Ort, bool> ortAuswahl;
  bool expanded;

  BezirkItem(this.bezirk, this.ortAuswahl, this.expanded);

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
        expanded.toString() +
        ')';
  ***REMOVED***
***REMOVED***
