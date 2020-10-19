import 'dart:convert';

import 'package:sammel_app/model/PushMessage.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';

abstract class AbstractPushService extends BackendService {
  AbstractPushService(userService, [Backend backendMock])
      : super(userService, backendMock);

  pushToDevices(
      List<String> recipients, PushData data, PushNotification notification);

  pushToTopic(String topic, PushData data, PushNotification notification);
***REMOVED***

class PushService extends AbstractPushService {
  PushService(userService, [Backend backendMock])
      : super(userService, backendMock);

  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification) async {
    if (recipients == null || recipients.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.");
    ***REMOVED***

    try {
      post(
          'service/push/devices',
          jsonEncode(PushMessage(data, notification, recipients: recipients)
              .toJson()));
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e);
    ***REMOVED***
  ***REMOVED***

  pushToTopic(String topic, PushData data, PushNotification notification) {
    if (topic == null || topic.isEmpty) {
      throw MissingTargetError(
          "Für Push-Nachrichten an Topics muss ein Topic angegeben werden.");
    ***REMOVED***

    try {
      post('service/push/topic',
          jsonEncode(PushMessage(data, notification, topic: topic).toJson()));
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e);
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoPushService extends AbstractPushService {
  DemoPushService(userService) : super(userService, DemoBackend());

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
