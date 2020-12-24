import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:poly/poly.dart' as poly;
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/services/StammdatenService.dart';

import 'DweTheme.dart';

class KiezPicker {
  List<Kiez> kieze = [];
  List<Kiez> selectedKieze = [];
  var mapController = MapController();
  var outlines2kieze;
  var areas2kieze;
  List<Polygon> visiblePolygons = [];

  KiezPicker(this.selectedKieze) {
    if (this.selectedKieze == null) this.selectedKieze = [];
  }

  Future<List<Kiez>> showKiezPicker(context) async {
    kieze = await Provider.of<StammdatenService>(context).kieze;
    outlines2kieze = generateKiezOutlines(kieze);
    areas2kieze = generateKiezAreas(kieze);
    return await showDialog(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              var layers = [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                PolygonLayerOptions(
                    polygons: visiblePolygons, polygonCulling: true),
              ];
              return SimpleDialog(
                  key: Key('kiez picker'),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  titlePadding: EdgeInsets.zero,
                  title: AppBar(
                      leading: null,
                      automaticallyImplyLeading: false,
                      title: const Text('Bezirke oder Kieze auswählen')),
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(children: [
                          Expanded(
                              child: FlutterMap(
                            key: Key('kiez selection map'),
                            options: MapOptions(
                                center: LatLng(52.5170365, 13.3888599),
                                zoom: 10.0,
                                maxZoom: 19.0,
                                onTap: (position) =>
                                    setDialogState(() => markKiez(position)),
                                onPositionChanged: (position, _) =>
                                    mapController.onReady.then((_) =>
                                        setDialogState(
                                            () => getVisiblePolygons()))),
                            layers: layers,
                            mapController: mapController,
                          )),
                          RaisedButton(
                              child: Text('Auswahl übernehmen'),
                              onPressed: () =>
                                  Navigator.pop(context, selectedKieze))
                        ])),
                  ]);
            }));
  }

  getVisiblePolygons() {
    this.visiblePolygons = outlines2kieze.values.toList();
    selectedKieze
        .forEach((selected) => this.visiblePolygons.add(areas2kieze[selected]));
  }

  markKiez(LatLng position) {
    var tappedKiez = kieze
        .where((kiez) =>
            kiez.xBoundMax > position.latitude &&
            kiez.xBoundMin < position.latitude &&
            kiez.yBoundMax > position.longitude &&
            kiez.yBoundMin < position.latitude)
        .firstWhere(
            (kiez) => poly
                .toPolyFromListOfList(kiez.polygon)
                .contains(position.longitude, position.latitude),
            orElse: () => null);

    if (tappedKiez == null) return;

    if (selectedKieze.contains(tappedKiez))
      selectedKieze.remove(tappedKiez);
    else
      selectedKieze.add(tappedKiez);
    getVisiblePolygons();
  }
}

Map<Kiez, Polygon> generateKiezOutlines(List<Kiez> kieze) {
  return kieze.asMap().map((_, kiez) => MapEntry(
      kiez,
      Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, DweTheme.purple.red,
              DweTheme.purple.green, DweTheme.purple.blue),
          points: kiez.polygon
              .map((point) => LatLng(point[1], point[0]))
              .toList())));
}

Map<Kiez, Polygon> generateKiezAreas(List<Kiez> kieze) {
  return kieze.asMap().map((_, kiez) => MapEntry(
      kiez,
      Polygon(
          color: Color.fromARGB(150, DweTheme.yellow.red, DweTheme.yellow.green,
              DweTheme.yellow.blue),
          points: kiez.polygon
              .map((point) => LatLng(point[1], point[0]))
              .toList())));
}
