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
  int unterschriften = 0;
  int teilnehmende = 0;
  double stunden = 0.0;
  String kommentar = '';
  String erkenntnisse = '';

  EvaluationData();
  var validated = {
    'unterschriften': ValidationState.not_validated,
    'teilnehmende': ValidationState.not_validated,
    'stunden': ValidationState.not_validated,
    'kommentar': ValidationState.ok,
    'erkenntnisse': ValidationState.ok,
    'finish_pressed': false
  ***REMOVED***
***REMOVED***

// ignore: must_be_immutable
class EvaluationEditor extends StatefulWidget {
  Function onFinish;
  int terminId;

  EvaluationEditor({this.onFinish, Key key, this.terminId***REMOVED***) : super(key: key) {
    if (onFinish == null) onFinish = (Evaluation _) {***REMOVED*** // TODO unclear if this is necessary or what it does, presumably it passes a default function that does nothing
  ***REMOVED***

  @override
  EvaluationEditorState createState() => EvaluationEditorState(this.terminId);
***REMOVED***

class EvaluationEditorState extends State<EvaluationEditor> {
  int terminId;
  EvaluationData evaluation = EvaluationData();

  EvaluationEditorState(this.terminId) : super();

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
                          'Ergebnis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InputButton(
                            onTap: unterschriftenSelection,
                            child: unterschriftenButtonCaption(this.evaluation)),
                      ]))
                ]),
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
                              'Teilnehmer:innen',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InputButton(
                                onTap: teilnehmendeSelection,
                                child: teilnehmendeButtonCaption(this.evaluation)),
                          ]))
                ]),
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
                              'Dauer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InputButton(
                                onTap: stundenSelection,
                                child: stundenButtonCaption(this.evaluation)),
                          ]))
                ]),
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
                              'Anmerkung',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InputButton(
                                onTap: kommentarSelection,
                                child: kommentarButtonCaption(this.evaluation)),
                          ]))
                ]),
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
                              'Erkenntnisse',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InputButton(
                                onTap: erkenntnisseSelection,
                                child: erkenntnisseButtonCaption(this.evaluation)),
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
      'Erzähl uns, was ihr erreicht habt! \n',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    Text(
      'Deine Evaluierung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.',
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

  Future<String> showNumberInputDialog(
      String current_value, String title, String description, Key key) {
    String current_input = current_value;
    TextFormField input_field = TextFormField(
      initialValue: current_value ?? '',
      keyboardType: TextInputType.number,
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

  void unterschriftenSelection() async {
    var ergebnis = await showNumberInputDialog( // should be number input
        this.evaluation.unterschriften.toString(),
        'Anzahl Unterschriften',
        'Wie viele Unterschriften habt ihr gesammelt?',
        Key('unterschriften input dialog'));
    setState(() {
      this.evaluation.unterschriften = int.tryParse(ergebnis) ?? this.evaluation.unterschriften;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Widget unterschriftenButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['unterschriften'] == ValidationState.ok) {
      text = Text('${evaluation.unterschriften***REMOVED*** Unterschriften');
    ***REMOVED*** else {
      text = Text('Wie viel habt ihr gesammelt?',
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.evaluation.validated['unterschriften']);
  ***REMOVED***

  void teilnehmendeSelection() async {
    var ergebnis = await showNumberInputDialog( // should be number input
        this.evaluation.teilnehmende.toString(),
        'Anzahl Teilnehmende',
        'Wie viele Leute haben mitgemacht?',
        Key('teilnehmende input dialog'));
    setState(() {
      this.evaluation.teilnehmende = int.tryParse(ergebnis) ?? this.evaluation.unterschriften;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Widget teilnehmendeButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['unterschriften'] == ValidationState.ok) {
      text = Text('${evaluation.teilnehmende***REMOVED*** Teilnehmer:innen');
    ***REMOVED*** else {
      text = Text('Wie viele haben mitgemacht?',
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.evaluation.validated['teilnehmende']);
  ***REMOVED***

  void stundenSelection() async {
    var ergebnis = await showNumberInputDialog( // should be number input
        this.evaluation.stunden.toString(),
        'Wie viele Stunden wart ihr sammeln?',
        'Auf die nächste halbe Stunde gerundet',
        Key('stunden input dialog'));
    setState(() {
      this.evaluation.stunden = double.tryParse(ergebnis) ?? this.evaluation.stunden;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Widget stundenButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['stunden'] == ValidationState.ok) {
      text = Text('${evaluation.stunden***REMOVED*** Stunden');
    ***REMOVED*** else {
      text = Text('Wie viele Stunden habt ihr gesammelt?',
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.evaluation.validated['stunden']);
  ***REMOVED***

  void kommentarSelection() async {
    var ergebnis = await showTextInputDialog( // should be number input
        this.evaluation.kommentar,
        'Kommentar',
        'Optional: Anmerkung zu den Daten?',
        Key('kommentar input dialog'));
    setState(() {
      this.evaluation.kommentar = ergebnis;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Widget kommentarButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['kommentar'] == ValidationState.ok) {
      text = Text('Anmerkung: ${evaluation.kommentar***REMOVED***');
    ***REMOVED*** else {
      text = Text('Optional: Muss man noch etwas zu den obigen Daten wissen?',
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.evaluation.validated['kommentar']);
  ***REMOVED***

  void erkenntnisseSelection() async {
    var ergebnis = await showTextInputDialog( // should be number input
        this.evaluation.erkenntnisse.toString(),
        'erkenntnisse',
        'Was habt ihr gelernt? Was hat gut, was hat nicht so gut funktioniert? Was würdet ihr gerne mit anderen Sammel-Teams teilen?',
        Key('erkenntnisse input dialog'));
    setState(() {
      this.evaluation.erkenntnisse = ergebnis;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Widget erkenntnisseButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['erkenntnisse'] == ValidationState.ok) {
      text = Text('Erkenntnisse: ${evaluation.erkenntnisse***REMOVED***');
    ***REMOVED*** else {
      text = Text('Optional: Was habt ihr gelernt?',
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.evaluation.validated['erkenntnisse']);
  ***REMOVED***

  void validateAllInput() {
    validateInt(evaluation.unterschriften, 'unterschriften');
    validateInt(evaluation.teilnehmende, 'teilnehmende');
    validateDouble(evaluation.stunden, 'stunden');

    evaluation.validated['all'] = ValidationState.ok;
    for (var value in evaluation.validated.values) {
      if (value == ValidationState.error ||
          value == ValidationState.not_validated) {
        evaluation.validated['all'] = ValidationState.error;
        break;
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  void validateDouble(field, name) {
    this.evaluation.validated[name] =
        (field != null && field is double && field > 0)
            ? ValidationState.ok
            : ValidationState.error;
  ***REMOVED***

  void validateInt(field, name) {
    this.evaluation.validated[name] =
    (field != null && field is int && field > 0)
        ? ValidationState.ok
        : ValidationState.error;
  ***REMOVED***

  finishPressed() async {
    setState(() {
      evaluation.validated['finish_pressed'] = true;
      validateAllInput();
    ***REMOVED***);
    if (evaluation.validated['all'] == ValidationState.ok) {
      // TODO re-enable this
      /*
      var name =
          (await Provider.of<AbstractUserService>(context).user.first).name;
      if (isBlank(name)) {
        var name = await showUsernameDialog(context: context);
        if (name == null) return;
      ***REMOVED***
      */
      validateAllInput();
      // TODO delete the or true here
      if (evaluation.validated['all'] == ValidationState.ok || true) {
        widget.onFinish(Evaluation(this.terminId, evaluation.unterschriften, evaluation.teilnehmende, evaluation.stunden, evaluation.kommentar, evaluation.erkenntnisse)); // maybe the Evaluation/EvaluationData two-tap is superfluous here
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
