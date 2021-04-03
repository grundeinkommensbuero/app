import 'package:sammel_app/model/PushMessage.dart';

import 'Kiez.dart';
import 'Termin.dart';

class ActionListPushData implements PushData {
  @override
  String type = "ActionList";

  List<Termin> actions = List.empty();

  ActionListPushData.fromJson(Map<String, dynamic> json, Set<Kiez> kieze) {
    type = json['type'] as String;
    actions = (json['actions'] as List)
        .map((json) => Termin.fromJson(json, kieze))
        .toList();
  }

  @override
  toJson() => {
    'type': type,
    'actions': actions.map((action) => action.toJson()).toList()
  };
}
