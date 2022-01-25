import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/Provisioning.dart';
import 'package:sammel_app/model/VisitedHouse.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/Placard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ArgumentsDialog.dart';
import 'package:sammel_app/services/ArgumentsService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/PlacardsService.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/NoRotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

import '../shared/DistanceHelper.dart';
import 'VisitedHouseEditor.dart';
import 'MapActionDialog.dart';
import 'PlacardDialog.dart';
import 'EditVisitedHouse.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final List<ListLocation> listLocations;
  final int? myUserId;
  final Function(Termin) isMyAction;
  final Function(Termin) isPastAction;
  final Function(Termin) iAmParticipant;
  final Function(Termin) openActionDetails;
  final Function(LatLng point) switchToActionCreator;
  late final MapController mapController;

  // no better way yet: https://github.com/dart-lang/sdk/issues/4596
  static falseFunction(Termin _) => false;

  static emptyFunction(_) {}

  ActionMap({
    Key? key,
    this.termine = const [],
    this.listLocations = const [],
    this.myUserId,
    this.isMyAction = falseFunction,
    this.isPastAction = emptyFunction,
    this.openActionDetails = emptyFunction,
    this.iAmParticipant = emptyFunction,
    this.switchToActionCreator = emptyFunction,
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
  List<Placard> placards = [];
  late AbstractPlacardsService placardService;
  var initialized = false;
  List<Polygon> housePolygons = [];

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      placardService = Provider.of<AbstractPlacardsService>(context);
      loadPlaccards();
    }

    var markers = generateMarkers();
    List<MapPlugin> plugins = [];
    plugins.add(AttributionPlugin());
    plugins.add(LocationPlugin());
    this.housePolygons = generateVisitedHousePolygons();
    var layers = [
      TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
      PolygonLayerOptions(polygons: this.housePolygons, polygonCulling: true),
      MarkerLayerOptions(markers: markers),
    ];
    layers.add(AttributionOptions());

    final userLocationLayer = [
      // ignore: non_constant_identifier_names
      LocationOptions((_1, _2, _3) => SizedBox())
    ];

    var flutterMap = FlutterMap(
      key: Key('action map map'),
      options: MapOptions(
        onTap: (LatLng point) => mapTap(point),
        onLongPress: (LatLng point) => mapAction(point),
        plugins: plugins,
        center: LatLng(geo.initCenterLat, geo.initCenterLong),
        swPanBoundary: LatLng(geo.boundLatMin, geo.boundLongMin),
        nePanBoundary: LatLng(geo.boundLatMax, geo.boundLongMax),
        zoom: geo.initZoom,
        interactiveFlags: noRotation,
        maxZoom: geo.zoomMax,
        minZoom: geo.zoomMin,
        onPositionChanged: (position, _) =>
            widget.mapController.onReady.then((_) => setState(() {
                  this.markers = generateListLocationMarkers();
                })),
      ),
      layers: layers,
      nonRotatedLayers: userLocationLayer,
      mapController: widget.mapController,
    );
    initialized = true;
    return flutterMap;
  }

  loadPlaccards() {
    placardService
        .loadPlacards()
        .then((placards) => setState(() => this.placards = placards));
  }

  void deletePlacard(Placard placard) {
    placardService.deletePlacard(placard.id!);
    setState(() => placards.remove(placard));
  }

  void takeDownPlacard(Placard placard) {
    placardService.takeDownPlacard(placard.id!);
    setState(() => placards.remove(placard.abgehangen = true));
  }

  List<Polygon> generateVisitedHousePolygons() {
    if (initialized && widget.mapController.zoom > 14) {
      //return widget.visitedHouses;

      BoundingBox bbox = BoundingBox(
          widget.mapController.bounds!.south,
          widget.mapController.bounds!.west,
          widget.mapController.bounds!.north,
          widget.mapController.bounds!.east);
      VisitedHouseView houseView =
          Provider.of<AbstractVisitedHousesService>(context, listen: false)
              .getVisitedHousesInArea(bbox);
      return houseView.buildDrawablePolygonsFromView();
    }
    return [];
  }

  mapTap(LatLng point) async {
    VisitedHouse? vh =
        await Provider.of<AbstractVisitedHousesService>(context, listen: false)
            .getVisitedHouseOfPoint(point, false);

    if (vh != null) {
      var showDistanceInMeter = 100.0;
      var lngDiff = DistanceHelper.getLongDiffFromM(point, showDistanceInMeter);
      var latDiff = DistanceHelper.getLatDiffFromM(point, showDistanceInMeter);
      BoundingBox bbox = BoundingBox(
          point.latitude - latDiff,
          point.longitude - lngDiff,
          point.latitude + latDiff,
          point.longitude + lngDiff);
      var visitedHouseView =
          Provider.of<AbstractVisitedHousesService>(context, listen: false)
              .getVisitedHousesInArea(bbox);
      visitedHouseView.selectedHouse = SelectableVisitedHouse.clone(
          SelectableVisitedHouse.fromVisitedHouse(vh, selected: true));
      await showEditVisitedHouseDialog(
          context: context,
          visitedHouseView: visitedHouseView,
          currentZoomFactor: widget.mapController.zoom);
      setState(() {
        this.housePolygons = generateVisitedHousePolygons();
      });
    }
  }

  Future openPlacardDialog(Placard placard, bool mine) async {
    if (placard.id == null) return;

    PlacardDialogAction action = await showPlacardDialog(context, mine);

    if (action == PlacardDialogAction.DELETE) deletePlacard(placard);
    if (action == PlacardDialogAction.TAKE_DOWN) takeDownPlacard(placard);
  }

  createNewPlacard(LatLng point) async {
    if (widget.myUserId == null) {
      ErrorService.pushError('Plakat kann nicht erstellt werden',
          'Die App hat noch kein Benutzer*inprofil für dich erzeugt. Versuche es bitte später nochmal');
      return;
    }

    final geoData = await Provider.of<GeoService>(context, listen: false)
        .getDescriptionToPoint(point);

    final placard = await placardService.createPlacard(Placard(
        null,
        point.latitude,
        point.longitude,
        geoData.fullAdress,
        widget.myUserId!,
        false));
    if (placard != null) {
      setState(() => placards.add(placard));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Neues Plakat an der Adresse "${placard.adresse}" eingetragen'
                  .tr(),
              style: TextStyle(color: Colors.black87)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
          backgroundColor: Color.fromARGB(220, 255, 255, 250)));
    }
  }

  mapAction(LatLng point) async {
    MapActionType? chosenAction = await showMapActionDialog(context);

    if (chosenAction == MapActionType.NewAction) {
      widget.switchToActionCreator(point);
    }
    if (chosenAction == MapActionType.NewPlacard) createNewPlacard(point);
    if (chosenAction == MapActionType.NewVisitedHouse)
      createNewVisitedHouse(point);
  }

  void createNewVisitedHouse(LatLng point) async {
    var showDistanceInM = 100.0;
    var lngDiff = DistanceHelper.getLongDiffFromM(point, showDistanceInM);
    var latDiff = DistanceHelper.getLatDiffFromM(point, showDistanceInM);
    BoundingBox bbox = BoundingBox(
        point.latitude - latDiff,
        point.longitude - lngDiff,
        point.latitude + latDiff,
        point.longitude + lngDiff);
    var visitedHouseView =
        Provider.of<AbstractVisitedHousesService>(context, listen: false)
            .getVisitedHousesInArea(bbox);
    var newHouseFromServer = await showAddVisitationDialog(
        context: context,
        visitedHouseView: visitedHouseView,
        currentZoomFactor: widget.mapController.zoom);
    if (newHouseFromServer == null) return;

    var arguments =
        await showArgumentsDialog(context: context, coordinates: point);
    if (arguments != null)
      Provider.of<AbstractArgumentsService>(context, listen: false)
          .createArguments(arguments);

    setState(() {
      this.housePolygons = generateVisitedHousePolygons();
    });
  }

  update() async {
    placardService.loadPlacards().then((placards) => setState(() {
          this.placards = placards;
        }));
    Provider.of<AbstractVisitedHousesService>(context, listen: false)
        .loadVisitedHouses()
        .then((_) => setState(
            () => this.housePolygons = this.generateVisitedHousePolygons()));
  }

  List<ActionMarker> generateActionMarkers() {
    return widget.termine
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
    return placards
        .map((placard) => PlacardMarker(placard,
            mine: placard.benutzer == widget.myUserId,
            onTap: openPlacardDialog))
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
  Function(Placard, bool) onTap;

  static emptyFunction(_1, _2) {}

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
                  onPressed:
                      placard.abgehangen ? null : () => onTap(placard, mine),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(0)),
                  ),
                  child: placard.abgehangen
                      ? Image.asset('assets/images/PlakatAbgehangen.png')
                      : Image.asset('assets/images/Plakat.png'))),
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
              child: Image.asset('assets/images/Pin.png')),
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
                      'Hier liegen öffentliche Unterschriften-Listen aus. '
                      'Du kannst selbst Unterschriften-Listen an öffentlichen Orten auslegen, z.B. in Cafés, Bars oder Läden. '
                      'Wichtig ist, dass du die ausgefüllten Listen regelmäßig abholst.\n'
                      'Frage doch mal die Betreiber*innen deines Lieblings-Spätis!\n',
                    ).tr(),
                  ]));
}
