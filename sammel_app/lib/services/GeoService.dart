import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:latlong/latlong.dart';

import 'BackendService.dart';

class GeoService {
  late HttpClient httpClient;

  String host = 'nominatim.openstreetmap.org';
  int port = 443;

  GeoService({HttpClient? httpMock***REMOVED***) {
    if (httpMock == null) httpClient = HttpClient();
  ***REMOVED***

  Future<GeoData> getDescriptionToPoint(LatLng point) async {
    Uri url = Uri.https(host, 'reverse', {
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

    if (response.response.statusCode < 200 &&
            response.response.statusCode >= 300 ||
        response.body == null)
      throw OsmResponseException(response.body.toString());

    var geodata = response.body;

    if (geodata == null) return GeoData();

    return GeoData.fromJson(geodata);
  ***REMOVED***
***REMOVED***

class GeoData {
  String? name;
  String? street;
  String? number;

  GeoData([this.name, this.street, this.number]);

  GeoData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    street = json['address'] != null ? json['address']['road'] : null;
    number = json['address'] != null ? json['address']['house_number'] : null;
  ***REMOVED***

  String get description => [
        name,
        [(street), (number)].where((e) => e != null).join(' ')
      ].where((e) => e != null).join(', ');
***REMOVED***

class OsmResponseException implements Exception {
  var message;

  OsmResponseException(this.message);
***REMOVED***
