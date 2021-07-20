


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:poly/poly.dart' as poly;
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/NoRotation.dart';

import '../Provisioning.dart';

Future<Building?> showAddBuildingDialog(
    {required BuildContext context,
      String? initDescription,
      LatLng? initCoordinates,
      Kiez? initKiez,
      LatLng? center***REMOVED***) =>
    showDialog(
      context: context,
      builder: (context) =>
          LocationDialog(initDescription, initCoordinates, initKiez, center),
    );

class AddBuildingDialog extends StatefulWidget {
  final LatLng? center;
  final LatLng? initCoordinates;
  final String? initDescription;
  final Kiez? initKiez;

  LocationDialog(
      this.initDescription, this.initCoordinates, this.initKiez, this.center)
      : super(key: Key('location dialog'));

  @override
  State<StatefulWidget> createState() {
    LocationMarker? initMarker =
    initCoordinates != null ? LocationMarker(initCoordinates!) : null;
    var location = Location(initDescription ?? '', initCoordinates, initKiez);
    return LocationDialogState(location, initMarker, center);
  ***REMOVED***
***REMOVED***

class AddBuildingDialogState extends State<LocationDialog> {
  LocationMarker? marker;
  late Location location;
  late TextEditingController venueController;
  BuildingView building_view;

  AddBuildingDialogState(
      Location initVenue, LocationMarker? initMarker, LatLng? center, BuildingView building_view) {
    marker = initMarker;
    location = initVenue;
    this.building_view = building_view;
    venueController = TextEditingController(text: location.description);
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Treffpunkt').tr(),
      content: SingleChildScrollView(
          child: ListBody(children: [
            Text(
              'Wähle auf der Karte einen Treffpunkt aus.',
              textScaleFactor: 0.9,
            ).tr(),
            SizedBox(
              height: 5.0,
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: CampaignTheme.secondary, width: 1.0)),
                child: SizedBox(
                    height: 300.0,
                    width: 300.0,
                    child: FlutterMap(
                        key: Key('venue map'),
                        options: MapOptions(
                            center: widget.center ??
                                LatLng(geo.initCenterLat, geo.initCenterLong),
                            zoom: widget.center != null ? geo.initZoom : 10.0,
                            interactiveFlags: noRotation,
                            swPanBoundary:
                            LatLng(building_view.bbox.minLatitude, building_view.bbox.minLongitude),
                            nePanBoundary:
                            LatLng(building_view.bbox.maxLatitude, building_view.bbox.maxLongitude),
                            maxZoom: geo.zoomMax,
                            minZoom: geo.zoomMin,
                            onTap: locationSelected,
                            plugins: [AttributionPlugin()]),
                        layers: [
                          TileLayerOptions(
                              urlTemplate:
                              "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
                              subdomains: ['a', 'b', 'c']),
                          PolygonLayerOptions(
                              polygons: buildDrablePolygonsFromView(), polygonCulling: true),
                          MarkerLayerOptions(
                              markers: marker == null ? [] : [marker!]),
                          AttributionOptions(),
                        ]))),
            SizedBox(
              height: 5.0,
            ),
            Text(
                location.kiez != null
                    ? '${location.kiez!.name***REMOVED*** in ${location.kiez!.region***REMOVED***'
                    : '',
                style: TextStyle(fontSize: 13, color: CampaignTheme.secondary),
                softWrap: false,
                overflow: TextOverflow.fade),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Du kannst eine eigene Beschreibung angeben, '
                  'z.B. "Unter der Weltzeituhr" oder "Tempelhofer Feld, '
                  'Eingang Kienitzstraße":',
              textScaleFactor: 0.8,
            ).tr(),
            SizedBox(
              height: 5.0,
            ),
            TextFormField(
              key: Key('venue description input'),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (input) => location.description = input,
              controller: venueController,
            ),
          ])),
      actions: [
        TextButton(
          child: Text("Abbrechen").tr(),
          onPressed: () {
            Navigator.pop(
                context,
                Location(widget.initDescription, widget.initCoordinates,
                    widget.initKiez));
          ***REMOVED***,
        ),
        TextButton(
          key: Key('venue dialog finish button'),
          child: Text("Fertig").tr(),
          onPressed: () {
            Navigator.pop(context, location);
          ***REMOVED***,
        ),
      ],
    );
  ***REMOVED***

  Set<Polygon> buildDrablePolygonsFromView()
  {
      return building_view.buildings.
          .map((building) => Polygon(
          color: Colors.transparent,
          borderStrokeWidth: 2.0,
          borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
              CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
          points: bezirk.polygon))
          .toSet();
  ***REMOVED***

  locationSelected(LatLng point) async {
    var geodata = await Provider.of<GeoService>(context, listen: false)
        .getDescriptionToPoint(point)
        .catchError((e, s) {
      ErrorService.handleError(e, s);
      return GeoData('', '', '');
    ***REMOVED***);
    Kiez? kiez = (await Provider.of<StammdatenService>(context, listen: false)
        .kieze)
    // ignore: unnecessary_cast
        .map((kiez) => kiez as Kiez?) // nötig wegen orElse => null
        .firstWhere(
            (kiez) => poly.Polygon(kiez!.polygon
            .map((latlng) =>
            poly.Point<num>(latlng.latitude, latlng.longitude))
            .toList())
            .contains(point.latitude, point.longitude),
        orElse: () => null);

    if (kiez == null) return;
    setState(() {
      location.kiez = kiez;
      location.coordinates = point;
      venueController.text = geodata.description;
      location.description = geodata.description;
      marker = LocationMarker(point);
    ***REMOVED***);
  ***REMOVED***
***REMOVED***

class LocationMarker extends Marker {
  LocationMarker(LatLng point)
      : super(
      point: point,
      builder: (context) => DecoratedBox(
          key: Key('location marker'),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CampaignTheme.primary,
              boxShadow: [
                BoxShadow(blurRadius: 4.0, offset: Offset(-2.0, 2.0))
              ]),
          child: Icon(Icons.supervised_user_circle, size: 30.0)));
***REMOVED***
