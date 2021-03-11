import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:poly/poly.dart' as poly;
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/NoRotation.dart';

import '../Provisioning.dart';

Future showLocationDialog(
        {BuildContext context,
        String initDescription,
        LatLng initCoordinates,
        Kiez initKiez,
        LatLng center***REMOVED***) =>
    showDialog(
      context: context,
      child: LocationDialog(initDescription, initCoordinates, initKiez, center),
    );

class LocationDialog extends StatefulWidget {
  final LatLng center;
  final LatLng initCoordinates;
  final String initDescription;
  Kiez initKiez;

  LocationDialog(
      this.initDescription, this.initCoordinates, this.initKiez, this.center)
      : super(key: Key('location dialog'));

  @override
  State<StatefulWidget> createState() {
    LocationMarker initMarker =
        initCoordinates != null ? LocationMarker(initCoordinates) : null;
    var location = Location(initDescription ?? '', initCoordinates, initKiez);
    return LocationDialogState(location, initMarker, center);
  ***REMOVED***
***REMOVED***

class LocationDialogState extends State<LocationDialog> {
  LocationMarker marker;
  Location location;
  TextEditingController venueController;

  LocationDialogState(
      Location initVenue, LocationMarker initMarker, LatLng center) {
    marker = initMarker;
    location = initVenue;
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
                border: Border.all(color: DweTheme.purple, width: 1.0)),
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
                            LatLng(geo.boundLatMin, geo.boundLongMin),
                        nePanBoundary:
                            LatLng(geo.boundLatMax, geo.boundLongMax),
                        maxZoom: geo.zoomMax,
                        minZoom: geo.zoomMin,
                        onTap: locationSelected,
                        plugins: [AttributionPlugin()]),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(
                          markers: marker == null ? [] : [marker]),
                      AttributionOptions(),
                    ]))),
        SizedBox(
          height: 5.0,
        ),
        Text(
            location.kiez != null
                ? '${location.kiez.name***REMOVED*** in ${location.kiez.region***REMOVED***'
                : '',
            style: TextStyle(fontSize: 13, color: DweTheme.purple),
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
        FlatButton(
          child: Text("Abbrechen").tr(),
          onPressed: () {
            Navigator.pop(
                context,
                Location(widget.initDescription, widget.initCoordinates,
                    widget.initKiez));
          ***REMOVED***,
        ),
        FlatButton(
          key: Key('venue dialog finish button'),
          child: Text("Fertig").tr(),
          onPressed: () {
            Navigator.pop(context, location);
          ***REMOVED***,
        ),
      ],
    );
  ***REMOVED***

  locationSelected(LatLng point) async {
    var geodata = await Provider.of<GeoService>(context)
        .getDescriptionToPoint(point)
        .catchError((e, s) {
      ErrorService.handleError(e, s);
      return '';
    ***REMOVED***);
    var kiez = (await Provider.of<StammdatenService>(context).kieze).firstWhere(
        (kiez) => poly.Polygon(kiez.polygon
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
                    color: DweTheme.yellow,
                    boxShadow: [
                      BoxShadow(blurRadius: 4.0, offset: Offset(-2.0, 2.0))
                    ]),
                child: Icon(Icons.supervised_user_circle, size: 30.0)));
***REMOVED***

class Location {
  String description;
  LatLng coordinates;
  Kiez kiez;

  Location(this.description, this.coordinates, this.kiez);
***REMOVED***
