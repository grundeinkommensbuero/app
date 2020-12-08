import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/Evaluation.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/LocationPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';

import 'VenueDialog.dart';

enum ValidationState { not_validated, error, ok ***REMOVED***

class EvaluationData {
  //  TODO
  // expand
  int signatures;

  EvaluationData();
  var validated = {
    'unterschriften': ValidationState.not_validated,
    'finish_pressed': false
  ***REMOVED***
***REMOVED***

// ignore: must_be_immutable
class EvaluationEditor extends StatefulWidget {
  Function onFinish;

  EvaluationEditor({this.onFinish, Key key***REMOVED***) : super(key: key) {
    if (onFinish == null) onFinish = (Evaluation _) {***REMOVED*** // TODO unclear if this is necessary or what it does
  ***REMOVED***

  @override
  EvaluationEditorState createState() => EvaluationEditorState();
***REMOVED***

class EvaluationEditorState extends State<EvaluationEditor> {
  EvaluationData evaluation = EvaluationData();

  EvaluationEditorState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(color: DweTheme.yellowLight),
          child: ListView(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 15.0, bottom: 50.0),
              children: <Widget>[
                motivationText,
                SizedBox(height: 15),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Wie viele Unterschriften?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InputButton(
                            onTap: signaturesSelection,
                            child: signaturesButtonCaption(this.evaluation)),
                      ]))
                ]),
              ]),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 5.0, color: Colors.black38)],
              color: DweTheme.yellow),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            RaisedButton(
                key: Key('evaluation editor cancel button'),
                child: Text('Abbrechen'),
                onPressed: () {
                  setState(() => evaluation = EvaluationData());
                  Navigator.maybePop(context);
                ***REMOVED***),
            RaisedButton(
                key: Key('evaluation editor finish button'),
                child: Text('Fertig'),
                onPressed: () => finishPressed())
          ]),
        ));
  ***REMOVED***

  static Widget motivationText = Column(key: Key('motivation text'), children: [
    Text(
      'Das Volksbegehren lebt von deiner Beteiligung! \n',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    Text(
      'Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. '
      'Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.',
      textScaleFactor: 1.0,
    )
  ]);

  Future<String> showTextInputDialog(
      String current_value, String title, String description, Key key) {
    String current_input = current_value;
    TextFormField input_field = TextFormField(
      minLines: 3,
      initialValue: current_value,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      onChanged: (current_input_) {
        current_input = current_input_;
      ***REMOVED***,
    );

    Widget input_widget;

    if (description != null) {
      input_widget = SingleChildScrollView(
          child: ListBody(children: [
        Text(description),
        SizedBox(height: 10),
        input_field
      ]));
    ***REMOVED*** else {
      input_widget = input_field;
    ***REMOVED***

    Widget cancelButton = FlatButton(
      child: Text("Abbrechen"),
      onPressed: () {
        Navigator.pop(context, current_value);
      ***REMOVED***,
    );
    Widget continueButton = FlatButton(
      child: Text("Fertig"),
      onPressed: () {
        Navigator.pop(context, current_input);
      ***REMOVED***,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      key: key,
      title: Text(title),
      content: input_widget,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      ***REMOVED***,
    );
  ***REMOVED***

  void signaturesSelection() async {
    var ergebnis = await showTextInputDialog( // should be number input
        this.evaluation.signatures.toString(),
        'Anzahl Unterschriften',
        'Wie viele Unterschriften habt ihr gesammelt?',
        Key('signatures input dialog'));
    setState(() {
      this.evaluation.signatures = int.tryParse(ergebnis) ?? 15;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Widget signaturesButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['unterschriften'] == ValidationState.ok) {
      text = Text('Unterschriften: ${evaluation.signatures***REMOVED***');
    ***REMOVED*** else {
      text = Text('Wie viel habt ihr gesammelt?',
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.evaluation.validated['unterschriften']);
  ***REMOVED***

  void validateAllInput() {
    validateAgainstNull(evaluation.signatures, 'unterschriften');

    evaluation.validated['all'] = ValidationState.ok;
    for (var value in evaluation.validated.values) {
      if (value == ValidationState.error ||
          value == ValidationState.not_validated) {
        evaluation.validated['all'] = ValidationState.error;
        break;
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  void validateAgainstNull(field, name) {
    if (field != null) {
      this.evaluation.validated[name] = ValidationState.ok;
    ***REMOVED*** else {
      this.evaluation.validated[name] = ValidationState.error;
    ***REMOVED***
  ***REMOVED***

  finishPressed() async {
    setState(() {
      evaluation.validated['finish_pressed'] = true;
      validateAllInput();
    ***REMOVED***);
    if (evaluation.validated['all'] == ValidationState.ok) {
      var name =
          (await Provider.of<AbstractUserService>(context).user.first).name;
      if (isBlank(name)) {
        var name = await showUsernameDialog(context: context);
        if (name == null) return;
      ***REMOVED***
      validateAllInput();
      if (evaluation.validated['all'] == ValidationState.ok) {
        widget.onFinish(evaluation);
        setState(() => evaluation = EvaluationData()); // reset Form for next use
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  Row build_text_row(Text text, ValidationState valState) {
    List<Widget> w = [Flexible(child: text)];
    if (evaluation.validated['finish_pressed']) {
      if (valState == ValidationState.ok) {
        w.add(Icon(Icons.done, color: Colors.black));
      ***REMOVED*** else {
        w.add(Icon(Icons.error_outline));
      ***REMOVED***
    ***REMOVED***
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: w);
  ***REMOVED***
***REMOVED***

class InputButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final Key key;

  InputButton({this.onTap, this.child, this.key***REMOVED***) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            padding: EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.keyboard_arrow_right, size: 15),
              SizedBox(width: 5),
              Expanded(child: child),
            ])),
        onTap: onTap);
  ***REMOVED***
***REMOVED***
