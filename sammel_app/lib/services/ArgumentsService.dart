import 'dart:convert';

import 'package:sammel_app/model/Arguments.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';

import 'ErrorService.dart';

abstract class AbstractArgumentsService extends BackendService {
  AbstractArgumentsService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  Future<void> createArguments(Arguments arguments);
***REMOVED***

class ArgumentsService extends AbstractArgumentsService {
  ArgumentsService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {***REMOVED***

  @override
  Future<void> createArguments(Arguments arguments) async {
    try {
      await post('service/vorbehalte', jsonEncode(arguments));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Eintragen von Vorbehalten ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class DemoArgumentsService extends AbstractArgumentsService {
  DemoArgumentsService(AbstractUserService userService)
      : super(userService, DemoBackend()) {***REMOVED***

  @override
  Future<void> createArguments(Arguments arguments) async {***REMOVED***
***REMOVED***
