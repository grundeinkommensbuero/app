import 'dart:async';
import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';

import 'UserService.dart';

abstract class AbstractPushSendService extends BackendService {
  AbstractPushSendService(userService, [Backend backendMock])
      : super(userService, backendMock);

  pushToDevices(
      List<String> recipients, PushData data, PushNotification notification);

  pushToTopic(String topic, PushData data, PushNotification notification);

  pushToAction(int actionId, PushData data, PushNotification notification);
}

class PushSendService extends AbstractPushSendService {
  PushSendService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification) async {
    if (recipients == null || recipients.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.");
    }

    try {
      post(
          'service/push/devices',
          jsonEncode(PushMessage(data, notification, recipients: recipients)
              .toJson()));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Push-Nachricht an Geräte konnte nicht versandt werden');
    }
  }

  pushToTopic(String topic, PushData data, PushNotification notification) {
    if (topic == null || topic.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.");
    }

    try {
      post('service/push/topic/$topic',
          jsonEncode(PushMessage(data, notification).toJson()));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Push-Nachricht an Thema konnte nicht versandt werden');
    }
  }

  pushToAction(
      int actionId, PushData data, PushNotification notification) async {
    if (actionId == null) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.");
    }

    print(
        'Push-Message: ${jsonEncode(PushMessage(data, notification).toJson())}');
    try {
      await post('service/push/action/$actionId',
          jsonEncode(PushMessage(data, notification).toJson()));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Push-Nachricht an Aktion konnte nicht versandt werden.');
    }
  }
}

class DemoPushSendService extends AbstractPushSendService {
  DemoPushSendService(AbstractUserService userService)
      : super(userService, DemoBackend());

  var controller = StreamController<PushData>.broadcast();

  get stream => controller.stream;

  @override
  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification) async {
    if (recipients == null || recipients.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.");
    }
    controller.add(data);
  }

  @override
  pushToTopic(String topic, PushData data, PushNotification notification) {
    if (topic == null || topic.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.");
    }
    controller.add(data);
  }

  pushToAction(int actionId, PushData data, PushNotification notification) {
    controller.add(data);
  }
}

class MissingTargetError {
  String message;

  MissingTargetError(this.message);
}
