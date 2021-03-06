import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/Provisioning.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/Placard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/NoRotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final List<ListLocation> listLocations;
  final List<Placard> placards;
  final int? myUserId;
  final Function(Termin) isMyAction;
  final Function(Termin) isPastAction;
  final Function(Termin) iAmParticipant;
  final Function(Termin) openActionDetails;
  final Function(Placard) openPlacardDialog;
  final Function(LatLng point) mapAction;
  late final MapController mapController;

  // no better way yet: https://github.com/dart-lang/sdk/issues/4596
  static falseFunction(Termin _) => false;

  static emptyFunction(_) {}

  ActionMap({
    Key? key,
    this.termine = const [],
    this.listLocations = const [],
    this.placards = const [],
    this.myUserId,
    this.isMyAction = falseFunction,
    this.isPastAction = emptyFunction,
    this.openActionDetails = emptyFunction,
    this.openPlacardDialog = emptyFunction,
    this.iAmParticipant = emptyFunction,
    this.mapAction = emptyFunction,
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
  List<Marker> markers = [];
  var initialized = false;

  @override
  Widget build(BuildContext context) {
    var markers = generateMarkers();
    List<MapPlugin> plugins = [];
    plugins.add(AttributionPlugin());
    plugins.add(LocationPlugin());

    var layers = [
      TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
      MarkerLayerOptions(markers: markers),
    ];
    layers.add(AttributionOptions());

    final userLocationLayer = [LocationOptions((_1, _2, _3) => SizedBox())];

    var flutterMap = FlutterMap(
      key: Key('action map map'),
      options: MapOptions(
          onLongPress: (LatLng point) => widget.mapAction(point),
          plugins: plugins,
          center: LatLng(geo.initCenterLat, geo.initCenterLong),
          swPanBoundary: LatLng(geo.boundLatMin, geo.boundLongMin),
          nePanBoundary: LatLng(geo.boundLatMax, geo.boundLongMax),
          zoom: geo.initZoom,
          interactiveFlags: noRotation,
          maxZoom: geo.zoomMax,
          minZoom: geo.zoomMin,
          onPositionChanged: (position, _) => widget.mapController.onReady.then(
              (_) => setState(
                  () => this.markers = generateListLocationMarkers()))),
      layers: layers,
      nonRotatedLayers: userLocationLayer,
      mapController: widget.mapController,
    );
    initialized = true;
    return flutterMap;
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
    if (!initialized || widget.mapController.zoom < 13) return [];
    return widget.listLocations
        .map((listlocation) => ListLocationMarker(listlocation))
        .toList();
  }

  List<PlacardMarker> generatePlacardMarkers() {
    if (!initialized || widget.mapController.zoom < 15) return [];
    return widget.placards
        .where(
            (placard) => placard.latitude != null && placard.longitude != null)
        .map((placard) => PlacardMarker(placard,
            mine: placard.benutzer == widget.myUserId,
            onTap: widget.openPlacardDialog))
        .toList()
        .reversed
        .toList();
  }

  List<Marker> generateMarkers() => <Marker>[]
    ..addAll(generateListLocationMarkers())
    ..addAll(generateActionMarkers())
    ..addAll(generatePlacardMarkers());

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
              child: TextButton(
                  key: Key('action marker'),
                  onPressed: () => onTap(action),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        CampaignTheme.actionColor(
                            action.ende, ownAction, participant)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        CircleBorder(
                            side: BorderSide(
                                color: CampaignTheme.secondary, width: 1.0))),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(0)),
                  ),
                  child: Image.asset(action.getAsset(centered: true),
                      alignment: Alignment.center))),
        );
}

class PlacardMarker extends Marker {
  bool mine = false;
  Function(Placard) onTap;

  static emptyFunction(_) {}

  PlacardMarker(Placard placard,
      {this.mine = false, this.onTap = emptyFunction})
      : super(
          width: 30.0,
          height: 30.0,
          point: LatLng(placard.latitude, placard.longitude),
          builder: (context) => DecoratedBox(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 6,
                    spreadRadius: 3,
                    color: CampaignTheme.placardColor(mine))
              ], shape: BoxShape.circle),
              child: TextButton(
                  key: Key('placard marker'),
                  onPressed: () => mine ? onTap(placard) : null,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(0)),
                  ),
                  child: Image.asset('assets/images/Plakat.png'))),
        );
}

class ListLocationMarker extends Marker {
  ListLocationMarker(ListLocation listLocation)
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          point: LatLng(listLocation.latitude, listLocation.longitude),
          builder: (context) => TextButton(
              key: Key('list location marker'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(0)),
              ),
              onPressed: () => showListLocationDialog(context, listLocation),
              child: Icon(
                Icons.edit_location,
                color: CampaignTheme.secondary,
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
                      style: TextStyle(color: CampaignTheme.secondary)),
                  key: Key('list location info dialog'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  contentPadding: EdgeInsets.all(10.0),
                  children: <Widget>[
                    Text(
                      'Hier liegen ??ffentliche Unterschriften-Listen aus. '
                      'Du kannst selbst Unterschriften-Listen an ??ffentlichen Orten auslegen, z.B. in Caf??s, Bars oder L??den. '
                      'Wichtig ist, dass du die ausgef??llten Listen regelm????ig abholst.\n'
                      'Frage doch mal die Betreiber*innen deines Lieblings-Sp??tis!\n',
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
