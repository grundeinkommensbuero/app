import 'dart:ui';

import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:http_server/http_server.dart';
import 'package:mockito/mockito.dart';
import 'package:sammel_app/model/ChatChannel.dart';

import '../shared/mocks.costumized.dart';
import '../shared/mocks.mocks.dart';
import 'TestdatenVorrat.dart';

MockStammdatenService trainStammdatenService(MockStammdatenService mock) {
  when(mock.kieze).thenAnswer((_) =>
      Future.value([ffAlleeNord(), tempVorstadt(), plaenterwald()].toSet()));
  when(mock.regionen).thenAnswer(
      (_) => Future.value([fhainOst(), kreuzbergSued(), koepenick1()].toSet()));
  when(mock.ortsteile).thenAnswer((_) =>
      Future.value([friedrichshain(), kreuzberg(), koepenick()].toSet()));
  return mock;
}

MockUserService trainUserService(MockUserService mock) {
  when(mock.user).thenAnswer((_) => Stream.value(karl()));
  when(mock.userHeaders)
      .thenAnswer((_) async => {'Authorization': 'userCreds'});
  return mock;
}

MockStorageService trainStorageService(MockStorageService mock) {
  when(mock.loadAllStoredEvaluations())
      .thenAnswer((_) => Future.value(List.empty()));
  when(mock.loadContact())
    .thenAnswer((_) => Future.value('Ruft an unter 123456'));
  return mock;
}

MockChatMessageService trainChatMessageService(MockChatMessageService mock) {
  when(mock.getTopicChannel('global'))
      .thenAnswer((_) => Future.value(ChatChannel('topic:global')));
  return mock;
}

MockBackend trainBackend(MockBackend mock) {
  when(mock.post(any, any, any))
      .thenAnswer((_) => Future.value(MockHttpClientResponseBody()));
  when(mock.get(any, any))
      .thenAnswer((_) => Future.value(MockHttpClientResponseBody()));
  when(mock.delete(any, any, any))
      .thenAnswer((_) => Future.value(MockHttpClientResponseBody()));
  when(mock.post('service/benutzer/authentifiziere', any, any)).thenAnswer((_) {
    return Future<HttpClientResponseBody>.value(
        trainHttpResponse(MockHttpClientResponseBody(), 200, true));
  });
  return mock;
}

HttpClientResponseBody trainHttpResponse(
    HttpClientResponseBody bodyMock, int status, dynamic content) {
  var clientMock = MockHttpClientResponse();
  when(clientMock.statusCode).thenReturn(status);
  when(bodyMock.response).thenAnswer((_) => clientMock);
  when(bodyMock.body).thenReturn(content);
  return bodyMock;
}

trainTranslation(MockTranslations mock, [Function(Translations)? training]) {
  when(mock.get(any)).thenAnswer((inv) => inv.positionalArguments[0]);
  if (training != null) training(mock);
  return Localization.load(Locale('en'), translations: mock);
}
