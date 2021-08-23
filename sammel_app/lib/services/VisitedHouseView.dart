import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:sammel_app/model/VisitedHouse.dart';
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
  List<SelectableVisitedHouse> houses;
  BoundingBox bbox;
  SelectableVisitedHouse? selectedHouse;

  VisitedHouseView(this.bbox, this.houses);

  SelectableVisitedHouse? getHouseByPoint(LatLng point) {
    if (!bbox.containsPoint(point)) {
      return null;
    ***REMOVED***
    for (SelectableVisitedHouse house in houses) {
      if (house.inside(point)) return house;
    ***REMOVED***
    return null;
  ***REMOVED***

  selectHouse(LatLng point) {
    SelectableVisitedHouse? newSelectedHouse = getHouseByPoint(point);
    newSelectedHouse?.selected = true;
    selectedHouse?.selected = false;
    if (newSelectedHouse != null) {
      selectedHouse = newSelectedHouse;
    ***REMOVED***
    return newSelectedHouse;
  ***REMOVED***

  List<Polygon> buildDrawablePolygonsFromView() {
    List<SelectableVisitedHouse> houseslist = [];
    if (selectedHouse != null)
      houseslist = houses
          .where((element) => element.osmId != selectedHouse!.osmId)
          .toList()
            ..add(selectedHouse!);
    else
      houseslist = houses;

    List<Polygon> polygons = houseslist
        .map((house) => Polygon(
            color: VisitedHouseColorSelector.getDrawColorForSelectable(house),
            borderStrokeWidth: 2.0,
            borderColor: Color.fromARGB(250, CampaignTheme.secondary.red,
                CampaignTheme.secondary.green, CampaignTheme.secondary.blue),
            points: house.shape))
        .toList();

    return polygons;
  ***REMOVED***
***REMOVED***
