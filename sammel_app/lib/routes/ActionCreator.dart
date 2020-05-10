import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/shared/showErrorDialog.dart';
import 'package:uuid/uuid.dart';

class ActionCreator extends StatefulWidget {
  static String NAME = 'Action Creator';
  var onFinish;

  ActionCreator(this.onFinish);

  @override
  State<StatefulWidget> createState() => ActionCreatorState();
}

class ActionCreatorState extends State<ActionCreator> {
  AbstractTermineService termineService;
  StorageService storageService;

  @override
  Widget build(BuildContext context) {
    return ActionEditor(key: Key('action editor creator'), onFinish: widget.onFinish,);
  }
}
