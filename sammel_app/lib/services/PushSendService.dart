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

  pushToAction(int actionId, PushData data, PushNotification notification);
***REMOVED***

class PushSendService extends AbstractPushSendService {
  PushSendService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  pushToDevices(List<String> recipients, PushData data,
      PushNotification notification) async {
    if (recipients == null || recipients.isEmpty) {
      throw MissingTargetError(
          'Für Push-Nachrichten an Geräte muss mindestens ein Empfänger angegeben werden.');
    ***REMOVED***

    try {
      post(
          'service/push/devices',
          jsonEncode(PushMessage(data, notification, recipients: recipients)
              .toJson()));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Push-Nachricht an Geräte konnte nicht versandt werden');
    ***REMOVED***
  ***REMOVED***

  pushToAction(
      int actionId, PushData data, PushNotification notification) async {
    if (actionId == null) {
      throw MissingTargetError(
          'Für Push-Nachrichten an Aktionen muss die Aktions-ID angegeben werden.');
    ***REMOVED***

    print(
        'Sende Push-Message: ${jsonEncode(PushMessage(data, notification).toJson())***REMOVED***');
    try {
      await post('service/push/action/$actionId',
          jsonEncode(PushMessage(data, notification).toJson()));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Push-Nachricht an Aktion konnte nicht versandt werden.');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

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
    ***REMOVED***
    controller.add(data);
  ***REMOVED***

  pushToAction(int actionId, PushData data, PushNotification notification) {
    controller.add(data);
  ***REMOVED***
***REMOVED***

class MissingTargetError {
  String message;

  MissingTargetError(this.message);
***REMOVED***
