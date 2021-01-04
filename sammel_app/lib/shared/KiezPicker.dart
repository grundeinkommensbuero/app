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
  Set<Kiez> kieze = {***REMOVED***
  Set<Ortsteil> ortsteile = {***REMOVED***
  Set<Bezirk> bezirke = {***REMOVED***
  Set<Kiez> selectedKieze = {***REMOVED***
  var mapController = MapController();
  Set<Polygon> kiezeOutlines;
  Set<Polygon> ortsteileOutlines;
  Set<Polygon> bezirkeOutlines;
  var kiezeAreas;
  List<Polygon> visiblePolygons = [];

  double KIEZE_THRESHOLD = 12;
  double ORTSTEILE_THRESHOLD = 11;

  StammdatenService stammdatenService;

  KiezPicker(this.selectedKieze) {
    if (this.selectedKieze == null) this.selectedKieze = {***REMOVED***
  ***REMOVED***

  Future<Set<Kiez>> showKiezPicker(context) async {
    stammdatenService = Provider.of<StammdatenService>(context);

    kieze = await stammdatenService.kieze;
    ortsteile = await stammdatenService.ortsteile;
    bezirke = await stammdatenService.bezirke;
    kiezeOutlines = generateKiezOutlines(kieze);
    ortsteileOutlines = generateOrtsteilOutlines(ortsteile);
    bezirkeOutlines = generateBezirkOutlines(bezirke);
    kiezeAreas = generateKiezAreas(kieze);

    return await showDialog(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              var layers = [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
                    subdomains: ['a', 'b', 'c']),
                PolygonLayerOptions(
                    polygons: visiblePolygons, polygonCulling: true),
              ];
              return SimpleDialog(
                  key: Key('kiez picker'),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  titlePadding: EdgeInsets.zero,
                  title: AppBar(
                      automaticallyImplyLeading: false,
                      title: const Text('Bezirke oder Kieze auswählen')),
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
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
            ***REMOVED***));
  ***REMOVED***

  getVisiblePolygons() {
    if (mapController.zoom > KIEZE_THRESHOLD)
      this.visiblePolygons = kiezeOutlines.toList();
    else if (mapController.zoom > ORTSTEILE_THRESHOLD)
      this.visiblePolygons = ortsteileOutlines.toList();
    else
      this.visiblePolygons = bezirkeOutlines.toList();

    selectedKieze
        .forEach((selected) => this.visiblePolygons.add(kiezeAreas[selected]));
  ***REMOVED***

  markKiez(LatLng position) {
    final zoom = mapController.zoom;

    Iterable<Kiez> tappedKieze;
    if (zoom > KIEZE_THRESHOLD)
      tappedKieze = kieze.where((kiez) => isIn(position, kiez.polygon));
    else if (zoom > ORTSTEILE_THRESHOLD)
      tappedKieze = ortsteile
          .where((ortsteil) => isIn(position, ortsteil.polygon))
          .expand((ortsteil) => ortsteil.kieze);
    else
      tappedKieze = bezirke
          .where((bezirk) => isIn(position, bezirk.polygon))
          .expand((bezirke) => bezirke.ortsteile)
          .expand((orsteil) => orsteil.kieze);

    if (selectedKieze.containsAll(tappedKieze))
      selectedKieze.removeAll(tappedKieze);
    else
      selectedKieze.addAll(tappedKieze);

    getVisiblePolygons();
  ***REMOVED***

  bool isIn(LatLng position, List<LatLng> polygon) {
    return poly.Polygon(polygon
            .map((latlng) => poly.Point<num>(latlng.latitude, latlng.longitude))
            .toList())
        .contains(position.latitude, position.longitude);
  ***REMOVED***
***REMOVED***

Set<Polygon> generateKiezOutlines(Set<Kiez> kieze) {
  return kieze
      .map((kiez) => Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, DweTheme.purple.red,
              DweTheme.purple.green, DweTheme.purple.blue),
          points: kiez.polygon))
      .toSet();
***REMOVED***

Set<Polygon> generateBezirkOutlines(Set<Bezirk> bezirke) {
  return bezirke
      .map((bezirk) => Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, DweTheme.purple.red,
              DweTheme.purple.green, DweTheme.purple.blue),
          points: bezirk.polygon))
      .toSet();
***REMOVED***

Set<Polygon> generateOrtsteilOutlines(Set<Ortsteil> ortsteile) {
  return ortsteile
      .map((ortsteil) => Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, DweTheme.purple.red,
              DweTheme.purple.green, DweTheme.purple.blue),
          points: ortsteil.polygon))
      .toSet();
***REMOVED***

Map<Kiez, Polygon> generateKiezAreas(Set<Kiez> kieze) {
  return kieze.toList().asMap().map((_, kiez) => MapEntry(
      kiez,
      Polygon(
          color: Color.fromARGB(150, DweTheme.yellow.red, DweTheme.yellow.green,
              DweTheme.yellow.blue),
          points: kiez.polygon)));
***REMOVED***
