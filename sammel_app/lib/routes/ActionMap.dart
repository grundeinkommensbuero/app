import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/Provisioning.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/NoRotation.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final List<ListLocation> listLocations;
  final Function(Termin) isMyAction;
  final Function(Termin) isPastAction;
  final Function(Termin) iAmParticipant;
  final Function(Termin) openActionDetails;
  late final MapController mapController;

  // no better way yet: https://github.com/dart-lang/sdk/issues/4596
  static falseFunction(Termin _) => false;

  static emptyFunction(_) {}

  ActionMap({
    Key? key,
    this.termine = const [],
    this.listLocations = const [],
    this.isMyAction = falseFunction,
    this.isPastAction = emptyFunction,
    this.openActionDetails = emptyFunction,
    this.iAmParticipant = emptyFunction,
    mapController,
  }) : super(key: key) {
    this.mapController = mapController ?? MapController();
  }

  @override
  ActionMapState createState() => ActionMapState();
}

class ActionMapState extends State<ActionMap> {
  ActionMapState();

  var locationPermissionGranted = false;
  List<Marker> listLocationMarkers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var actionMarkers = generateActionMarkers();
    List<MapPlugin> plugins = [];
    plugins.add(AttributionPlugin());
    plugins.add(MarkerClusterPlugin());

    var layers = [
      TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
      MarkerLayerOptions(markers: listLocationMarkers),
      MarkerClusterLayerOptions(
        disableClusteringAtZoom: 14,
        markers: actionMarkers,
        maxClusterRadius: 50,
        polygonOptions:
            PolygonOptions(color: DweTheme.yellow.withOpacity(0.12)),
        fitBoundsOptions:
            FitBoundsOptions(padding: EdgeInsets.fromLTRB(40, 90, 40, 100)),
        builder: (context, markers) {
          return DecoratedBox(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(offset: Offset(-2.0, 2.0), blurRadius: 4.0)
              ], shape: BoxShape.circle),
              child: FloatingActionButton(
                child: Text(
                  markers.length.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                backgroundColor: DweTheme.yellow,
                foregroundColor: DweTheme.purple,
                shape: CircleBorder(
                    side: BorderSide(color: Colors.black, width: 1.0)),
                onPressed: null,
              ));
        },
      ),
    ];
    layers.add(AttributionOptions());

    return FlutterMap(
      key: Key('action map map'),
      options: MapOptions(
          plugins: plugins,
          center: LatLng(geo.initCenterLat, geo.initCenterLong),
          swPanBoundary: LatLng(geo.boundLatMin, geo.boundLongMin),
          nePanBoundary: LatLng(geo.boundLatMax, geo.boundLongMax),
          zoom: geo.initZoom,
          interactiveFlags: noRotation,
          maxZoom: geo.zoomMax,
          minZoom: geo.zoomMin,
          onPositionChanged: (position, _) => widget.mapController.onReady.then(
              (_) => setState(() =>
                  this.listLocationMarkers = generateListLocationMarkers()))),
      layers: layers,
      mapController: widget.mapController,
    );
  }

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
  }

  List<Marker> generateListLocationMarkers() {
    if (widget.mapController.zoom < 13) return [];
    return widget.listLocations
        .map((listlocation) => ListLocationMarker(listlocation))
        .toList();
  }

  Color generateColor(String bezirk) {
    return Color.fromARGB(150, bezirk.hashCode * 10, bezirk.hashCode * 100,
        bezirk.hashCode * 1000);
  }
}

class ActionMarker extends Marker {
  bool ownAction = false;
  Function(Termin) onTap;
  bool participant = false;

  static emptyFunction(_) {}

  ActionMarker(Termin action,
      {this.ownAction = false,
      this.onTap = emptyFunction,
      this.participant = false})
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
                  onPressed: () => onTap(action),
                  color:
                      DweTheme.actionColor(action.ende, ownAction, participant),
                  shape: CircleBorder(
                      side: BorderSide(color: DweTheme.purple, width: 1.0)),
                  padding: EdgeInsets.all(0),
                  child: Image.asset(action.getAsset(centered: true),
                      alignment: Alignment.center))),
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
                          '${listLocation.street ?? ''} ${listLocation.number ?? ''}',
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
}
