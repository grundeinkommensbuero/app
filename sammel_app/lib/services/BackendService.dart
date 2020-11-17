import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/main.dart';
import 'package:sammel_app/services/UserService.dart';

import 'AuthFehler.dart';
import 'RestFehler.dart';

class BackendService {
  Backend backend;
  AbstractUserService userService;

  static Map<String, String> appHeaders = {
    'Authorization': 'Basic ${AbstractUserService.appAuth***REMOVED***'
  ***REMOVED***
  Future<Map<String, String>> userHeaders;

  BackendService.userService();

  BackendService(AbstractUserService userService, [Backend backendMock]) {
    backend = backendMock ?? Backend();

    // UserService ist sein eigener UserService
    if (!(this is AbstractUserService)) {
      if (userService == null) throw ArgumentError.notNull('userService');
      this.userService = userService;

      userHeaders = this
          .userService
          .userAuthCreds
          .asStream()
          .map((creds) => {"Authorization": "Basic $creds"***REMOVED***)
          .first;
    ***REMOVED***
  ***REMOVED***

  Future<HttpClientResponseBody> delete(String url, String data,
      {bool appAuth***REMOVED***) async {
    var response = await backend.delete(url, data, await authHeaders(appAuth));

    if (response.response.statusCode >= 200 &&
        response.response.statusCode < 300) return response;

    if (response.response.statusCode == 403)
      throw AuthFehler.fromJson(response.body);

    // else
    throw RestFehler(response.body.toString());
  ***REMOVED***

  Future<HttpClientResponseBody> get(String url, {bool appAuth***REMOVED***) async {
    var response = await backend.get(url, await authHeaders(appAuth));

    if (response.response.statusCode >= 200 &&
        response.response.statusCode < 300) return response;

    if (response.response.statusCode == 403) throw AuthFehler(response.body);

    // else
    throw RestFehler(response.body.toString());
  ***REMOVED***

  Future<HttpClientResponseBody> post(String url, String data,
      {Map<String, String> parameters, bool appAuth***REMOVED***) async {
    var response =
        await backend.post(url, data, await authHeaders(appAuth), parameters);

    if (response.response.statusCode >= 200 &&
        response.response.statusCode < 300) return response;

    if (response.response.statusCode == 403)
      throw AuthFehler.fromJson(response.body);

    // else
    throw RestFehler(response.body.toString());
  ***REMOVED***

  Future<Map<String, String>> authHeaders(bool appAuth) {
    if (appAuth != null && appAuth)
      return Future.value(appHeaders);
    else
      return userHeaders.timeout(Duration(seconds: 10),
          onTimeout: () => throw NoUserAuthException);
  ***REMOVED***
***REMOVED***

class NoUserAuthException implements Exception {***REMOVED***

class Backend {
  static final host = testMode ? 'dwe.idash.org' : '10.0.2.2';
  static final port = testMode ? 443 : 18443;

  static final clientContext = SecurityContext();
  static HttpClient client = HttpClient(context: clientContext);

  static final Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*/*",
  ***REMOVED***

  // Zertifikat muss nur einmal global über alle Services geladen werden
  static bool zertifikatGeladen = false;

  Backend() {
    if (!zertifikatGeladen) {
      zertifikatGeladen = true;
      ladeZertifikat();
    ***REMOVED***
  ***REMOVED***

  // Assets müssen außerhalb von Widgets mit dieser asynchronen Funktion ermittelt werden
  // Darum kann das Zertifikat nicht bei der Initialisierung geladen werden
  // there gotta be a better way to do this...
  static ladeZertifikat() async {
    // https://stackoverflow.com/questions/54104685/flutter-add-self-signed-certificate-from-asset-folder
    ByteData data = await rootBundle.load(rootCertificate);
    clientContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
    if(demoMode) {
      ByteData data = await rootBundle.load(localCertificate);
      clientContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
    ***REMOVED***
  ***REMOVED***

  static String rootCertificate = 'assets/security/root-cert.pem';
  static String localCertificate = 'assets/security/sammel-server_10.0.2.2.pem';

  Future<HttpClientResponseBody> get(
      String url, Map<String, String> headers) async {
    var uri = Uri.parse(url);
    uri = Uri.https('$host:$port', uri.path, uri.queryParameters);
    return await client
        .getUrl(uri)
        .then((HttpClientRequest request) {
          request.headers.contentType = ContentType.json;
          Backend.headers
              .forEach((key, value) => request.headers.add(key, value));
          headers.forEach((key, value) => request.headers.add(key, value));
          return request.close();
        ***REMOVED***)
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
          if (body.type != "json") {
            throw WrongResponseFormatException(
                'Get-Request bekommt "${body.type***REMOVED***",'
                ' statt "json" - Response zurück: ${body.body***REMOVED***');
          ***REMOVED*** else {
            return body;
          ***REMOVED***
        ***REMOVED***);
  ***REMOVED***

  Future<HttpClientResponseBody> post(
      String url, String data, Map<String, String> headers,
      [Map<String, String> parameters]) async {
    return await client
        .postUrl(Uri.https('$host:$port', url, parameters))
        .then((HttpClientRequest request) {
          request.headers.contentType = ContentType.json;
          Backend.headers
              .forEach((key, value) => request.headers.add(key, value));
          headers.forEach((key, value) => request.headers.add(key, value));
          request.write(data);
          return request.close();
        ***REMOVED***)
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
          if (body.type != "json" &&
              ((body is List && (body.body as List).isNotEmpty) ||
                  ((body is String && (body as String).isEmpty)))) {
            var message = 'Post-Request bekommt "${body.type***REMOVED***",'
                ' statt "json" - Response zurück: ${body.body***REMOVED***';
            throw WrongResponseFormatException(message);
          ***REMOVED*** else {
            return body;
          ***REMOVED***
        ***REMOVED***);
  ***REMOVED***

  Future<HttpClientResponseBody> delete(
      String url, String data, Map<String, String> headers) async {
    return await client
        .deleteUrl(Uri.https('$host:$port', url))
        .then((HttpClientRequest request) {
          request.headers.contentType = ContentType.json;
          Backend.headers
              .forEach((key, value) => request.headers.add(key, value));
          headers.forEach((key, value) => request.headers.add(key, value));
          request.write(data);
          return request.close();
        ***REMOVED***)
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
          if (body.type != "json" &&
              ((body is List && (body.body as List).isNotEmpty) ||
                  ((body is String && (body as String).isEmpty)))) {
            var message = 'Delete-Request bekommt "${body.type***REMOVED***",'
                ' statt "json" - Response zurück: ${body.body***REMOVED***';
            throw WrongResponseFormatException(message);
          ***REMOVED*** else {
            return body;
          ***REMOVED***
        ***REMOVED***);
  ***REMOVED***

  // from https://stackoverflow.com/questions/27808848/retrieving-the-response-body-from-an-httpclientresponse
  static String body(List<dynamic> response) {
    return response.map((dyn) => dyn as String).join();
  ***REMOVED***
***REMOVED***

class WrongResponseFormatException implements Exception {
  final String message;

  WrongResponseFormatException(this.message);
***REMOVED***

class DemoBackend implements Backend {
  @override
  Future<HttpClientResponseBody> delete(
          String url, String data, Map<String, String> headers) =>
      throw DemoBackendShouldNeverBeUsedError();

  @override
  Future<HttpClientResponseBody> get(String url, Map<String, String> headers) =>
      throw DemoBackendShouldNeverBeUsedError();

  @override
  Future<HttpClientResponseBody> post(
          String url, String data, Map<String, String> headers,
          [Map<String, String> parameters]) =>
      throw DemoBackendShouldNeverBeUsedError();
***REMOVED***

class DemoBackendShouldNeverBeUsedError {***REMOVED***
