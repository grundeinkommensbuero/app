import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class LocationPicker {
  List<Ort> locations = [];
  List<DistrictItem> districts;
  Key key;
  bool multiMode;

  LocationPicker(
      {final this.key, final this.locations, this.multiMode = false});

  Future<List<Ort>> showLocationPicker(
      final context, final List<Ort> previousSelection) async {
    this.districts =
        _generateDistrictList(List.from(previousSelection), locations);

    await showDialog<List<int>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              List<int> selectedLocations =
                  previousSelection?.map((ort) => ort.id)?.toList();
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
                  children: <Widget>[
                    ..._expansionTileList(context, locations, selectedLocations,
                        districts, setDialogState),
                    multiMode
                        ? RaisedButton(
                            child: Text('Fertig'),
                            onPressed: () => Navigator.pop(context))
                        : RaisedButton(
                            child: Text('Keine Auswahl'),
                            onPressed: () {
                              _eraseSelections(districts);
                              Navigator.pop(context);
                            },
                          )
                  ]);
            }));
    return districts
        .expand((bezirk) => bezirk.locationSelection.entries)
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  List<DistrictItem> _generateDistrictList(
      List<Ort> selectedLocations, List<Ort> allLocations) {
    var bezirkNamen = allLocations.map((ort) => ort.bezirk).toSet();
    return bezirkNamen
        .map((name) => DistrictItem(
            name,
            Map<Ort, bool>()
              ..addEntries(allLocations.where((ort) => ort.bezirk == name).map(
                  (ort) => MapEntry(
                      ort,
                      selectedLocations
                          .any((filterOrt) => filterOrt.id == ort.id)))),
            false))
        .toList();
  }

  List<ExpansionTile> _expansionTileList(
      BuildContext context,
      List<Ort> orte,
      List<int> ausgewOrte,
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
      List<Ort> locations,
      List<int> selLoc,
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

  ListTile _disctrictTile(DistrictItem item, List<Ort> orte,
      List<int> selectedLocations, Function setDialogState) {
    return ListTile(
      title: Text(item.districtName),
    );
  }

  CheckboxListTile _disctrictCheckbox(DistrictItem item, List<Ort> locations,
      List<int> ausgewOrte, Function setDialogState) {
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
      Ort ort, DistrictItem bezirk, setDialogState) {
    return CheckboxListTile(
      checkColor: DweTheme.yellow,
      value: bezirk.locationSelection[ort],
      title: Text('      ' + ort.ort),
      onChanged: (bool wurdeAusgewaehlt) {
        setDialogState(() => bezirk.locationSelection[ort] = wurdeAusgewaehlt);
      },
    );
  }

  ListTile _locationButton(BuildContext context, Ort location,
      DistrictItem district, List<DistrictItem> districts) {
    return ListTile(
      title: FlatButton(
          padding: EdgeInsets.zero,
          child: Text('      ' + location.ort),
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
  Map<Ort, bool> locationSelection;
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
