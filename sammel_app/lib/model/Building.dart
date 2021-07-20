import 'dart:core';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

class Building {
  int? id;
  double latitude;
  double longitude;
  String adresse;
  String? hausteil;
  DateTime datum;
  int benutzer;
  String? shape;

  Building(this.id, this.latitude, this.longitude, this.adresse, this.hausteil,
      this.datum, this.benutzer, this.shape);

  Building.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        adresse = json['adresse'],
        hausteil = json['hausteil'],
        datum = ChronoHelfer.deserializeJsonDateTime(json['datum']),
        benutzer = json['benutzer'],
        shape = '';

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'adresse': adresse,
        'hausteil': hausteil,
        'datum': DateFormat('yyyy-MM-dd').format(datum),
        'benutzer': benutzer
      ***REMOVED***
***REMOVED***

class SelectableBuilding extends Building {
  var selected;

  SelectableBuilding(id, adresse, hausteil, benutzer, datum, latitude,
      longitude, shape, selected)
      : super(id, latitude, longitude, adresse, hausteil, benutzer, datum,
            shape) {
    this.selected = selected;
  ***REMOVED***
***REMOVED***

class BuildingColorSelector {
  var selection_color = Color.fromARGB(0, 255, 255, 0);
  var recently_visited_color = Color.fromARGB(0, 0, 255, 0);
  var outdated_color = Color.fromARGB(0, 255, 0, 0);
  var first_time_color = Color.fromARGB(0, 0, 0, 0);
  var outdated_time_span = Duration(days: 7);

  getDrawColor(building) {
    if (building.selected) {
      return selection_color;
    ***REMOVED***
    if (building.datum != null) {
      if (DateTime.now().difference(building.datum) < outdated_time_span) {
        return recently_visited_color;
      ***REMOVED*** else {
        return outdated_color;
      ***REMOVED***
    ***REMOVED*** else {
      return first_time_color;
    ***REMOVED***
  ***REMOVED***
***REMOVED***
