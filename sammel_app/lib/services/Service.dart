import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http_server/http_server.dart';

class Service {
  static const host = '10.0.2.2';
  static const port = 18443;

  static final clientContext = SecurityContext();
  final client = HttpClient(context: clientContext);

  final Map<String, String> header = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*/*",
  };

  static bool zertifikatGeladen = false;

  // Assets müssen außerhalb von Widgets mit dieser asynchronen Funktion ermittelt werden
  // Darum kann das Zertifikat nicht bei der Initialisierung geladen werden
  // there gotta be a better way to do this...
  ladeZertifikat() async {
    // https://stackoverflow.com/questions/54104685/flutter-add-self-signed-certificate-from-asset-folder
    ByteData data =
        await rootBundle.load('assets/security/sammel-server_10.0.2.2.pem');
    clientContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
    zertifikatGeladen = true;
  }

  Future<HttpClientResponseBody> get(Uri url) async {
    if (!zertifikatGeladen) ladeZertifikat();
    return await client
        .getUrl(Uri.https('$host:$port', url.toString()))
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

  Future<HttpClientResponseBody> post(Uri url, String data) async {
    if (!zertifikatGeladen) ladeZertifikat();
    return await client
        .postUrl(Uri.https('$host:$port', url.toString()))
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
            var message = 'Get-Request bekommt "${body.type}",'
                ' statt "json" - Response zurück: ${body.body}';
            throw WrongResponseFormatException(message);
          } else {
            return body;
          }
        });
  }

  // from https://stackoverflow.com/questions/27808848/retrieving-the-response-body-from-an-httpclientresponse
  String body(List<dynamic> response) {
    return response.map((dyn) => dyn as String).join();
  }
}

class WrongResponseFormatException {
  final String message;

  WrongResponseFormatException(this.message);
}
