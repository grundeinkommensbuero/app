import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/shared/DweTheme.dart';

Future showVenueDialog(
        {BuildContext context,
        String initDescription,
        LatLng initCoordinates,
        LatLng center***REMOVED***) =>
    showDialog(
      context: context,
      child: VenueDialog(initDescription, initCoordinates, center),
    );

class VenueDialog extends StatefulWidget {
  final LatLng center;
  final LatLng initCoordinates;
  final String initDescription;

  VenueDialog(this.initDescription, this.initCoordinates, this.center);

  @override
  State<StatefulWidget> createState() {
    VenueMarker initMarker =
        initCoordinates != null ? VenueMarker(initCoordinates) : null;
    Venue initVenue = Venue(initDescription ?? '', initCoordinates);
    return VenueDialogState(initVenue, initMarker, center);
  ***REMOVED***
***REMOVED***

class VenueDialogState extends State<VenueDialog> {
  VenueMarker marker;
  Venue venue;

  VenueDialogState(Venue initVenue, VenueMarker initMarker, LatLng center) {
    marker = initMarker;
    venue = initVenue;
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: Key('treffpunkt input dialog'),
      title: Text('Treffpunkt'),
      content: SingleChildScrollView(
          child: ListBody(children: [
        Text(
          'Wähle auf der Karte einen Treffpunkt aus.',
          textScaleFactor: 0.9,
        ),
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: DweTheme.yellowBright, width: 2.0)),
            child: SizedBox(
                height: 300.0,
                width: 300.0,
                child: FlutterMap(
                    key: Key('venue map'),
                    options: MapOptions(
                        center: widget.center ?? LatLng(52.5170365, 13.3888599),
                        zoom: widget.center != null ? 14.0 : 10.0,
                        maxZoom: 19.0,
                        onTap: (LatLng point) => setState(() {
                              venue.coordinates = point;
                              marker = VenueMarker(point);
                            ***REMOVED***)),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(
                          markers: marker == null ? [] : [marker])
                    ]))),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Du kannst eine eigene Beschreibung angeben, '
          'z.B. "Unter der Weltzeituhr" oder "Tempelhofer Feld, '
          'Eingang Kienitzstraße":',
          textScaleFactor: 0.9,
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          key: Key('venue description input'),
          initialValue: venue.description,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (input) => venue.description = input,
        ),
      ])),
      actions: [
        FlatButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.pop(
                context, Venue(widget.initDescription, widget.initCoordinates));
          ***REMOVED***,
        ),
        FlatButton(
          key: Key('venue dialog finish button'),
          child: Text("Fertig"),
          onPressed: () {
            Navigator.pop(context, venue);
          ***REMOVED***,
        ),
      ],
    );
  ***REMOVED***
***REMOVED***

class VenueMarker extends Marker {
  VenueMarker(LatLng point)
      : super(
            point: point,
            builder: (context) => DecoratedBox(
                key: Key('venue marker'),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DweTheme.yellow,
                    boxShadow: [
                      BoxShadow(blurRadius: 4.0, offset: Offset(-2.0, 2.0))
                    ]),
                child: Icon(Icons.supervised_user_circle, size: 30.0)));
***REMOVED***

class Venue {
  String description;
  LatLng coordinates;

  Venue(this.description, this.coordinates);
***REMOVED***
