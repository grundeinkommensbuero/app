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
  PushSendService(AbstractUserService userService, [Backend backendMock])
      : super(userService, backendMock);

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
    } catch (e) {
      ErrorService.handleError(e);
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
    } catch (e) {
      ErrorService.handleError(e);
    }
  }

  pushToAction(int actionId, PushData data, PushNotification notification) {
    if (actionId == null) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.");
    }

    try {
      post('service/push/action/$actionId',
          jsonEncode(PushMessage(data, notification).toJson()));
    } catch (e) {
      ErrorService.handleError(e);
    }
  }
}

class DemoPushSendService extends AbstractPushSendService {
  DemoPushSendService(AbstractUserService userService)
      : super(userService, DemoBackend());

  var controller = StreamController<PushData>();

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
