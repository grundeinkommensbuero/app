import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class LocationPicker {
  List<Kiez> locations = [];
  List<DistrictItem> districts;
  Key key;
  bool multiMode;

  LocationPicker(
      {final this.key, final this.locations, this.multiMode = false});

  Future<List<Kiez>> showLocationPicker(
      final context, final List<Kiez> previousSelection) async {
    this.districts =
        _generateDistrictList(List.from(previousSelection), locations);

    await showDialog<List<int>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              List<String> selectedLocations =
                  previousSelection?.map((ort) => ort.plz)?.toList();
              if (selectedLocations == null)
                selectedLocations = []; // Null-Sicherheit

              return SimpleDialog(
                  key: key,
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.zero,
                  title: AppBar(
                      leading: null,
                      automaticallyImplyLeading: false,
                      title: multiMode
                          ? const Text('Wähle einen oder mehrere Orte')
                          : const Text('Wähle einen Ort')),
                  children: List.of(_expansionTileList(context, locations,
                      selectedLocations, districts, setDialogState))
                    ..add(multiMode
                        ? RaisedButton(
                            child: Text('Fertig'),
                            onPressed: () => Navigator.pop(context))
                        : RaisedButton(
                            child: Text('Keine Auswahl'),
                            onPressed: () {
                              _eraseSelections(districts);
                              Navigator.pop(context);
                            },
                          )));
            }));
    return districts
        .expand((bezirk) => bezirk.locationSelection.entries)
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  List<DistrictItem> _generateDistrictList(
      List<Kiez> selectedLocations, List<Kiez> allLocations) {
    var bezirkNamen = allLocations.map((ort) => ort.bezirk).toSet();
    return bezirkNamen
        .map((name) => DistrictItem(
            name,
            Map<Kiez, bool>()
              ..addEntries(allLocations.where((ort) => ort.bezirk == name).map(
                  (ort) => MapEntry(
                      ort,
                      selectedLocations
                          .any((filterOrt) => filterOrt.plz == ort.plz)))),
            false))
        .toList();
  }

  List<ExpansionTile> _expansionTileList(
      BuildContext context,
      List<Kiez> orte,
      List<String> ausgewOrte,
      List<DistrictItem> districts,
      Function setdialogState) {
    return districts
        .map((item) => _expansionTile(
            context, item, orte, ausgewOrte, setdialogState, districts))
        .toList();
  }

  ExpansionTile _expansionTile(
      BuildContext context,
      DistrictItem disctrict,
      List<Kiez> locations,
      List<String> selLoc,
      Function setDialogState,
      List<DistrictItem> districts) {
    return ExpansionTile(
        title: multiMode
            ? _disctrictCheckbox(disctrict, locations, selLoc, setDialogState)
            : _disctrictTile(disctrict, locations, selLoc, setDialogState),
        initiallyExpanded: disctrict.expanded,
        children: disctrict.locationSelection.keys
            .map((ort) => multiMode
                ? _locationCheckbox(ort, disctrict, setDialogState)
                : _locationButton(context, ort, disctrict, districts))
            .toList());
  }

  ListTile _disctrictTile(DistrictItem item, List<Kiez> orte,
      List<String> selectedLocations, Function setDialogState) {
    return ListTile(
      title: Text(item.districtName),
    );
  }

  CheckboxListTile _disctrictCheckbox(DistrictItem item, List<Kiez> locations,
      List<String> ausgewOrte, Function setDialogState) {
    return CheckboxListTile(
      checkColor: DweTheme.yellow,
      value: item.locationSelection.values
          .every((ausgewaehlt) => ausgewaehlt == true),
      title: Text(
        item.districtName,
        style: TextStyle(color: Colors.black),
      ),
      onChanged: (bool ausgewaehlt) {
        setDialogState(() {
          if (ausgewaehlt) {
            item.locationSelection.keys
                .forEach((ort) => item.locationSelection[ort] = true);
          } else {
            item.locationSelection.keys
                .forEach((ort) => item.locationSelection[ort] = false);
          }
        });
      },
    );
  }

  CheckboxListTile _locationCheckbox(
      Kiez ort, DistrictItem bezirk, setDialogState) {
    return CheckboxListTile(
      checkColor: DweTheme.yellow,
      value: bezirk.locationSelection[ort],
      title: Text('      ' + ort.plz),
      onChanged: (bool wurdeAusgewaehlt) {
        setDialogState(() => bezirk.locationSelection[ort] = wurdeAusgewaehlt);
      },
    );
  }

  ListTile _locationButton(BuildContext context, Kiez location,
      DistrictItem district, List<DistrictItem> districts) {
    return ListTile(
      title: FlatButton(
          padding: EdgeInsets.zero,
          child: Text('      ' + location.plz),
          textTheme: district.locationSelection[location]
              ? ButtonTextTheme.accent
              : ButtonTextTheme.normal,
          onPressed: () {
            _eraseSelections(districts);
            district.locationSelection[location] = true;
            return Navigator.pop(context);
          }),
    );
  }

  void _eraseSelections(List<DistrictItem> districts) {
    districts.forEach((district) => district.locationSelection.keys
        .forEach((location) => district.locationSelection[location] = false));
  }
}

class DistrictItem {
  String districtName;
  Map<Kiez, bool> locationSelection;
  bool expanded;

  DistrictItem(this.districtName, this.locationSelection, this.expanded);

  @override
  String toString() {
    return districtName +
        ':' +
        locationSelection.entries
            .map((entry) =>
                jsonEncode(entry.key) + ' (' + entry.value.toString() + ') ')
            .toList()
            .toString() +
        ' (' +
        expanded.toString() +
        ')';
  }
}
