import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';

abstract class AbstractPushService extends BackendService {
  AbstractPushService([Backend backendMock]) : super(backendMock);

  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification);

  pushToTopic(String topic, PushData data, PushNotification notification);
  pushToAction(int actionId, PushData data, PushNotification notification);


  }

class PushService extends AbstractPushService {
  PushService([Backend backendMock]) : super(backendMock);

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

class DemoPushService extends AbstractPushService {
  DemoPushService() : super(DemoBackend());

  @override
  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification) async {
    if (recipients == null || recipients.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.");
    }
  }

  @override
  pushToTopic(String topic, PushData data, PushNotification notification) {
    if (topic == null || topic.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.");
    }
  }

  pushToAction(int actionId, PushData data, PushNotification notification) {
    //TODO
  }
}

class MissingTargetError {
  String message;

  MissingTargetError(this.message);
}
