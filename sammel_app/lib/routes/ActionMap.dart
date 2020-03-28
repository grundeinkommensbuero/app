import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final List<ListLocation> listLocations;
  final Function isMyAction;
  final Function openActionDetails;
  final MapController mapController;

  // no better way yet: https://github.com/dart-lang/sdk/issues/4596
  static falseFunction() => false;

  ActionMap({
    Key key,
    this.termine = const [],
    this.listLocations = const [],
    this.isMyAction = falseFunction,
    this.openActionDetails,
    this.mapController,
  }) : super(key: key);

  @override
  ActionMapState createState() => ActionMapState();
}

class ActionMapState extends State<ActionMap> {
  ActionMapState();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      key: Key('action map map'),
      options: MapOptions(
        center: LatLng(52.5170365, 13.3888599),
        zoom: 10.0,
        maxZoom: 19.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
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
      ],
      mapController: widget.mapController ?? MapController(),
    );
  }

  List<ActionMarker> generateActionMarkers() {
    return widget.termine
        .where((action) => action.latitude != null && action.longitude != null)
        .map((action) => ActionMarker(action,
            ownAction: widget.isMyAction(action.id),
            onTap: widget.openActionDetails))
        .toList();
  }

  Iterable<Marker> generateListLocationMarkers() {
    return widget.listLocations
        .map((listlocation) => ListLocationMarker(listlocation))
        .toList();
  }
}

class ActionMarker extends Marker {
  bool ownAction = false;
  Function onTap;

  ActionMarker(Termin action, {this.ownAction, this.onTap})
      : super(
          width: 30.0,
          height: 30.0,
          point: LatLng(action.latitude, action.longitude),
          builder: (context) => DecoratedBox(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(offset: Offset(-2.0, 2.0), blurRadius: 4.0)
              ], shape: BoxShape.circle),
              child: FlatButton(
                  key: Key('action marker'),
                  onPressed:
                      onTap != null ? () => onTap(context, action) : null,
                  color: DweTheme.actionColor(action.ende, ownAction ?? false),
                  shape: CircleBorder(
                      side: BorderSide(color: DweTheme.purple, width: 1.0)),
                  padding: EdgeInsets.all(0),
                  child: Image.asset(action.getAsset(centered: true)))),
        );
}

class ListLocationMarker extends Marker {
  ListLocationMarker(ListLocation listLocation)
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          point: LatLng(listLocation.latitude, listLocation.longitude),
          builder: (context) => FlatButton(
              key: Key('list location marker'),
              color: Colors.transparent,
              onPressed: () => showListLocationDialog(context, listLocation),
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.edit_location,
                color: DweTheme.purple,
                size: 30.0,
              )),
        );

  static showListLocationDialog(
          BuildContext context, ListLocation listLocation) =>
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                  title: Text(
                      listLocation.name ??
                          '${listLocation.street} ${listLocation.number}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: DweTheme.purple)),
                  key: Key('list location info dialog'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  contentPadding: EdgeInsets.all(10.0),
                  children: <Widget>[
                    Text(
                      'Hier liegen öffentliche Unterschriften-Listen aus. '
                      'Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. '
                      'Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\n'
                      'Frage doch mal die Betreiber*innen deines Lieblings-Spätis!\n',
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Du kannst den Ort auf ',
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          text: 'www.dwenteignen.de',
                          style: TextStyle(
                              color: Colors.indigo,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => launch('https://www.dwenteignen.de')),
                      TextSpan(
                          text: ' eintragen.',
                          style: TextStyle(color: Colors.black))
                    ]))
                  ]));
}
