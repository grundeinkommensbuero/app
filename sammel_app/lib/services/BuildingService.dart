

import 'dart:io';
import 'dart:async';

import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:poly/poly.dart' as poly;

import 'GeoService.dart';

class MyBoundingBox extends BoundingBox
{
  bool containsPoint(LatLng point)
  {
    return minLatitude <= point.latitude && point.latitude <= maxLatitude && minLongitude <= point.longitude && point.longitude <= maxLongitude;
  ***REMOVED***

  bool intersect(BoundingBox bbox)
  {
    return containsPoint(LatLng(bbox.minLatitude, bbox.minLongitude)) || containsPoint(LatLng(bbox.maxLatitude, bbox.maxLongitude))
  ***REMOVED***
***REMOVED***


class BuildingView
{
  List<Building> buildings;
  MyBoundingBox bbox;
  Building selected_building;

  Building getBuildingByPoint(LatLng point)
  {
    if(!bbox.containsPoint(point.latitude, point.longitude))
      {
        return null;
      ***REMOVED***
    for(building in buildings)
      {
        if(building.shape.contains(position.latitude, position.longitude))
          return building;
      ***REMOVED***
    return null;
  ***REMOVED***

  selectBuilding(LatLng point)
  {
    var new_selected_building = getBuildingByPoint(point);
    if(selected_building != null)
      {
        new_selected_building.select = true;
        selected_building?.select = false;
      ***REMOVED***
  ***REMOVED***

***REMOVED***

class AbstractBuildingService {

  var localBuildingMap = Map();

  Future<Building> getPolygonOfPoint(LatLng point, GeoData geo_data,
      bool check_on_server);

  Future<BuildingView> getBuildingsInArea(BoundingBox bbox) async
  {
    //TODO: it only checks for local buildings atm
    //TODO: take a bit more clever data format
    var buildings_in_roi = [];
    for (building in localBuildingMap) {
      if (building.bbox.intersect(bbox_oi)) {
        buildings_in_roi.append(building);
      ***REMOVED***
    ***REMOVED***
    return buildings_in_roi;
  ***REMOVED***
***REMOVED***


class DemoBuildingService extends AbstractBuildingService
{
   var localBuildingMap = {***REMOVED***
   Future<Building> getPolygonOfPoint(LatLng point, GeoData geo_data, bool check_on_server) async {
     return Building();
   ***REMOVED***
***REMOVED***

class BuildingService extends AbstractBuildingService
{

  String overpass_host = 'lz4.overpass-api.de';
  var earth_radius = 6371000;
  late HttpClient httpClient;

  Future<Building> getPolygonOfPoint(LatLng point, GeoData geo_data, bool check_on_server) async {

    var two_meter_lat = 0.001;//2.0/cos(point.latitude/360).abs()/earth_radius;
    var two_meter_lng = 0.001;//2.0/cos(point.latitude/360).abs()/earth_radius;
    point.latitude = 52.4913;
    point.longitude = 13.4317433;
    var upper_right_lat = point.latitude-two_meter_lat;
    var upper_right_lng = point.longitude-two_meter_lng;
    var lower_left_lat = point.latitude+two_meter_lat;
    var lower_left_lng = point.longitude+two_meter_lng;

    Uri url = Uri.https(overpass_host, 'api/interpreter/', {
      'data': Uri.decodeComponent('[timeout:5][out:json];(way[building]($upper_right_lat,$upper_right_lng,$lower_left_lat,$lower_left_lng);); out body geom;')
    ***REMOVED***);

    var response = await httpClient
        .getUrl(url)
        .then((request) => request.close())
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
      return body;
    ***REMOVED***);

    if (response.response.statusCode < 200 ||
        response.response.statusCode >= 300)
      throw OsmResponseException(response.body.toString());


    var building_data = filterApartment(point, response.body['elements']);

    if (building_data == null) return null;

    return getBuildingFromJson(building_data, point, geo_data, check_on_server);
  ***REMOVED***

  getBuildingFromJson(building_data, point, geo_data, check_on_server)
  {
    if(localBuildingMap.containsKey(building_data['id']))
      {
        return localBuildingMap[building_data['id']];
      ***REMOVED***
    else if(check_on_server) {
      return null;
    ***REMOVED***
    else{
      return Building(building_data['id'], point.latitude, point.longitude, '${geo_data.street***REMOVED*** ${geo_data.number***REMOVED***' , null, null, null,
          poly.Polygon(building_data['geometry'].map((latlng) =>
          (poly.Point<num>(latlng['lat'], latlng['lon']))).cast<poly.Point<num>>().toList()));
    ***REMOVED***
  ***REMOVED***

  filterApartment(position, elements) {
    for(var asset in elements)
    {
      print(asset);
      if(poly.Polygon(asset['geometry'].map((latlng) =>
      (poly.Point<num>(latlng['lat'], latlng['lon']))).cast<poly.Point<num>>().toList()).contains(position.latitude, position.longitude)) {
        return asset;
      ***REMOVED***
    ***REMOVED***
    return null;
  ***REMOVED***
***REMOVED***