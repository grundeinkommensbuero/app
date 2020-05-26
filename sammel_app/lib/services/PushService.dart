import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/BackendService.dart';

class PushService extends BackendService {
  PushService([Backend backendMock]) : super(backendMock);

  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification) async {
    if (recipients == null || recipients.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.");
    ***REMOVED***

    print(
        '# sende Nachricht: ${jsonEncode(PushMessage(data, notification, recipients: recipients).toJson())***REMOVED***');

    post(
        'service/push/devices',
        jsonEncode(
            PushMessage(data, notification, recipients: recipients).toJson()));
  ***REMOVED***

  pushToTopic(String topic, PushData data, PushNotification notification) {
    if (topic == null || topic.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.");
    ***REMOVED***

    post('service/push/topic',
        jsonEncode(PushMessage(data, notification, topic: topic).toJson()));
  ***REMOVED***
***REMOVED***

class DemoPushService extends PushService {
  @override
  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification) async {
    if (recipients == null || recipients.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.");
    ***REMOVED***
  ***REMOVED***

  @override
  pushToTopic(String topic, PushData data, PushNotification notification) {
    if (topic == null || topic.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.");
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class MissingTargetError {
  String message;

  MissingTargetError(this.message);
***REMOVED***
