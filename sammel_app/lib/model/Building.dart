import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:poly/poly.dart' as poly;


class VisitedHouseEvent
{
  int benutzer;
  int? id;
  DateTime datum;
  String hausteil = "";

  VisitedHouseEvent(this.id, this.hausteil, this.benutzer, this.datum);
***REMOVED***

class VisitedHouse {

  int osm_id = -1;
  double latitude = -1.0;
  double longitude = -1.0;
  String adresse = '';
  List<LatLng> shape = [];
  late BoundingBox bbox;
  List<VisitedHouseEvent> visitation_events = [];

  VisitedHouse(this.osm_id, this.latitude, this.longitude, this.adresse,
      this.shape, this.visitation_events)
  {
    double minLat = 1000;
    double maxLat = -1000;
    double minLng = 1000;
    double maxLng = -1000;
    for(LatLng p in this.shape)
      {
        minLat = min(minLat, p.latitude);
        maxLat = max(maxLat, p.latitude);
        minLng = min(minLng, p.longitude);
        maxLng = max(maxLng, p.longitude);
      ***REMOVED***
    bbox = BoundingBox(minLat, minLng, maxLat, maxLng);

  ***REMOVED***

  VisitedHouse.fromJson(Map<dynamic, dynamic> json) :
      osm_id = json['osm_id'], latitude = json['latitude'], longitude = json['longitude'],
      adresse = json['adresse'], shape = json['shape'],
      visitation_events = [VisitedHouseEvent(json['id'], json['hausteil'], json['benutzer'], ChronoHelfer.deserializeJsonDateTime(json['datum']))];


  Map<dynamic, dynamic> toJson() => {
        'osm_id': osm_id,
        'id': visitation_events.last.id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': adresse,
        'hausteil': visitation_events.last.hausteil,
        'datum': DateFormat('yyyy-MM-dd').format(visitation_events.last.datum),
        'benutzer': visitation_events.last.benutzer
      ***REMOVED***

  bool inside(LatLng point) {
    return poly.Polygon(shape.map((latlng) =>
    (poly.Point<num>(latlng.latitude, latlng.longitude))).cast<poly.Point<num>>().toList()).contains(point.latitude, point.longitude);
  ***REMOVED***
***REMOVED***

class SelectableVisitedHouse extends VisitedHouse {
  var selected;

  SelectableVisitedHouse(osm_id, adresse, latitude,
      longitude, shape, visitation_events, selected)
      : super(osm_id, latitude, longitude, adresse, shape, visitation_events) {
    this.selected = selected;
  ***REMOVED***

  SelectableVisitedHouse.fromVisitedHouse(VisitedHouse vh, {selected: false***REMOVED*** )
  : super(  vh.osm_id, vh.latitude, vh.longitude, vh.adresse,
      vh.shape, vh.visitation_events)
  {
    this.selected = selected;
  ***REMOVED***

  SelectableVisitedHouse.clone(SelectableVisitedHouse vh)
  : super(vh.osm_id, vh.latitude, vh.longitude, vh.adresse, vh.shape, List.from(vh.visitation_events))
  {
    selected = vh.selected;
  ***REMOVED***
***REMOVED***

class BuildingColorSelector {
  static var selection_color = Color.fromARGB(100, 255, 255, 0);
  static var recently_visited_color = Color.fromARGB(100, 0, 255, 0);
  static var outdated_color = Color.fromARGB(100, 255, 0, 0);
  static var first_time_color = Color.fromARGB(100, 0, 0, 0);
  static var outdated_time_span = Duration(days: 7);


  static Color getDrawColorForSelectable(SelectableVisitedHouse building) {
    if (building.selected) {
      return selection_color;
    ***REMOVED***
    if (building.visitation_events != null && building.visitation_events.length > 0) {
      if (DateTime.now().difference(building.visitation_events.last.datum) < outdated_time_span) {
        return recently_visited_color;
      ***REMOVED*** else {
        return outdated_color;
      ***REMOVED***
    ***REMOVED*** else {
      return first_time_color;
    ***REMOVED***
  ***REMOVED***

  static Color getDrawColorForBuilding(VisitedHouse building) {
    if (building.visitation_events != null && building.visitation_events.length > 0) {
      if (DateTime.now().difference(building.visitation_events.last.datum) < outdated_time_span) {
        return recently_visited_color;
      ***REMOVED*** else {
        return outdated_color;
      ***REMOVED***
    ***REMOVED*** else {
      return first_time_color;
    ***REMOVED***
  ***REMOVED***

***REMOVED***

