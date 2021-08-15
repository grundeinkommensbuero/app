import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/shared/DistanceHelper.dart';
import 'package:poly/poly.dart' as poly;

import 'BackendService.dart';

class GeoService {
  late HttpClient httpClient;

  String nominatimHost = 'nominatim.openstreetmap.org';
  String overpassHost = 'overpass.kumi.systems';

  int port = 443;

  GeoService({HttpClient? httpMock***REMOVED***) {
    if (httpMock == null) httpClient = HttpClient();
  ***REMOVED***

  Future<GeoData> getDescriptionToPoint(LatLng point) async {
    Uri url = Uri.https(nominatimHost, 'reverse', {
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

  Future<List> getPolygonAndDescriptionOfPoint(LatLng point) async {
    var twoMeterLat = DistanceHelper.getLatDiffFromM(point, 10.0);
    var twoMeterLng = DistanceHelper.getLongDiffFromM(point, 10.0);
    var upperRightLat = point.latitude - twoMeterLat;
    var upperRightLng = point.longitude - twoMeterLng;
    var lowerLeftLat = point.latitude + twoMeterLat;
    var lowerLeftLng = point.longitude + twoMeterLng;

    Uri url = Uri.https(overpassHost, 'api/interpreter/', {
      'data': Uri.decodeComponent(
          '[timeout:5][out:json];(way[building]($upperRightLat,$upperRightLng,$lowerLeftLat,$lowerLeftLng);); out body geom;')
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

    var buildingDataL = filterApartment(point, response.body['elements']);
    if (buildingDataL.isEmpty) {
      Uri url = Uri.https(overpassHost, 'api/interpreter/', {
        'data': Uri.decodeComponent(
            '[timeout:5][out:json];(relation[building]($upperRightLat,$upperRightLng,$lowerLeftLat,$lowerLeftLng);); out body geom;')
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
      buildingDataL = filterApartment(point, response.body['elements']);
    ***REMOVED***
    //TODO: capture empty list here
    var buildingData;
    var osmId;
    if (buildingDataL.isNotEmpty) {
      buildingData = buildingDataL[1];
      osmId = buildingDataL[0];
    ***REMOVED***

    //TODO solve empty elements list
    return [buildingData, osmId];
  ***REMOVED***

  List filterApartment(position, elements) {
    for (var asset in elements) {
      var geom = asset['geometry'];
      if (geom != null) {
        if (poly.Polygon(List<poly.Point<num>>.from(geom.map(
                (latlng) => (poly.Point<num>(latlng['lat'], latlng['lon'])))))
            .contains(position.latitude, position.longitude)) {
          return [
            asset['id'],
            List<LatLng>.from(
                geom.map((latlng) => (LatLng(latlng['lat'], latlng['lon']))))
          ];
        ***REMOVED***
      ***REMOVED*** else {
        var membersList = asset['members'];
        if (membersList != null) {
          for (var member in membersList) {
            if (member['role'] == 'outer') {
              if (poly.Polygon(List<poly.Point<num>>.from(member['geometry']
                      .map((latlng) =>
                          (poly.Point<num>(latlng['lat'], latlng['lon'])))))
                  .contains(position.latitude, position.longitude)) {
                return [
                  asset['id'],
                  List<LatLng>.from(member['geometry']
                      .map((latlng) => (LatLng(latlng['lat'], latlng['lon']))))
                ];
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
