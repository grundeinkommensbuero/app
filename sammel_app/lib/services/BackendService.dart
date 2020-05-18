import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/main.dart';

class BackendService implements Backend {
  Backend backend;

  BackendService([Backend backendMock]) {
    backend = backendMock ?? Backend();
  }

  @override
  Future<HttpClientResponseBody> delete(String url, String data) =>
      backend.delete(url, data);

  @override
  Future<HttpClientResponseBody> get(String url) => backend.get(url);

  @override
  Future<HttpClientResponseBody> post(String url, String data) =>
      backend.post(url, data);
}

class Backend {
  static final host = testMode ? '85.10.193.61' : '10.0.2.2';
  static const port = 18443;

  static final clientContext = SecurityContext();
  static HttpClient client = HttpClient(context: clientContext);

  static final Map<String, String> header = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*/*",
  };

  // Zertifikat muss nur einmal global über alle Services geladen werden
  static bool zertifikatGeladen = false;

  Backend() {
    if (!zertifikatGeladen) {
      zertifikatGeladen = true;
      ladeZertifikat();
    }
  }

  // Assets müssen außerhalb von Widgets mit dieser asynchronen Funktion ermittelt werden
  // Darum kann das Zertifikat nicht bei der Initialisierung geladen werden
  // there gotta be a better way to do this...
  static ladeZertifikat() async {
    // https://stackoverflow.com/questions/54104685/flutter-add-self-signed-certificate-from-asset-folder
    ByteData data = await rootBundle.load(serverCertificate);
    clientContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  static String get serverCertificate => testMode
      ? 'assets/security/sammel-server_85.10.193.61.pem'
      : 'assets/security/sammel-server_10.0.2.2.pem';

  Future<HttpClientResponseBody> get(String url) async {
    var uri = Uri.parse(url);
    uri = Uri.https('$host:$port', uri.path, uri.queryParameters);
    return await client
        .getUrl(uri)
        .then((HttpClientRequest request) {
          request.headers.contentType = ContentType.json;
          request.headers.add('Accept', 'application/json');
          return request.close();
        })
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
          if (body.type != "json") {
            throw WrongResponseFormatException(
                'Get-Request bekommt "${body.type}",'
                ' statt "json" - Response zurück: ${body.body}');
          } else {
            return body;
          }
        });
  }

  Future<HttpClientResponseBody> post(String url, String data) async {
    return await client
        .postUrl(Uri.https('$host:$port', url))
        .then((HttpClientRequest request) {
          request.headers.contentType = ContentType.json;
          request.headers.add('Accept', '*/*');
          request.write(data);
          return request.close();
        })
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
          if (body.type != "json" &&
              ((body is List && (body.body as List).isNotEmpty) ||
                  ((body is String && (body as String).isEmpty)))) {
            var message = 'Post-Request bekommt "${body.type}",'
                ' statt "json" - Response zurück: ${body.body}';
            throw WrongResponseFormatException(message);
          } else {
            return body;
          }
        });
  }

  Future<HttpClientResponseBody> delete(String url, String data) async {
    return await client
        .deleteUrl(Uri.https('$host:$port', url))
        .then((HttpClientRequest request) {
          request.headers.contentType = ContentType.json;
          request.headers.add('Accept', '*/*');
          request.write(data);
          return request.close();
        })
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) {
          if (body.type != "json" &&
              ((body is List && (body.body as List).isNotEmpty) ||
                  ((body is String && (body as String).isEmpty)))) {
            var message = 'Delete-Request bekommt "${body.type}",'
                ' statt "json" - Response zurück: ${body.body}';
            throw WrongResponseFormatException(message);
          } else {
            return body;
          }
        });
  }

  // from https://stackoverflow.com/questions/27808848/retrieving-the-response-body-from-an-httpclientresponse
  static String body(List<dynamic> response) {
    return response.map((dyn) => dyn as String).join();
  }
}

class WrongResponseFormatException {
  final String message;

  WrongResponseFormatException(this.message);
}

class DemoBackend implements Backend {
  @override
  Future<HttpClientResponseBody> delete(String url, String data) =>
      throw DemoBackendShouldNeverBeUsedError();

  @override
  Future<HttpClientResponseBody> get(String url) =>
      throw DemoBackendShouldNeverBeUsedError();

  @override
  Future<HttpClientResponseBody> post(String url, String data) =>
      throw DemoBackendShouldNeverBeUsedError();
}

class DemoBackendShouldNeverBeUsedError {}
