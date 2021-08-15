import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/shared/DistanceHelper.dart';
import 'package:poly/poly.dart' as poly;


import 'BackendService.dart';

class GeoService {
  late HttpClient httpClient;

  String nominatim_host = 'nominatim.openstreetmap.org';
  String overpass_host = 'overpass.kumi.systems';

  int port = 443;

  GeoService({HttpClient? httpMock***REMOVED***) {
    if (httpMock == null) httpClient = HttpClient();
  ***REMOVED***

  Future<GeoData> getDescriptionToPoint(LatLng point) async {
    Uri url = Uri.https(nominatim_host, 'reverse', {
      'lat': point.latitude.toString(),
      'lon': point.longitude.toString(),
      'format': 'jsonv2'
    ***REMOVED***);

    var response = await httpClient
        .getUrl(url)
        .then((request) => request.close())
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
      if (body.type != "json") {
        throw WrongResponseFormatException('Get-Request bekommt "${body.type***REMOVED***",'
            ' statt "json" - Response zurück: ${body.body***REMOVED***');
      ***REMOVED*** else {
        return body;
      ***REMOVED***
    ***REMOVED***);

    if (response.response.statusCode < 200 ||
        response.response.statusCode >= 300)
      throw OsmResponseException(response.body.toString());

    var geodata = response.body;

    if (geodata == null) return GeoData();

    return GeoData.fromJson(geodata);
  ***REMOVED***

  Future<List> getPolygonAndDescriptionOfPoint(LatLng point) async
  {
    var two_meter_lat = DistanceHelper.getLatDiffFromM(point, 10.0);
    var two_meter_lng = DistanceHelper.getLongDiffFromM(point, 10.0);
    var upper_right_lat = point.latitude-two_meter_lat;
    var upper_right_lng = point.longitude-two_meter_lng;
    var lower_left_lat = point.latitude+two_meter_lat;
    var lower_left_lng = point.longitude+two_meter_lng;

    Uri url = Uri.https(overpass_host, 'api/interpreter/', {
      'data': Uri.decodeComponent('[timeout:5][out:json];(way[building]($upper_right_lat,$upper_right_lng,$lower_left_lat,$lower_left_lng);); out body geom;')
    ***REMOVED***);
    Future<GeoData> gd_future = getDescriptionToPoint(point);
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

    var building_data_l = filterApartment(point, response.body['elements']);
    if(building_data_l.isEmpty)
      {
        Uri url = Uri.https(overpass_host, 'api/interpreter/', {
          'data': Uri.decodeComponent('[timeout:5][out:json];(relation[building]($upper_right_lat,$upper_right_lng,$lower_left_lat,$lower_left_lng);); out body geom;')
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
        building_data_l = filterApartment(point, response.body['elements']);
      ***REMOVED***
    //TODO: capture empty list here
    var building_data = null;
    var osm_id = null;
    if(!building_data_l.isEmpty)
      {
        building_data = building_data_l[1];
        osm_id = building_data_l[0];
      ***REMOVED***

    //TODO solve empty elements list
    return [building_data, osm_id];
  ***REMOVED***

  List filterApartment(position, elements) {
    for(var asset in elements)
    {
      var geom = asset['geometry'];
      if(geom != null)
        {
          if(poly.Polygon(List<poly.Point<num>>.from(geom.map((latlng) =>
          (poly.Point<num>(latlng['lat'], latlng['lon']))))).contains(position.latitude, position.longitude)) {
            return [asset['id'], List<LatLng>.from(geom.map((latlng) =>
            (LatLng(latlng['lat'], latlng['lon']))))];
          ***REMOVED***
        ***REMOVED***
      else{
        var mem_list = asset['members'];
        if(mem_list != null)
          {
            for(var mem in mem_list) {
              if (mem['role'] == 'outer') {
                if (poly.Polygon(
                    List<poly.Point<num>>.from(mem['geometry'].map((latlng) =>
                    (poly.Point<num>(latlng['lat'], latlng['lon']))))).contains(
                    position.latitude, position.longitude)) {
                  return [asset['id'], List<LatLng>.from(mem['geometry'].map((latlng) =>
                  (LatLng(latlng['lat'], latlng['lon']))))];
                ***REMOVED***
              ***REMOVED***
            ***REMOVED***
          ***REMOVED***
      ***REMOVED***

    ***REMOVED***
    return [];
  ***REMOVED***


***REMOVED***

class GeoData {
  String? name;
  String? street;
  String? number;
  String? postcode;
  String? city;

  GeoData([this.name, this.street, this.number, this.postcode, this.city]);

  GeoData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    street = json['address'] != null ? json['address']['road'] : null;
    number = json['address'] != null ? json['address']['house_number'] : null;
    postcode = json['address'] != null ? json['address']['postcode'] : null;
    city = json['address'] != null ? json['address']['city'] : null;
  ***REMOVED***

  String get description => [
        name,
        [(street), (number)].where((e) => e != null).join(' ')
      ].where((e) => e != null).join(', ');

  String get fullAdress => '${[
        (street),
        (number)
      ].where((e) => e != null).join(' ')***REMOVED***, $postcode $city';
***REMOVED***

class OsmResponseException implements Exception {
  var message;

  OsmResponseException(this.message);
***REMOVED***
