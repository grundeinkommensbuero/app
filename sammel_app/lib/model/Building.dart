import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:poly/poly.dart' as poly;

class VisitedHouseEvent {
  int benutzer;
  int? id;
  DateTime datum;
  String hausteil = "";
  String adresse = '';

  VisitedHouseEvent(this.id, this.adresse, this.hausteil, this.benutzer, this.datum);
***REMOVED***

class VisitedHouse {
  int osmId = -1;
  double latitude = -1.0;
  double longitude = -1.0;
  List<LatLng> shape = [];
  late BoundingBox bbox;
  List<VisitedHouseEvent> visitationEvents = [];

  VisitedHouse(this.osmId,this.latitude, this.longitude,
      this.shape, this.visitationEvents) {
    calculateBBox();
  ***REMOVED***

  void calculateBBox() {
    double minLat = 1000;
    double maxLat = -1000;
    double minLng = 1000;
    double maxLng = -1000;
    for (LatLng p in this.shape) {
      minLat = min(minLat, p.latitude);
      maxLat = max(maxLat, p.latitude);
      minLng = min(minLng, p.longitude);
      maxLng = max(maxLng, p.longitude);
    ***REMOVED***
    bbox = BoundingBox(minLat, minLng, maxLat, maxLng);
  ***REMOVED***

  VisitedHouse.fromJson(Map<dynamic, dynamic> json)
      : osmId = json['osmId'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        visitationEvents = [
          VisitedHouseEvent(json['id'],  json['adresse'], json['hausteil'], json['benutzer'],
              ChronoHelfer.deserializeJsonDateTime(json['datum']))
        ],
        shape = List<LatLng>.from(jsonDecode(json['shape']).map((e) => LatLng(e[0], e[1])))
  {
    calculateBBox();
  ***REMOVED***

  Map<dynamic, dynamic> toJson() => {
        'osmId': osmId,
        'id': visitationEvents.last.id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': visitationEvents.last.adresse,
        'hausteil': visitationEvents.last.hausteil,
        'datum': DateFormat('yyyy-MM-dd').format(visitationEvents.last.datum),
        'benutzer': visitationEvents.last.benutzer,
        'shape':
            '${shape.map((e) => '[${e.latitude***REMOVED***,${e.longitude***REMOVED***]').toList()***REMOVED***'
      ***REMOVED***

  bool inside(LatLng point) {
    return poly.Polygon(shape
            .map((latlng) =>
                (poly.Point<num>(latlng.latitude, latlng.longitude)))
            .cast<poly.Point<num>>()
            .toList())
        .contains(point.latitude, point.longitude);
  ***REMOVED***
***REMOVED***

class SelectableVisitedHouse extends VisitedHouse {
  var selected;

  SelectableVisitedHouse(
      osmId, latitude, longitude, shape, visitationEvents, selected)
      : super(osmId, latitude, longitude, shape, visitationEvents) {
    this.selected = selected;
  ***REMOVED***

  SelectableVisitedHouse.fromVisitedHouse(VisitedHouse vh, {selected: false***REMOVED***)
      : super(vh.osmId, vh.latitude, vh.longitude, vh.shape,
            vh.visitationEvents) {
    this.selected = selected;
  ***REMOVED***

  SelectableVisitedHouse.clone(SelectableVisitedHouse vh)
      : super(vh.osmId, vh.latitude, vh.longitude, vh.shape,
            List.from(vh.visitationEvents)) {
    selected = vh.selected;
  ***REMOVED***
***REMOVED***

class BuildingColorSelector {
  static var selectionColor = CampaignTheme.altPrimary;
  static var firstTimeColor = CampaignTheme.disabled;
  static var oneVisitColor = CampaignTheme.primaryBright;
  static var twoVisitsColor = CampaignTheme.primaryLight;
  static var manyVisitsColor = CampaignTheme.primary;

  static Color getDrawColorForSelectable(SelectableVisitedHouse building) {
    if (building.selected) {
      return selectionColor;
    ***REMOVED***
    if (building.visitationEvents.length > 0) {
      if(building.visitationEvents.length == 1)
        return oneVisitColor;
      else if(building.visitationEvents.length == 2)
        return twoVisitsColor;
      else
        return manyVisitsColor;
    ***REMOVED*** else {
      return firstTimeColor;
    ***REMOVED***
  ***REMOVED***
***REMOVED***
