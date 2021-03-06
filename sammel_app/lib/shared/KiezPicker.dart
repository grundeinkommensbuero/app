import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:poly/poly.dart' as poly;
import 'package:provider/provider.dart';
import 'package:sammel_app/Provisioning.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/NoRotation.dart';

import 'CampaignTheme.dart';

class KiezPicker {
  Set<Kiez> selectedKieze;
  var mapController = MapController();
  List<Polygon> visiblePolygons = [];

  double KIEZE_THRESHOLD = 12; // ignore: non_constant_identifier_names
  double REGIONEN_THRESHOLD = 11; // ignore: non_constant_identifier_names

  static Set<Kiez> kieze = {};
  static Set<Region> regionen = {};
  static Set<Ortsteil> ortsteile = {};

  StammdatenService? stammdatenService;

  KiezPicker(this.selectedKieze);

  Future<Set<Kiez>?> showKiezPicker(context) async {
    stammdatenService = Provider.of<StammdatenService>(context, listen: false);
    regionen = await stammdatenService!.regionen;
    kieze = await stammdatenService!.kieze;
    ortsteile = await stammdatenService!.ortsteile;
    visiblePolygons = generateOrtsteileOutlines(ortsteile).toList();

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
                      automaticallyImplyLeading: false,
                      title: const Text('Bezirke oder Kieze ausw??hlen').tr()),
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(children: [
                          Expanded(
                              child: FlutterMap(
                            key: Key('kiez selection map'),
                            options: MapOptions(
                                center: LatLng(
                                    geo.initCenterLat, geo.initCenterLong),
                                interactiveFlags: noRotation,
                                swPanBoundary:
                                    LatLng(geo.boundLatMin, geo.boundLongMin),
                                nePanBoundary:
                                    LatLng(geo.boundLatMax, geo.boundLongMax),
                                zoom: geo.initZoom,
                                maxZoom: geo.zoomMax,
                                minZoom: geo.zoomMin,
                                onTap: (position) =>
                                    setDialogState(() => markKiez(position)),
                                onPositionChanged: (position, _) =>
                                    mapController.onReady.then((_) =>
                                        setDialogState(
                                            () => getVisiblePolygons()))),
                            layers: layers,
                            mapController: mapController,
                          )),
                          ElevatedButton(
                              child: Text('Auswahl ??bernehmen').tr(),
                              onPressed: () =>
                                  Navigator.pop(context, selectedKieze))
                        ])),
                  ]);
            }));
  }

  getVisiblePolygons() {
    if (mapController.zoom > KIEZE_THRESHOLD)
      this.visiblePolygons = generateKiezeOutlines(kieze).toList();
    else if (mapController.zoom > REGIONEN_THRESHOLD)
      this.visiblePolygons = generateRegionenOutlines(regionen).toList();
    else
      this.visiblePolygons = generateOrtsteileOutlines(ortsteile).toList();

    selectedKieze.forEach((selected) =>
        this.visiblePolygons.add(generateKiezeAreas(kieze)[selected]!));
  }

  markKiez(LatLng position) {
    final zoom = mapController.zoom;

    Iterable<Kiez> tappedKieze;
    if (zoom > KIEZE_THRESHOLD)
      tappedKieze = kieze.where((kiez) => isIn(position, kiez.polygon));
    else if (zoom > REGIONEN_THRESHOLD)
      tappedKieze = regionen
          .where((region) => isIn(position, region.polygon))
          .expand(
              (region) => kieze.where((kiez) => kiez.region == region.name));
    else
      tappedKieze = ortsteile
          .where((ortsteil) => isIn(position, ortsteil.polygon))
          .expand((ortsteil) =>
              kieze.where((kiez) => kiez.ortsteil == ortsteil.name));

    if (selectedKieze.containsAll(tappedKieze))
      selectedKieze.removeAll(tappedKieze);
    else
      selectedKieze.addAll(tappedKieze);

    getVisiblePolygons();
  }

  bool isIn(LatLng position, List<LatLng> polygon) {
    return poly.Polygon(polygon
            .map((latlng) => poly.Point<num>(latlng.latitude, latlng.longitude))
            .toList())
        .contains(position.latitude, position.longitude);
  }
}

Set<Polygon> generateKiezeOutlines(Set<Kiez> kieze) {
  return kieze
      .map((kiez) => Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
              CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
          points: kiez.polygon))
      .toSet();
}

Set<Polygon> generateOrtsteileOutlines(Set<Ortsteil> bezirke) {
  return bezirke
      .map((bezirk) => Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
              CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
          points: bezirk.polygon))
      .toSet();
}

Set<Polygon> generateRegionenOutlines(Set<Region> ortsteile) {
  return ortsteile
      .map((ortsteil) => Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
              CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
          points: ortsteil.polygon))
      .toSet();
}

Map<Kiez, Polygon> generateKiezeAreas(Set<Kiez> kieze) {
  return kieze.toList().asMap().map((_, kiez) => MapEntry(
      kiez,
      Polygon(
          color: Color.fromARGB(150, CampaignTheme.primary.red, CampaignTheme.primary.green,
              CampaignTheme.primary.blue),
          points: kiez.polygon)));
}
