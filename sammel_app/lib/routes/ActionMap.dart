import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_location/user_location.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final List<ListLocation> listLocations;
  final Function(Termin) isMyAction;
  final Function(Termin) isPastAction;
  final Function(Termin) iAmParticipant;
  final Function(Termin) openActionDetails;
  final MapController mapController;

  // no better way yet: https://github.com/dart-lang/sdk/issues/4596
  static falseFunction(Termin _) => false;

  ActionMap({
    Key key,
    this.termine = const [],
    this.listLocations = const [],
    this.isMyAction = falseFunction,
    this.isPastAction,
    this.openActionDetails,
    this.mapController,
    this.iAmParticipant,
  ***REMOVED***) : super(key: key);

  @override
  ActionMapState createState() => ActionMapState();
***REMOVED***

class ActionMapState extends State<ActionMap> {
  ActionMapState();

  var locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    Permission.locationWhenInUse.request().then((status) =>
        setState(() => locationPermissionGranted = status.isGranted));
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    var listLocationMarkers = generateListLocationMarkers();
    var actionMarkers = generateActionMarkers();
    var markers = generateMarkers();
    var plugins = List<MapPlugin>();
    plugins.add(AttributionPlugin());
    plugins.add(MarkerClusterPlugin());

    var layers = [
      TileLayerOptions(
          urlTemplate: "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
          subdomains: ['a', 'b', 'c']),
      MarkerClusterLayerOptions(
        markers: actionMarkers,
        maxClusterRadius: 120,
        size: Size(40, 40),
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        polygonOptions: PolygonOptions(
            borderColor: Colors.blueAccent,
            color: Colors.black12,
            borderStrokeWidth: 3),
        builder: (context, markers) {
          return FloatingActionButton(
            child: Text(markers.length.toString()),
            onPressed: null,
          );
        ***REMOVED***,
      ),
      MarkerClusterLayerOptions(
        markers: listLocationMarkers,
        maxClusterRadius: 120,
        size: Size(40, 40),
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        polygonOptions: PolygonOptions(
            borderColor: Colors.blueAccent,
            color: Colors.black12,
            borderStrokeWidth: 3),
        builder: (context, markers) {
          return FloatingActionButton(
            child: Text(markers.length.toString()),
            onPressed: null,
          );
        ***REMOVED***,
      ),
    ];
    layers.add(AttributionOptions());

    if (locationPermissionGranted) {
      addUserLocationSettings(markers, plugins, layers);
    ***REMOVED***

    return FlutterMap(
      key: Key('action map map'),
      options: MapOptions(
        plugins: plugins,
        center: LatLng(52.5170365, 13.3888599),
        zoom: 10.0,
        maxZoom: 19.0,
      ),
      layers: layers,
      mapController: widget.mapController ?? MapController(),
    );
  ***REMOVED***

  List<ActionMarker> generateActionMarkers() {
    return widget.termine
        .where((action) => action.latitude != null && action.longitude != null)
        .map((action) => ActionMarker(action,
            ownAction: widget.isMyAction(action),
            participant: widget.iAmParticipant(action),
            onTap: widget.openActionDetails))
        .toList()
        .reversed
        .toList();
  ***REMOVED***

  Iterable<Marker> generateListLocationMarkers() {
    return widget.listLocations
        .map((listlocation) => ListLocationMarker(listlocation))
        .toList();
  ***REMOVED***

  List<Marker> generateMarkers() => <Marker>[]
    ..addAll(generateListLocationMarkers())
    ..addAll(generateActionMarkers());

  void addUserLocationSettings(List<Marker> markers, List<MapPlugin> plugins,
      List<LayerOptions> layers) {
    plugins.add(UserLocationPlugin());
    layers.add(UserLocationOptions(
      context: context,
      mapController: widget.mapController,
      markers: markers,
      updateMapLocationOnPositionChange: false,
      showMoveToCurrentLocationFloatingActionButton: false,
    ));
  ***REMOVED***

  Color generateColor(String bezirk) {
    return Color.fromARGB(150, bezirk.hashCode * 10, bezirk.hashCode * 100,
        bezirk.hashCode * 1000);
  ***REMOVED***
***REMOVED***

class ActionMarker extends Marker {
  bool ownAction = false;
  Function(Termin) onTap;
  bool participant;

  ActionMarker(Termin action, {this.ownAction, this.onTap, this.participant***REMOVED***)
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
                  onPressed: onTap != null ? () => onTap(action) : null,
                  color:
                      DweTheme.actionColor(action.ende, ownAction, participant),
                  shape: CircleBorder(
                      side: BorderSide(color: DweTheme.purple, width: 1.0)),
                  padding: EdgeInsets.all(0),
                  child: Image.asset(action.getAsset(centered: true),
                      alignment: Alignment.center))),
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
                          '${listLocation.street***REMOVED*** ${listLocation.number***REMOVED***',
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
                    ).tr(),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: tr('Du kannst den Ort eintragen auf:\n'),
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: 'www.dwenteignen.de/sammelpunkte/',
                              style: TextStyle(
                                  color: Colors.indigo,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    launch('www.dwenteignen.de/sammelpunkte/'))
                        ]))
                  ]));
***REMOVED***
