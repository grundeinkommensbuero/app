import 'package:sammel_app/model/Termin.dart';

class EventService {
  Map<Type, List<Function>> listeners = Map();

  register(Type eventType, Function listener) async {
    assert(eventType is GlobalEvent);
    listeners[eventType].add(listener);
  ***REMOVED***

  raise(GlobalEvent event) =>
      listeners[event.runtimeType].forEach((listener) => listener(event));
***REMOVED***

class GlobalEvent {
  dynamic content;

  GlobalEvent(dynamic this.content);
***REMOVED***

class NewActionEvent extends GlobalEvent {
  NewActionEvent(List<Termin> content) : super(content);
***REMOVED***
