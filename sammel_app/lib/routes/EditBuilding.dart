import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/NoRotation.dart';
import 'package:sammel_app/shared/ServerException.dart';

import '../Provisioning.dart';

addNewVisitedHouseEvent(BuildContext context, Future<VisitedHouse?> future_vh) async {
  VisitedHouse? vh = await future_vh;
  if (vh != null) {
    //the last event is new. register at server
    var abstractVisitedHousesService =
        Provider.of<AbstractVisitedHousesService>(context, listen: false);
    VisitedHouse future_new_house =
        abstractVisitedHousesService.editVisitedHouse(vh);
    return future_new_house;
  ***REMOVED***
  return null;
  /*
     VisitedHouse? new_house = await future_new_house;

     if(new_house != null)
       {
         VisitedHouse? building =  abstractVisitedHousesService.localBuildingMap[new_house.osm_id]
         if(abstractVisitedHousesService.localBuildingMap.containsKey(new_house.osm_id))
           {
             ?.visitation_events.add(new_house.visitation_events.last);

             for(VisitedHouseEvent event in new_house.visitation_events)
               {
                 if
               ***REMOVED***
           ***REMOVED***
         else
           {
             abstractVisitedHousesService.localBuildingMap[new_house.osm_id] = new_house;
           ***REMOVED***
       ***REMOVED***
   ***REMOVED****/
***REMOVED***

showEditVisitedHouseDialog(
    {required BuildContext context, required VisitedHouseView building_view, required double current_zoom_factor***REMOVED***) {
  Future<VisitedHouse?> future_vh = showDialog(
    context: context,
    builder: (context) => EditBuildingDialog(building_view, current_zoom_factor),
  );
  return addNewVisitedHouseEvent(context, future_vh);
***REMOVED***

class EditBuildingDialog extends StatefulWidget {
  late final LatLng? center;
  late final VisitedHouseView building_view;
  late final double current_zoom_factor;

  EditBuildingDialog(this.building_view, this.current_zoom_factor)
      : super(key: Key('add building dialog'));

  @override
  State<StatefulWidget> createState() {
    return EditBuildingDialogState(building_view);
  ***REMOVED***
***REMOVED***

class EditBuildingDialogState extends State<EditBuildingDialog> {
  LocationMarker? marker;
  @required
  late VisitedHouseView building_view;
  late LatLng center;

  var showLoadingIndicator = false;

  EditBuildingDialogState(VisitedHouseView building_view) {
    this.building_view = building_view;
    this.center = LatLng(
        0.5 * (building_view.bbox.maxLatitude + building_view.bbox.minLatitude),
        0.5 *
            (building_view.bbox.maxLongitude +
                building_view.bbox.minLongitude));
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Besuchtes Haus').tr(),
      content: SingleChildScrollView(
          child: Column(
                  mainAxisSize: MainAxisSize.min, children: build_widgets())),
      actions: [
        TextButton(
          child: Text("Abbrechen").tr(),
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
            Navigator.pop(context, building_view.selected_building);
          ***REMOVED***,
        ),
      ],
    );
  ***REMOVED***

  List<Widget> build_widgets() {
    var widgets = [
      Text(
        'Wähle das Haus auf der Karte aus.',
        textScaleFactor: 0.9,
      ).tr(),
      SizedBox(
        height: 5.0,
      ),
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: CampaignTheme.secondary, width: 1.0)),
          child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: buildFlutterMap())),
      SizedBox(
        height: 5.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Align(alignment: Alignment.centerLeft, child: Text(
        'Visitation Events',
        textScaleFactor: 1.2,
      ).tr()),
      SizedBox(
        height: 5.0,
      )
    ];
    if (building_view.selected_building != null &&
        building_view.selected_building!.visitation_events.length > 0) {
      widgets.addAll(building_view.selected_building!.visitation_events
          .map((e) => buildVisitationEventItem(e)));
      //widgets.add(Flexible(child: ListView.builder(shrinkWrap: true,
      //    itemCount: building_view.selected_building!.visitation_events.length,
      //    itemBuilder: buildVisitationEventItem)));
    ***REMOVED***
    return widgets;
  ***REMOVED***

  Widget buildFlutterMap() {
    var map = FlutterMap(
                key: Key('venue map'),
                options: MapOptions(
                    center: center,
                    zoom: widget.current_zoom_factor < 17 ? 17 : widget.current_zoom_factor,
                    interactiveFlags: noRotation,
                    swPanBoundary: LatLng(building_view.bbox.minLatitude,
                        building_view.bbox.minLongitude),
                    nePanBoundary: LatLng(building_view.bbox.maxLatitude,
                        building_view.bbox.maxLongitude),
                    maxZoom: geo.zoomMax,
                    minZoom: geo.zoomMin,
                    onTap: houseSelected,
                    plugins: [AttributionPlugin()]),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
                      subdomains: ['a', 'b', 'c']),
                  PolygonLayerOptions(
                      polygons: building_view.buildDrawablePolygonsFromView(),
                      polygonCulling: false),
                  MarkerLayerOptions(
                      markers: marker == null ? [] : [marker!]),
                  AttributionOptions(),
                ]);
    return map;
  ***REMOVED***

  houseSelected(LatLng point) async {

    SelectableVisitedHouse? building = building_view.getBuildingByPoint(point);
    //not in current view
    setState(() {
      if (building != null &&
          building_view.selected_building?.osm_id != building.osm_id) {
        building_view.selected_building =
            SelectableVisitedHouse.clone(building);
        building_view.selected_building?.selected = true;
      ***REMOVED***
      //venueController.text = geodata.description;
      // marker = LocationMarker(point);
    ***REMOVED***);
  ***REMOVED***

  Widget buildVisitationEventItem(VisitedHouseEvent item) {
    // VisitedHouseEvent item = building_view.selected_building!
    //   .visitation_events[index];
    if (item.benutzer ==
        Provider.of<AbstractUserService>(context, listen: false)
            .latestUser!
            .id) {
      return Row( children: [
        Expanded(
            child: ListTile(
          title: Text(
              "${DateFormat("yyyy-MM-dd").format(item.datum)***REMOVED***, ${item.hausteil***REMOVED***"),
        )),

             IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  // Remove the item from the data source.
                  setState(() {
                    building_view.selected_building!.visitation_events
                        .remove(item);
                  ***REMOVED***);
                ***REMOVED***)
      ]);
    ***REMOVED*** else {
      return ListTile(
        title: Text(
            "${DateFormat("yyyy-MM-dd").format(item.datum)***REMOVED***, ${item.hausteil***REMOVED***"),
      );
    ***REMOVED***
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
