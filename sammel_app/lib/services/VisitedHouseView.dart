import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

class BoundingBox {
  var maxLatitude, minLatitude, minLongitude, maxLongitude;

  BoundingBox(
      this.minLatitude, this.minLongitude, this.maxLatitude, this.maxLongitude);

  bool containsPoint(LatLng point) {
    return minLatitude <= point.latitude &&
        point.latitude <= maxLatitude &&
        minLongitude <= point.longitude &&
        point.longitude <= maxLongitude;
  ***REMOVED***

  bool intersect(BoundingBox bbox) {
    return minLatitude < bbox.maxLatitude &&
        bbox.minLatitude < maxLatitude &&
        minLongitude < bbox.maxLongitude &&
        bbox.minLongitude < maxLongitude;
  ***REMOVED***
***REMOVED***

class VisitedHouseView {
  List<SelectableVisitedHouse> buildings;
  BoundingBox bbox;
  SelectableVisitedHouse? selectedBuilding;

  VisitedHouseView(this.bbox, this.buildings);

  SelectableVisitedHouse? getBuildingByPoint(LatLng point) {
    if (!bbox.containsPoint(point)) {
      return null;
    ***REMOVED***
    for (SelectableVisitedHouse building in buildings) {
      if (building.inside(point)) return building;
    ***REMOVED***
    return null;
  ***REMOVED***

  selectBuilding(LatLng point) {
    SelectableVisitedHouse? newSelectedBuilding = getBuildingByPoint(point);
    newSelectedBuilding?.selected = true;
    selectedBuilding?.selected = false;
    if (newSelectedBuilding != null) {
      selectedBuilding = newSelectedBuilding;
    ***REMOVED***
    return newSelectedBuilding;
  ***REMOVED***

  List<Polygon> buildDrawablePolygonsFromView() {
    List<SelectableVisitedHouse> houseslist = [];
    if (selectedBuilding != null)
      houseslist = buildings
          .where((element) => element.osmId != selectedBuilding!.osmId)
          .toList()
            ..add(selectedBuilding!);
    else
      houseslist = buildings;

    List<Polygon> polygons = houseslist
        .map((building) => Polygon(
            color: BuildingColorSelector.getDrawColorForSelectable(building),
            borderStrokeWidth: 2.0,
            borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
                CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
            points: building.shape))
        .toList();

    return polygons;
  ***REMOVED***
***REMOVED***
