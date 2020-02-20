import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/model/Termin.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final Function openActionDetails;
  final Function isMyAction;

  ActionMap(this.termine, this.isMyAction, this.openActionDetails, {Key key***REMOVED***)
      : super(key: key);

  @override
  ActionMapState createState() => ActionMapState();
***REMOVED***

class ActionMapState extends State<ActionMap> {
  ActionMapState();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FlutterMap(
      options: MapOptions(
        center: LatLng(52.5170365, 13.3888599),
        zoom: 10.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s***REMOVED***.tile.openstreetmap.org/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(52.4989464, 13.4644209),
              builder: (ctx) => Image.asset('assets/images/logo.png'),
            ),
          ],
        ),
      ],
    ));
  ***REMOVED***
***REMOVED***
