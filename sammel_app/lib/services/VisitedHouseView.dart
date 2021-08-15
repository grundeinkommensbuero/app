

import 'dart:io';
import 'dart:async';
import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:poly/poly.dart' as poly;
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/DistanceHelper.dart';

import 'GeoService.dart';

class BoundingBox
{

  var maxLatitude, minLatitude, minLongitude, maxLongitude;
  BoundingBox(this.minLatitude, this.minLongitude, this.maxLatitude, this.maxLongitude);

  bool containsPoint(LatLng point)
  {
    return minLatitude <= point.latitude && point.latitude <= maxLatitude && minLongitude <= point.longitude && point.longitude <= maxLongitude;
  ***REMOVED***

  bool intersect(BoundingBox bbox)
  {
    return minLatitude < bbox.maxLatitude && bbox.minLatitude < maxLatitude &&
           minLongitude < bbox.maxLongitude && bbox.minLongitude < maxLongitude;
  ***REMOVED***
***REMOVED***


class VisitedHouseView
{
  List<SelectableVisitedHouse> buildings;
  BoundingBox bbox;
  SelectableVisitedHouse? selected_building;

  VisitedHouseView(this.bbox, this.buildings);

  SelectableVisitedHouse? getBuildingByPoint(LatLng point)
  {
    if(!bbox.containsPoint(point))
      {
        return null;
      ***REMOVED***
    for(SelectableVisitedHouse building in buildings)
      {
        if(building.inside(point))
          return building;
      ***REMOVED***
    return null;
  ***REMOVED***

  selectBuilding(LatLng point)
  {
    SelectableVisitedHouse? new_selected_building = getBuildingByPoint(point);
    new_selected_building?.selected = true;
    selected_building?.selected = false;
    if(new_selected_building != null) {
        selected_building = new_selected_building;
      ***REMOVED***
    return new_selected_building;
  ***REMOVED***

  List<Polygon> buildDrawablePolygonsFromView()
  {
    List<SelectableVisitedHouse> b_list = [];
    if(selected_building != null)
      {
        print("### selected building not null");
        b_list = buildings.where((element) => element.osm_id != selected_building!.osm_id).toList()..add(selected_building!);
      ***REMOVED***
    else{
      b_list = buildings;
    ***REMOVED***
    List<Polygon> p = b_list.
    map((building) => Polygon(
        color: BuildingColorSelector.getDrawColorForSelectable(building),
        borderStrokeWidth: 2.0,
        borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
            CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
        points: building.shape))
        .toList();

    return p;
  ***REMOVED***
***REMOVED***