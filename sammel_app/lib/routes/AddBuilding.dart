import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:poly/poly.dart' as poly;
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/ExpandableConstrainedBox.dart';
import 'package:sammel_app/shared/NoRotation.dart';
import 'package:sammel_app/shared/ServerException.dart';

import '../Provisioning.dart';

addNewVisitedHouseEvent(BuildContext context, Future<VisitedHouse?> future_vh) async {
  VisitedHouse? vh = await future_vh;
  if (vh != null) {
    //the last event is new. register at server
    var abstractVisitedHousesService =
        Provider.of<AbstractVisitedHousesService>(context, listen: false);
    var future_new_house =
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

showAddBuildingDialog(
    {required BuildContext context, required VisitedHouseView building_view, required double current_zoom_factor***REMOVED***) {
  Future<VisitedHouse?> future_vh = showDialog(
    context: context,
    builder: (context) => AddBuildingDialog(building_view, current_zoom_factor),
  );
  return addNewVisitedHouseEvent(context, future_vh);
***REMOVED***

class AddBuildingDialog extends StatefulWidget {
  late final LatLng? center;
  final VisitedHouseView building_view;
  final double current_zoom_factor;

  AddBuildingDialog(this.building_view, this.current_zoom_factor)
      : super(key: Key('add building dialog'));

  @override
  State<StatefulWidget> createState() {
    return AddBuildingDialogState(building_view);
  ***REMOVED***
***REMOVED***

class AddBuildingDialogState extends State<AddBuildingDialog> {
  LocationMarker? marker;
  late TextEditingController visitedHouseController;
  late TextEditingController visitedHousePartController;
  @required
  late VisitedHouseView building_view;
  late LatLng center;

  var showLoadingIndicator = false;

  AddBuildingDialogState(VisitedHouseView building_view) {
    this.building_view = building_view;
    this.center = LatLng(
        0.5 * (building_view.bbox.maxLatitude + building_view.bbox.minLatitude),
        0.5 *
            (building_view.bbox.maxLongitude +
                building_view.bbox.minLongitude));
    visitedHouseController = TextEditingController(text: '');
    visitedHousePartController = TextEditingController(text: '');
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
            building_view.selected_building?.adresse =
                visitedHouseController.text;
            building_view.selected_building?.visitation_events.last.hausteil =
                visitedHousePartController.text;
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
        'Addresse',
        textScaleFactor: 0.8,
      ).tr()),
      SizedBox(
        height: 5.0,
      ),
      TextFormField(
        key: Key('visited house adress input'),
        //  keyboardType: TextInputType.multiline,
        //onChanged: (input) => location.description = input,
        controller: visitedHouseController,
      ),
      Text(
        'Hausteil: Vorderhaus, Seitenflügel, Hausnummer, Etage'.tr(),
        textScaleFactor: 0.8,
      ).tr(),
      TextFormField(
        key: Key('visited house part input'),
        // keyboardType: TextInputType.multiline,
        //onChanged: (input) => location.description = input,
        controller: visitedHousePartController,
      )
    ];
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
    if(showLoadingIndicator)
      {
        return Stack(children: [map, Opacity(opacity: 0.7, child: Container(width: 300, height: 300,color: CampaignTheme.disabled)), Center(child: SizedBox(width: 100, height: 100, child: LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            color: CampaignTheme.primary)))]);
      ***REMOVED***
    return map;
  ***REMOVED***

  houseSelected(LatLng point) async {

    setState(() {
      showLoadingIndicator = true;
    ***REMOVED***);

    SelectableVisitedHouse? building = building_view.getBuildingByPoint(point);
    //not in current view
    if (building == null) {
      var building_from_server =
          await Provider.of<AbstractVisitedHousesService>(context,
                  listen: false)
              .getVisitedHouseOfPoint(point, true)
              .catchError((e, s) {
        ErrorService.handleError(e, s);
        return null;
      ***REMOVED***);
      if (building_from_server != null) {
        building =
            SelectableVisitedHouse.fromVisitedHouse(building_from_server);
      ***REMOVED***
    ***REMOVED***
    if(!mounted)
      return;
    
    setState(() {
      if (building != null &&
          building_view.selected_building?.osm_id != building.osm_id) {
        building_view.selected_building =
            SelectableVisitedHouse.clone(building);
        building_view.selected_building?.selected = true;
        var usr_id = Provider.of<AbstractUserService>(context, listen: false)
            .latestUser!
            .id;
        if (usr_id != null)
          building_view.selected_building?.visitation_events
              .add(VisitedHouseEvent(null, "Main", usr_id, DateTime.now()));
        visitedHouseController.text =
            '${building_view.selected_building?.adresse***REMOVED***';
        if (building_view.selected_building == null) {
          visitedHousePartController.text = '';
        ***REMOVED*** else {
          visitedHousePartController.text =
              building_view.selected_building!.visitation_events.last.hausteil;
        ***REMOVED***
        showLoadingIndicator = false;
      ***REMOVED***
      //venueController.text = geodata.description;
      // marker = LocationMarker(point);
    ***REMOVED***);
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
