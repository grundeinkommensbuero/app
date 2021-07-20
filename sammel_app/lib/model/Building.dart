import 'dart:core';
import 'dart:ui';

class Building
{

  var id;
  var latitude;
  var longitude;
  var adresse;
  var hausteil;
  DateTime datum;
  var benutzer;
  var shape;

  Building(this.id, this.adresse, this.hausteil, this.benutzer, this.datum,
      this.latitude, this.longitude, this.shape);

***REMOVED***

class SelectableBuilding extends Building
{
  var selected;

  SelectableBuilding(id, adresse, hausteil, benutzer, datum,
      latitude, longitude, shape, selected) : super(id, adresse, hausteil, benutzer, datum,
      latitude, longitude, shape)
  {
    this.selected = selected;
  ***REMOVED***

***REMOVED***

class BuildingColorSelector
{
  var selection_color = Color.fromARGB(0, 255,255,0);
  var recently_visited_color = Color.fromARGB(0, 0,255,0);
  var outdated_color = Color.fromARGB(0, 255,0,0);
  var first_time_color = Color.fromARGB(0,0,0,0);
  var outdated_time_span = Duration(days: 7);

  getDrawColor(building)
  {
    if(building.selected)
    {
      return selection_color;
    ***REMOVED***
    if(building.datum != null)
    {
      if(DateTime.now().difference(building.datum) < outdated_time_span)
      {
        return recently_visited_color;
      ***REMOVED***
      else
      {
        return outdated_color;
      ***REMOVED***
    ***REMOVED***
    else{
      return first_time_color;
    ***REMOVED***
  ***REMOVED***
***REMOVED***