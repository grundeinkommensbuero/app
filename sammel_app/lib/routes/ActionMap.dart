import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final List<ListLocation> listLocations;
  final Function isMyAction;
  final Function openActionDetails;

  // no better way yet: https://github.com/dart-lang/sdk/issues/4596
  static falseFunction() => false;

  ActionMap(
      {this.termine = const [],
      this.listLocations = const [],
      this.isMyAction = falseFunction,
      this.openActionDetails,
      Key key***REMOVED***)
      : super(key: key);

  @override
  ActionMapState createState() => ActionMapState();
***REMOVED***

class ActionMapState extends State<ActionMap> {
  ActionMapState();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          center: LatLng(52.5170365, 13.3888599),
          zoom: 10.0,
          maxZoom: 19.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
              subdomains: ['a', 'b', 'c']),
//        PolygonLayerOptions(polygons: [
//          Polygon(
//              color: Color.fromARGB(40, DweTheme.purple.red, DweTheme.purple.green, DweTheme.purple.blue),
//              borderStrokeWidth: 2.0,
//              borderColor: Color.fromARGB(150, DweTheme.purple.red, DweTheme.purple.green, DweTheme.purple.blue),
//              points: widget.termine
//                  .map((action) => LatLng(action.lattitude, action.longitude))
//                  .toList())
//        ]),
          MarkerLayerOptions(
              markers: <Marker>[]
                ..addAll(generateListLocationMarkers())
                ..addAll(generateActionMarkers())),
        ]);
  ***REMOVED***

  List<ActionMarker> generateActionMarkers() {
    return widget.termine
        .where((action) => action.lattitude != null && action.longitude != null)
        .map((action) => ActionMarker(action,
            myAction: widget.isMyAction(action.id),
            onTap: widget.openActionDetails))
        .toList();
  ***REMOVED***

  Iterable<Marker> generateListLocationMarkers() {
    return widget.listLocations
        .map((listlocation) => ListLocationMarker(listlocation))
        .toList();
  ***REMOVED***
***REMOVED***

class ActionMarker extends Marker {
  bool myAction = false;
  Function onTap;

  ActionMarker(Termin action, {this.myAction, this.onTap***REMOVED***)
      : super(
          width: 30.0,
          height: 30.0,
          point: LatLng(action.lattitude, action.longitude),
          builder: (context) => DecoratedBox(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(offset: Offset(-2.0, 2.0), blurRadius: 4.0)
              ], shape: BoxShape.circle),
              child: FlatButton(
                  key: Key('action marker'),
                  onPressed: () => onTap(context, action),
                  color: DweTheme.actionColor(action.ende, myAction),
                  shape: CircleBorder(
                      side: BorderSide(color: DweTheme.purple, width: 1.0)),
                  padding: EdgeInsets.all(0),
                  child: Image.asset(action.getAsset(centered: true)))),
        );
***REMOVED***

class ListLocationMarker extends Marker {
  ListLocationMarker(ListLocation listLocation)
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          point: LatLng(listLocation.latitude, listLocation.longitude),
          builder: (context) => FlatButton(
              key: Key('list location marker'),
              color: Colors.transparent,
              onPressed: () {***REMOVED***,
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.edit_location,
                color: DweTheme.purple,
                size: 30.0,
              )),
        );
***REMOVED***
