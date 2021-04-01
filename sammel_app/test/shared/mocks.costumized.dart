import 'dart:async' as _i15;
import 'dart:io';
import 'dart:io' as _i24;

import 'package:firebase_core/firebase_core.dart' as _i19;
import 'package:firebase_messaging/firebase_messaging.dart' as _i35;
import 'package:firebase_messaging_platform_interface/src/notification_settings.dart'
    as _i21;
import 'package:firebase_messaging_platform_interface/src/remote_message.dart'
    as _i20;
import 'package:http_server/http_server.dart';
import 'package:http_server/src/http_body.dart' as _i8;
import 'package:latlong/latlong.dart' as _i31;
import 'package:mockito/mockito.dart' as _i2;
import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/GeoService.dart' as _i18;

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? securityContext) => MockClient();
***REMOVED***

class MockClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    final request = MockHttpClientRequest();
    when(request.close()).thenAnswer((_) async {
      var response = MockHttpClientResponse();
      when(response.statusCode).thenReturn(200);
      when(response.contentLength).thenReturn(0);
      when(response.compressionState)
          .thenReturn(HttpClientResponseCompressionState.notCompressed);
      when(response.listen).thenReturn((onData, {cancelOnError, onDone, onError***REMOVED***) => null);
      return response;
    ***REMOVED***);
    return Future.value(request);
  ***REMOVED***
***REMOVED***

class MockHttpClientRequest extends Mock implements HttpClientRequest {***REMOVED***

class _FakeSocket extends _i2.Fake implements _i24.Socket {***REMOVED***

class _FakeFirebaseApp extends _i2.Fake implements _i19.FirebaseApp {
  @override
  // ignore: hash_and_equals
  bool operator ==(dynamic other) => super == other;
***REMOVED***

class _FakeHttpHeaders extends _i2.Fake implements _i24.HttpHeaders {***REMOVED***

class _FakeHttpClientResponse extends _i2.Fake
    implements _i24.HttpClientResponse {***REMOVED***

/// A class which mocks [HttpClientResponse].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClientResponse extends _i2.Mock
    implements _i24.HttpClientResponse {
  MockHttpClientResponse() {
    _i2.throwOnMissingStub(this);
  ***REMOVED***

  @override
  int get statusCode =>
      (super.noSuchMethod(Invocation.getter(#statusCode), returnValue: 0)
          as int);

  @override
  String get reasonPhrase =>
      (super.noSuchMethod(Invocation.getter(#reasonPhrase), returnValue: '')
          as String);

  @override
  int get contentLength =>
      (super.noSuchMethod(Invocation.getter(#contentLength), returnValue: 0)
          as int);

  @override
  _i24.HttpClientResponseCompressionState get compressionState =>
      (super.noSuchMethod(Invocation.getter(#compressionState),
          returnValue: _i24.HttpClientResponseCompressionState
              .notCompressed) as _i24.HttpClientResponseCompressionState);

  @override
  bool get persistentConnection =>
      (super.noSuchMethod(Invocation.getter(#persistentConnection),
          returnValue: false) as bool);

  @override
  bool get isRedirect =>
      (super.noSuchMethod(Invocation.getter(#isRedirect), returnValue: false)
          as bool);

  @override
  List<_i24.RedirectInfo> get redirects =>
      (super.noSuchMethod(Invocation.getter(#redirects),
          returnValue: <_i24.RedirectInfo>[]) as List<_i24.RedirectInfo>);

  @override
  _i24.HttpHeaders get headers =>
      (super.noSuchMethod(Invocation.getter(#headers),
          returnValue: _FakeHttpHeaders()) as _i24.HttpHeaders);

  @override
  List<_i24.Cookie> get cookies =>
      (super.noSuchMethod(Invocation.getter(#cookies),
          returnValue: <_i24.Cookie>[]) as List<_i24.Cookie>);

  @override
  _i15.Future<_i24.HttpClientResponse> redirect(
          [String? method, Uri? url, bool? followLoops]) =>
      (super.noSuchMethod(
              Invocation.method(#redirect, [method, url, followLoops]),
              returnValue: Future.value(_FakeHttpClientResponse()))
          as _i15.Future<_i24.HttpClientResponse>);

  @override
  _i15.Future<_i24.Socket> detachSocket() => (super.noSuchMethod(
      Invocation.method(#detachSocket, []),
      returnValue: Future.value(_FakeSocket())) as _i15.Future<_i24.Socket>);
***REMOVED***

/// A class which mocks [HttpClientResponseBody].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClientResponseBody extends _i2.Mock
    implements _i8.HttpClientResponseBody {
  MockHttpClientResponseBody() {
    _i2.throwOnMissingStub(this);
  ***REMOVED***

  @override
  _i24.HttpClientResponse get response =>
      (super.noSuchMethod(Invocation.getter(#response),
          returnValue: _FakeHttpClientResponse()) as _i24.HttpClientResponse);

  @override
  String get type =>
      (super.noSuchMethod(Invocation.getter(#type), returnValue: '') as String);
***REMOVED***

/// A class which mocks [FirebaseMessaging].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseMessaging extends _i2.Mock implements _i35.FirebaseMessaging {
  MockFirebaseMessaging() {
    _i2.throwOnMissingStub(this);
  ***REMOVED***

  @override
  _i19.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp()) as _i19.FirebaseApp);

  @override
  set app(_i19.FirebaseApp? _app) =>
      super.noSuchMethod(Invocation.setter(#app, _app),
          returnValueForMissingStub: null);

  @override
  bool get isAutoInitEnabled =>
      (super.noSuchMethod(Invocation.getter(#isAutoInitEnabled),
          returnValue: false) as bool);

  @override
  _i15.Stream<String> get onTokenRefresh =>
      (super.noSuchMethod(Invocation.getter(#onTokenRefresh),
          returnValue: Stream<String>.empty()) as _i15.Stream<String>);

  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{***REMOVED***) as Map<dynamic, dynamic>);

  @override
  _i15.Future<_i20.RemoteMessage?> getInitialMessage() =>
      (super.noSuchMethod(Invocation.method(#getInitialMessage, []),
              returnValue: Future.value(_FakeRemoteMessage()))
          as _i15.Future<_i20.RemoteMessage?>);

  @override
  _i15.Future<void> deleteToken({String? senderId***REMOVED***) => (super.noSuchMethod(
      Invocation.method(#deleteToken, [], {#senderId: senderId***REMOVED***),
      returnValue: Future.value(null),
      returnValueForMissingStub: Future.value()) as _i15.Future<void>);

  @override
  _i15.Future<String?> getAPNSToken() =>
      (super.noSuchMethod(Invocation.method(#getAPNSToken, []),
          returnValue: Future.value('')) as _i15.Future<String?>);

  @override
  _i15.Future<String?> getToken({String? vapidKey***REMOVED***) => (super.noSuchMethod(
      Invocation.method(#getToken, [], {#vapidKey: vapidKey***REMOVED***),
      returnValue: Future.value('')) as _i15.Future<String?>);

  @override
  _i15.Future<_i21.NotificationSettings> getNotificationSettings() =>
      (super.noSuchMethod(Invocation.method(#getNotificationSettings, []),
              returnValue: Future.value(_FakeNotificationSettings()))
          as _i15.Future<_i21.NotificationSettings>);

  @override
  _i15.Future<_i21.NotificationSettings> requestPermission(
          {bool? alert = true,
          bool? announcement = false,
          bool? badge = true,
          bool? carPlay = false,
          bool? criticalAlert = false,
          bool? provisional = false,
          bool? sound = true***REMOVED***) =>
      (super.noSuchMethod(
              Invocation.method(#requestPermission, [], {
                #alert: alert,
                #announcement: announcement,
                #badge: badge,
                #carPlay: carPlay,
                #criticalAlert: criticalAlert,
                #provisional: provisional,
                #sound: sound
              ***REMOVED***),
              returnValue: Future.value(_FakeNotificationSettings()))
          as _i15.Future<_i21.NotificationSettings>);

  @override
  _i15.Future<void> sendMessage(
          {String? to,
          Map<String, String>? data,
          String? collapseKey,
          String? messageId,
          String? messageType,
          int? ttl***REMOVED***) =>
      (super.noSuchMethod(
          Invocation.method(#sendMessage, [], {
            #to: to,
            #data: data,
            #collapseKey: collapseKey,
            #messageId: messageId,
            #messageType: messageType,
            #ttl: ttl
          ***REMOVED***),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i15.Future<void>);

  @override
  _i15.Future<void> setAutoInitEnabled(bool? enabled) =>
      (super.noSuchMethod(Invocation.method(#setAutoInitEnabled, [enabled]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i15.Future<void>);

  @override
  _i15.Future<void> setForegroundNotificationPresentationOptions(
          {bool? alert = false, bool? badge = false, bool? sound = false***REMOVED***) =>
      (super.noSuchMethod(
          Invocation.method(#setForegroundNotificationPresentationOptions, [],
              {#alert: alert, #badge: badge, #sound: sound***REMOVED***),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i15.Future<void>);

  @override
  _i15.Future<void> subscribeToTopic(String? topic) =>
      (super.noSuchMethod(Invocation.method(#subscribeToTopic, [topic]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i15.Future<void>);

  @override
  _i15.Future<void> unsubscribeFromTopic(String? topic) =>
      (super.noSuchMethod(Invocation.method(#unsubscribeFromTopic, [topic]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i15.Future<void>);
***REMOVED***

class _FakeRemoteMessage extends _i2.Fake implements _i20.RemoteMessage {***REMOVED***

class _FakeNotificationSettings extends _i2.Fake
    implements _i21.NotificationSettings {***REMOVED***

/// A class which mocks [GeoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGeoService extends _i2.Mock implements _i18.GeoService {
  MockGeoService() {
    _i2.throwOnMissingStub(this);
  ***REMOVED***

  @override
  _i24.HttpClient get httpClient =>
      (super.noSuchMethod(Invocation.getter(#httpClient),
          returnValue: _FakeHttpClient()) as _i24.HttpClient);

  @override
  set httpClient(_i24.HttpClient? _httpClient) =>
      super.noSuchMethod(Invocation.setter(#httpClient, _httpClient),
          returnValueForMissingStub: null);

  @override
  String get host =>
      (super.noSuchMethod(Invocation.getter(#host), returnValue: '') as String);

  @override
  set host(String? _host) => super.noSuchMethod(Invocation.setter(#host, _host),
      returnValueForMissingStub: null);

  @override
  int get port =>
      (super.noSuchMethod(Invocation.getter(#port), returnValue: 0) as int);

  @override
  set port(int? _port) => super.noSuchMethod(Invocation.setter(#port, _port),
      returnValueForMissingStub: null);

  @override
  _i15.Future<_i18.GeoData> getDescriptionToPoint(_i31.LatLng? point) =>
      (super.noSuchMethod(Invocation.method(#getDescriptionToPoint, [point]),
              returnValue: Future.value(_FakeGeoData()))
          as _i15.Future<_i18.GeoData>);
***REMOVED***

class _FakeHttpClient extends _i2.Fake implements _i24.HttpClient {***REMOVED***

class _FakeGeoData extends _i2.Fake implements _i18.GeoData {***REMOVED***
