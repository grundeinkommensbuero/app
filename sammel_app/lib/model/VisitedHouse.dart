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

class Visitation {
  int benutzer;
  int? id;
  DateTime datum;
  String hausteil = "";
  String adresse = '';

  Visitation(this.id, this.adresse, this.hausteil, this.benutzer, this.datum);
}

class VisitedHouse {
  int osmId = -1;
  double latitude = -1.0;
  double longitude = -1.0;
  List<LatLng> shape = [];
  late BoundingBox bbox;
  List<Visitation> visitations = [];

  VisitedHouse(
      this.osmId, this.latitude, this.longitude, this.shape, this.visitations) {
    calculateBBox();
  }

  VisitedHouse.clone(VisitedHouse house)
      : osmId = house.osmId,
        latitude = house.latitude,
        longitude = house.longitude,
        shape = house.shape,
        visitations = List.from(house.visitations);

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
    }
    bbox = BoundingBox(minLat, minLng, maxLat, maxLng);
  }

  VisitedHouse.fromJson(Map<dynamic, dynamic> json)
      : osmId = json['osmId'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        visitations = [
          Visitation(
              json['id'],
              json['adresse'],
              json['hausteil'],
              json['benutzer'],
              ChronoHelfer.deserializeJsonDateTime(json['datum']))
        ],
        shape = List<LatLng>.from(
            jsonDecode(json['shape']).map((e) => LatLng(e[0], e[1]))) {
    calculateBBox();
  }

  Map<dynamic, dynamic> toJson() => {
        'osmId': osmId,
        'id': visitations.last.id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': visitations.last.adresse,
        'hausteil': visitations.last.hausteil,
        'datum': DateFormat('yyyy-MM-dd').format(visitations.last.datum),
        'benutzer': visitations.last.benutzer,
        'shape':
            '${shape.map((e) => '[${e.latitude},${e.longitude}]').toList()}'
      };

  bool inside(LatLng point) {
    return poly.Polygon(shape
            .map((latlng) =>
                (poly.Point<num>(latlng.latitude, latlng.longitude)))
            .cast<poly.Point<num>>()
            .toList())
        .contains(point.latitude, point.longitude);
  }
}

class SelectableVisitedHouse extends VisitedHouse {
  var selected;

  SelectableVisitedHouse(
      osmId, latitude, longitude, shape, visitationEvents, selected)
      : super(osmId, latitude, longitude, shape, visitationEvents) {
    this.selected = selected;
  }

  SelectableVisitedHouse.fromVisitedHouse(VisitedHouse vh, {selected: false})
      : super(vh.osmId, vh.latitude, vh.longitude, vh.shape, vh.visitations) {
    this.selected = selected;
  }

  SelectableVisitedHouse.clone(SelectableVisitedHouse vh)
      : super(vh.osmId, vh.latitude, vh.longitude, vh.shape,
            List.from(vh.visitations)) {
    selected = vh.selected;
  }
}

class VisitedHouseColorSelector {
  static var selectionColor = CampaignTheme.altPrimary;
  static var firstTimeColor = CampaignTheme.disabled;
  static var oneVisitColor = CampaignTheme.primaryBright;
  static var twoVisitsColor = CampaignTheme.primaryLight;
  static var manyVisitsColor = CampaignTheme.primary;

  static Color getDrawColorForSelectable(SelectableVisitedHouse house) {
    if (house.selected) {
      return selectionColor;
    }
    if (house.visitations.length > 0) {
      if (house.visitations.length == 1)
        return oneVisitColor;
      else if (house.visitations.length == 2)
        return twoVisitsColor;
      else
        return manyVisitsColor;
    } else {
      return firstTimeColor;
    }
  }
}
