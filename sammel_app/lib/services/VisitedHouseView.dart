

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
    return containsPoint(LatLng(bbox.minLatitude, bbox.minLongitude)) || containsPoint(LatLng(bbox.maxLatitude, bbox.maxLongitude))
        || bbox.containsPoint(LatLng(minLatitude, minLongitude)) || bbox.containsPoint(LatLng(maxLatitude, maxLongitude));
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
    List<Polygon> p = buildings.
    map((building) => Polygon(
        color: BuildingColorSelector.getDrawColor(building),
        borderStrokeWidth: 2.0,
        borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
            CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
        points: building.shape))
        .toList();
    if(selected_building != null && selected_building?.shape != null) {
        p.add(Polygon(
            color: BuildingColorSelector.getDrawColor(selected_building!),
            borderStrokeWidth: 2.0,
            borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
                CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
            points: selected_building!.shape));
      ***REMOVED***
    return p;
  ***REMOVED***
***REMOVED***