import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http_server/http_server.dart';
import 'package:sammel_app/main.dart';
import 'package:sammel_app/model/Health.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/MessageException.dart';
import 'package:sammel_app/shared/ServerException.dart';

import 'AuthFehler.dart';
import 'RestFehler.dart';

class BackendService {
  Backend backend;
  AbstractUserService userService;

  static Map<String, String> appHeaders = {
    'Authorization': 'Basic ${AbstractUserService.appAuth}'
  };

  BackendService.userService();

  BackendService(AbstractUserService userService, this.backend) {
    // UserService ist sein eigener UserService
    if (!(this is AbstractUserService)) {
      if (userService == null) throw ArgumentError.notNull('userService');
      this.userService = userService;
    }
  }

  Future<HttpClientResponseBody> get(String url, {bool appAuth}) async {
    try {
      var response = await backend.get(url, await authHeaders(appAuth)).timeout(
          Duration(seconds: 5),
          onTimeout: () async => await checkConnectivity());

      if (response.response.statusCode >= 200 &&
          response.response.statusCode < 300) return response;

      if (response.response.statusCode == 403)
        throw AuthFehler(response.body.toString());

      // else
      throw RestFehler(response.body.toString());
    } on SocketException catch (e) {
      await checkConnectivity(originalError: e);
    }
  }

  Future<HttpClientResponseBody> post(String url, String data,
      {Map<String, String> parameters, bool appAuth}) async {
    try {
      var post = backend
          .post(url, data, await authHeaders(appAuth), parameters)
          .timeout(Duration(seconds: 10),
              onTimeout: () async => await checkConnectivity());
      var response = await post;

      if (response.response.statusCode >= 200 &&
          response.response.statusCode < 300) return response;

      if (response.response.statusCode == 403)
        throw AuthFehler.fromJson(response.body);

      // else
      throw RestFehler(response.body.toString());
    } on SocketException catch (e) {
      await checkConnectivity(originalError: e);
    }
  }

  Future<HttpClientResponseBody> delete(String url, String data,
      {bool appAuth}) async {
    try {
      var response = await backend
          .delete(url, data, await authHeaders(appAuth))
          .timeout(Duration(seconds: 2),
              onTimeout: () async => await checkConnectivity());

      if (response.response.statusCode >= 200 &&
          response.response.statusCode < 300) return response;

      if (response.response.statusCode == 403)
        throw AuthFehler.fromJson(response.body);

      // else
      throw RestFehler(response.body.toString());
    } on SocketException catch (e) {
      await checkConnectivity(originalError: e);
    }
  }

  Future<Map<String, String>> authHeaders(bool appAuth) {
    if (appAuth != null && appAuth)
      return Future.value(appHeaders);
    else
      return userService.userHeaders.timeout(Duration(seconds: 20),
          onTimeout: () => throw NoUserAuthException);
  }

  // http client throws SocketException on connection errors
  Future<HttpClientResponseBody> checkConnectivity({originalError}) async {
    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      // no internet connection
      throw ConnectivityException(
          'Es scheint keine Internet-Verbindung zu bestehen.');
    }

    var healthCall = backend.getServerHealth();
    var googleCall = backend.callGoogle();

    try {
      var serverHealth = await healthCall.timeout(Duration(seconds: 5),
          onTimeout: () async =>
              await googleCall.timeout(Duration(seconds: 2), onTimeout: () {
                // both server and google don't respond
                throw ConnectivityException(
                    "Die Internet-Verbindung scheint sehr langsam zu sein.");
              }).then((_) {
                // server doesn't respond but google does
                throw ConnectivityException(
                    'Der Server antwortet leider nicht. Möglicherweise ist er überlastet, versuch es doch später nochmal');
              }));
      // Server responds and is healthy
      if (serverHealth.alive)
        throw ConnectivityException(
            'Ein Verbindungsproblem ist aufgetreten: '.tr() +
                '${originalError?.message}');
      else
        // Server responds but has issues
        throw throw ConnectivityException(
            'Der Server hat leider gerade technische Probleme: '.tr() +
                serverHealth.status);
    } on SocketException catch (e) {
      try {
        await googleCall;
        // server refuses but google answers
        throw ConnectivityException(
            'Der Server reagiert nicht, obwohl eine Internet-Verbindung besteht. Vielleicht gibt es ein technisches Problem, bitte versuch es später nochmal. ${e.message}');
      } on SocketException catch (e) {
        // both server and google refuse
        throw ConnectivityException(
            'Das Internet scheint nicht erreichbar zu sein: '.tr() + e.message);
      }
    }
  }
}

class NoUserAuthException implements Exception {
  var message =
      'Es ist ein Fehler aufgetreten beim Verifizieren deines Benutzer*in-Accounts. Probiere es eventuell zu einem späteren Zeitpunkt noch einmal oder versuche die App nochmal neu zu installieren, wenn du keine eigenen Aktionen betreust.';
}

class Backend {
  static final host = testMode ? 'dwe.idash.org' : '10.0.2.2';
  static final port = testMode ? 443 : 18443;
  final String version;

  final Future<void> zertifikatGeladen = ladeZertifikat().timeout(
      Duration(seconds: 10),
      onTimeout: () =>
          throw TimeoutException('SSL-Zertifikat konnte nicht geladen werden'));

  static final clientContext = SecurityContext();
  static HttpClient client = HttpClient(context: clientContext);

  static final Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    HttpHeaders.acceptHeader: "*/*",
  };

  Backend(this.version) {
    var serverHealth = getServerHealth();
    serverHealth.then((health) {
      if (!health.alive)
        ErrorService.handleError(
            WarningException("Der Server meldet Probleme: ${health.status}"),
            StackTrace.current);
      if (int.parse(this.version.substring(this.version.indexOf('+') + 1)) <
          int.parse(health.minClient.substring(this.version.indexOf('+') + 1)))
        ErrorService.handleError(
            WarningException(
                'Deine App-Version ist veraltet. Dies ist die Version {version}, du musst aber mindestens Version {minClient} benutzen, damit die App richtig funktioniert.'
                    .tr(namedArgs: {
              'version': version,
              'minClient': health.minClient
            })),
            StackTrace.current);
    });
  }

  // Assets müssen außerhalb von Widgets mit dieser asynchronen Funktion ermittelt werden
  // Darum kann das Zertifikat nicht bei der Initialisierung geladen werden
  // there gotta be a better way to do this...
  static ladeZertifikat() async {
    // https://stackoverflow.com/questions/54104685/flutter-add-self-signed-certificate-from-asset-folder
    ByteData data = await rootBundle.load(rootCertificate);
    clientContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
    if (!testMode) {
      ByteData data = await rootBundle.load(localCertificate);
      clientContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
    }
  }

  static String rootCertificate = 'assets/security/root-cert.pem';
  static String localCertificate = 'assets/security/sammel-server_local.pem';

  Future<HttpClientResponseBody> get(
      String url, Map<String, String> headers) async {
    await zertifikatGeladen;
    var uri = Uri.parse(url);
    uri = Uri.https('$host:$port', uri.path, uri.queryParameters);
    return await client
        .getUrl(uri)
        .then((HttpClientRequest request) {
          Backend.headers
              .forEach((key, value) => request.headers.add(key, value));
          headers.forEach((key, value) => request.headers.add(key, value));
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

  Future<HttpClientResponseBody> post(
      String url, String data, Map<String, String> headers,
      [Map<String, String> parameters]) async {
    await zertifikatGeladen;
    return await client
        .postUrl(Uri.https('$host:$port', url, parameters))
        .then((HttpClientRequest request) {
          Backend.headers
              .forEach((key, value) => request.headers.add(key, value));
          headers.forEach((key, value) => request.headers.add(key, value));
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

  Future<HttpClientResponseBody> delete(
      String url, String data, Map<String, String> headers) async {
    await zertifikatGeladen;
    return await client
        .deleteUrl(Uri.https('$host:$port', url))
        .then((HttpClientRequest request) {
          Backend.headers
              .forEach((key, value) => request.headers.add(key, value));
          headers.forEach((key, value) => request.headers.add(key, value));
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

  Future<void> callGoogle() =>
      client.get("google.de", 80, '').then((r) => r.close());

  Future<ServerHealth> getServerHealth() => get('service/health', {})
      .then((HttpClientResponseBody body) => ServerHealth.fromJson(body.body));
}

class WrongResponseFormatException implements ServerException {
  final String message;

  WrongResponseFormatException([this.message = 'Falsches Format']);
}

class ConnectivityException implements Exception {
  var message;

  ConnectivityException(this.message);
}

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

  @override
  callGoogle() => throw UnimplementedError();

  @override
  getServerHealth() => throw UnimplementedError();

  @override
  bool compareVersions(String version, String minClient) =>
      throw UnimplementedError();

  @override
  String get version => throw UnimplementedError();

  @override
  Future<void> get zertifikatGeladen => throw UnimplementedError();
}

class DemoBackendShouldNeverBeUsedError {}
