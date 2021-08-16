import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/NoRotation.dart';
import 'package:sammel_app/shared/ServerException.dart';

import '../Provisioning.dart';

VisitedHouse? addNewVisitedHouseEvent(
    BuildContext context, VisitedHouse? visitedHouse) {
  if (visitedHouse != null) {
    //the last event is new. register at server
    var abstractVisitedHousesService =
        Provider.of<AbstractVisitedHousesService>(context, listen: false);
    return abstractVisitedHousesService.editVisitedHouse(visitedHouse);
  ***REMOVED*** else
    return null;
***REMOVED***

Future<VisitedHouse?> showEditVisitedHouseDialog(
    {required BuildContext context,
    required VisitedHouseView buildingView,
    required double currentZoomFactor***REMOVED***) async {
  VisitedHouse? visitedHouse = await showDialog(
    context: context,
    builder: (context) => EditBuildingDialog(buildingView, currentZoomFactor),
  );
  return addNewVisitedHouseEvent(context, visitedHouse);
***REMOVED***

class EditBuildingDialog extends StatefulWidget {
  late final LatLng? center;
  late final VisitedHouseView buildingView;
  late final double currentZoomFactor;

  EditBuildingDialog(this.buildingView, this.currentZoomFactor)
      : super(key: Key('add building dialog'));

  @override
  State<StatefulWidget> createState() {
    return EditBuildingDialogState(buildingView);
  ***REMOVED***
***REMOVED***

class EditBuildingDialogState extends State<EditBuildingDialog> {
  LocationMarker? marker;
  @required
  late VisitedHouseView buildingView;
  late LatLng center;

  var showLoadingIndicator = false;

  EditBuildingDialogState(VisitedHouseView buildingView) {
    this.buildingView = buildingView;
    this.center = LatLng(
        0.5 * (buildingView.bbox.maxLatitude + buildingView.bbox.minLatitude),
        0.5 *
            (buildingView.bbox.maxLongitude + buildingView.bbox.minLongitude));
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Besuchtes Haus').tr(),
      content: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min, children: createWidgets())),
      actions: [
        TextButton(
          child: Text('Abbrechen').tr(),
          onPressed: () {
            Navigator.pop(context, null);
          ***REMOVED***,
        ),
        TextButton(
          key: Key('venue dialog finish button'),
          child: Text("Fertig").tr(),
          onPressed: () {
            if (Provider.of<AbstractUserService>(context, listen: false)
                    .latestUser ==
                null) throw ServerException('Couldnt fetch user from server');
            //   building_view.selected_building?.visitation_events.add(VisitedHouseEvent(-1, Provider.of<AbstractUserService>(context, listen: false).latestUser!.id!, DateTime.now()));
            Navigator.pop(context, buildingView.selectedBuilding);
          ***REMOVED***,
        ),
      ],
    );
  ***REMOVED***

  List<Widget> createWidgets() {
    var widgets = [
      Text(
        'Wähle das Haus auf der Karte aus.'.tr(),
        textScaleFactor: 0.9,
      ).tr(),
      SizedBox(
        height: 5.0,
      ),
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: CampaignTheme.secondary, width: 1.0)),
          child:
              SizedBox(height: 300.0, width: 300.0, child: buildFlutterMap())),
      SizedBox(
        height: 5.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Besuche',
            textScaleFactor: 1.2,
          ).tr()),
      SizedBox(
        height: 5.0,
      )
    ];
    if (buildingView.selectedBuilding != null &&
        buildingView.selectedBuilding!.visitationEvents.length > 0) {
      widgets.addAll(buildingView.selectedBuilding!.visitationEvents
          .map((event) => buildVisitationEventItem(event)));
    ***REMOVED***
    return widgets;
  ***REMOVED***

  Widget buildFlutterMap() {
    var map = FlutterMap(
        key: Key('venue map'),
        options: MapOptions(
            center: center,
            zoom: widget.currentZoomFactor < 17 ? 17 : widget.currentZoomFactor,
            interactiveFlags: noRotation,
            swPanBoundary: LatLng(buildingView.bbox.minLatitude,
                buildingView.bbox.minLongitude),
            nePanBoundary: LatLng(buildingView.bbox.maxLatitude,
                buildingView.bbox.maxLongitude),
            maxZoom: geo.zoomMax,
            minZoom: geo.zoomMin,
            onTap: houseSelected,
            plugins: [AttributionPlugin()]),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
              subdomains: ['a', 'b', 'c']),
          PolygonLayerOptions(
              polygons: buildingView.buildDrawablePolygonsFromView(),
              polygonCulling: false),
          MarkerLayerOptions(markers: marker == null ? [] : [marker!]),
          AttributionOptions(),
        ]);
    return map;
  ***REMOVED***

  houseSelected(LatLng point) async {
    SelectableVisitedHouse? building = buildingView.getBuildingByPoint(point);
    //not in current view
    setState(() {
      if (building != null &&
          buildingView.selectedBuilding?.osmId != building.osmId) {
        buildingView.selectedBuilding = SelectableVisitedHouse.clone(building);
        buildingView.selectedBuilding?.selected = true;
      ***REMOVED***
      //venueController.text = geodata.description;
      // marker = LocationMarker(point);
    ***REMOVED***);
  ***REMOVED***

  Widget buildVisitationEventItem(VisitedHouseEvent item) {
    Locale? locale;
    try {
      locale = context.locale;
    ***REMOVED*** catch (_) {
      print('Konnte Locale nicht ermitteln');
    ***REMOVED***

    final tile = ListTile(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${item.adresse***REMOVED***',
            style: TextStyle(color: CampaignTheme.secondary)),
        Text(
            '${ChronoHelfer.formatDateOfDateTimeMitWochentagOhneJahr(item.datum, locale)***REMOVED***',
            textScaleFactor: 0.8),
        isEmpty(item.hausteil)
            ? SizedBox()
            : Text('${item.hausteil***REMOVED***', textScaleFactor: 0.8),
      ]),
    );

    if (item.benutzer ==
        Provider.of<AbstractUserService>(context, listen: false)
            .latestUser!
            .id) {
      return Row(children: [
        Expanded(child: tile),
        IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // Remove the item from the data source.
              setState(() {
                buildingView.selectedBuilding!.visitationEvents.remove(item);
              ***REMOVED***);
            ***REMOVED***)
      ]);
    ***REMOVED*** else
      return tile;
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
