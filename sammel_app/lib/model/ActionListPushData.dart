import 'package:sammel_app/model/PushMessage.dart';

import 'Kiez.dart';
import 'Termin.dart';

class ActionListPushData implements PushData {
  @override
  String type = "ActionList";

  List<Termin> actions;

  ActionListPushData.fromJson(Map<String, dynamic> json, Set<Kiez> kieze) {
    print(json['actions']);
    type = json['type'] as String;
    actions = (json['actions'] as List)
        .map((json) => Termin.fromJson(json, kieze))
        .toList();
  ***REMOVED***

  @override
  toJson() => {
    'type': type,
    'actions': actions.map((action) => action.toJson()).toList()
  ***REMOVED***
***REMOVED***
