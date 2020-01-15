import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/LocationPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';

class ActionData {
  TimeOfDay von;
  TimeOfDay bis;
  Ort ort;
  String typ;
  List<DateTime> tage = List<DateTime>();
  TerminDetails terminDetails = TerminDetails('', '', '');
***REMOVED***

class ActionEditor extends StatefulWidget {
  void Function() onApply;

  ActionEditor(void Function() this.onApply, {Key key***REMOVED***) : super(key: key);

  @override
  _ActionEditor createState() => _ActionEditor();
***REMOVED***

class _ActionEditor extends State<ActionEditor> {
  ActionData action = ActionData();

  @override
  Widget build(BuildContext context) {
    return Column(
        //    crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Das Volksbegehren lebt von deiner Beteiligung! \n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. '
            'Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.',
            textScaleFactor: 1.0,
          ),
          SizedBox(height: 15),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.my_location, size: 40.0),
            SizedBox(
              width: 10.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Wo? ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InputButton(
                  onTap: locationSelection,
                  child: locationButtonCaption(this.action)),
              InputButton(
                  onTap: venueSelection,
                  child: venueButtonCaption(this.action)),
            ])
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.access_time, size: 40.0),
            SizedBox(
              width: 10.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Wann?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InputButton(onTap: daysSelection, child: daysButtonCaption()),
              InputButton(
                  onTap: timeSelection, child: timButtonCaption(this.action)),
            ])
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline, size: 40.0),
            SizedBox(
              width: 10.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Was?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InputButton(onTap: typeSelection, child: typeButtonCaption()),
              InputButton(
                  onTap: descriptionSelection,
                  child: descriptionButtonCaption(this.action)),
            ])
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.face, size: 40.0),
            SizedBox(
              width: 10.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Wer?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InputButton(
                  onTap: contactSelection,
                  child: contactButtonCaption(this.action)),
            ])
          ]),
          ButtonBar(alignment: MainAxisAlignment.spaceAround, children: [
            RaisedButton(
                child: Text('Abbrechen'),
                onPressed: () {
                  onApply(false);
                  Navigator.pop(context, null);
                ***REMOVED***),
            RaisedButton(
                child: Text('Fertig'),
                onPressed: () {
                  List<Future<Termin>> list = pushTermineToDB(onApply(true));
                  Navigator.pop(context, list);
                ***REMOVED***)
          ])
        ]);
  ***REMOVED***

  List<Future<Termin>> pushTermineToDB(List<Termin> termine) {
    print(termine);
    if (termine != null) {
      List<Future<Termin>> new_meetings = List<Future<Termin>>();
      AbstractTermineService termineService =
          Provider.of<AbstractTermineService>(context);
      for (final termin in termine) {
        new_meetings.add(termineService.createTermin(termin));
      ***REMOVED***
      return new_meetings;
    ***REMOVED***
    return null;
  ***REMOVED***

  void venueSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.treffpunkt,
        'Treffpunkt',
        'Gib einen leicht zu findenden Treffpunkt an, z.B. '
            '"Unter der Weltzeituhr", "Schillerstraße 12" oder '
            '"Eingang Kienitzstraße am Tempelhofer Feld" ');
    setState(() {
      this.action.terminDetails.treffpunkt = ergebnis;
    ***REMOVED***);
  ***REMOVED***

  void contactSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.kontakt,
        'Kontakt',
        'Hier kannst du ein paar Worte über dich verlieren, '
            'vor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. '
            'Beachte dass alle Sammler*innen deine Angaben lesen können.');
    setState(() {
      this.action.terminDetails.kontakt = ergebnis;
    ***REMOVED***);
  ***REMOVED***

  Future<String> showTextInputDialog(
      String current_value, String title, String description) {
    // List list = createTextInputAlertDialogWidget(current_value, description);
    // Widget input_widget = list[1];
    String current_input = current_value;
    TextFormField input_field = TextFormField(
      minLines: 3,
      initialValue: current_value,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      onSaved: (current_input_) {
        current_input = current_input_;
        print(current_input);
      ***REMOVED***,
      onFieldSubmitted: (current_input_) {
        current_input = current_input_;
        print(current_input);
      ***REMOVED***,
      onChanged: (current_input_) {
        current_input = current_input_;
        print(current_input);
      ***REMOVED***,
    );

    Widget input_widget = null;

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

  typeSelection() async {
    List<String> moeglicheTypen = ['Sammeln', 'Infoveranstaltung'];
    var ausgewTyp = '';
    await showDialog<String>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.all(15.0),
                  title: const Text('Wähle Aktions-Arten'),
                  children: <Widget>[
                    ...moeglicheTypen.map((typ) => RadioListTile(
                          groupValue: ausgewTyp,
                          value: typ,
                          title: Text(typ),
                          onChanged: (neuerWert) {
                            setDialogState(() {
                              ausgewTyp = neuerWert;
                            ***REMOVED***);
                          ***REMOVED***,
                        )),
                    RaisedButton(
                        child: Text('Fertig'),
                        onPressed: () => Navigator.pop(context))
                  ]);
            ***REMOVED***));

    setState(() {
      this.action.typ = ausgewTyp;
    ***REMOVED***);
  ***REMOVED***

  daysSelection() async {
    var selectedDates = await showMultipleDatePicker(this.action.tage, context,
        key: Key('days selection dialog'));
    setState(() {
      if (selectedDates != null)
        this.action.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
    ***REMOVED***);
  ***REMOVED***

  timeSelection() async {
    TimeRange timeRange =
        await showTimeRangePicker(context, this.action.von, this.action.bis);
    setState(() {
      this.action.von = timeRange.from;
      this.action.bis = timeRange.to;
    ***REMOVED***);
  ***REMOVED***

  locationSelection() async {
    var allLocations =
        await Provider.of<AbstractStammdatenService>(context).ladeOrte();
    var selectedLocations =
        await LocationPicker(locations: allLocations, multiMode: false)
            .showLocationPicker(context, List<Ort>());

    setState(() {
      if (!selectedLocations.isEmpty) {
        this.action.ort = selectedLocations[0];
      ***REMOVED***
    ***REMOVED***);
  ***REMOVED***

  void descriptionSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.kommentar,
        'Beschreibung',
        'Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw');
    setState(() {
      this.action.terminDetails.kommentar = ergebnis;
    ***REMOVED***);
  ***REMOVED***

  Text daysButtonCaption() {
    if (this.action.tage == null || this.action.tage.isEmpty) {
      return Text("Wähle einen Tag", style: TextStyle(color: DweTheme.purple));
    ***REMOVED*** else {
      return Text("am " +
          this
              .action
              .tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",");
    ***REMOVED***
  ***REMOVED***

  Widget venueButtonCaption(ActionData termin) {
    return (termin.terminDetails.treffpunkt == null ||
            termin.terminDetails.treffpunkt == '')
        ? Text(
            'Gib einen Treffpunkt an',
            style: TextStyle(color: DweTheme.purple),
          )
        : Text('Treffpunkt: ${termin.terminDetails.treffpunkt***REMOVED***');
  ***REMOVED***

  Text contactButtonCaption(ActionData termin) {
    return (termin.terminDetails.kontakt == null ||
            termin.terminDetails.kontakt == '')
        ? Text('Ein paar Worte über dich',
            style: TextStyle(color: DweTheme.purple))
        : Text(termin.terminDetails.kontakt);
  ***REMOVED***

  Text descriptionButtonCaption(ActionData termin) {
    return (termin.terminDetails.kommentar == null ||
            termin.terminDetails.kommentar == '')
        ? Text('Beschreibe die Aktion kurz',
            style: TextStyle(color: DweTheme.purple))
        : Text('Beschreibung: ${termin.terminDetails.kommentar***REMOVED***');
  ***REMOVED***

  Text typeButtonCaption() {
    return this.action.typ != null && this.action.typ != ''
        ? Text(this.action.typ)
        : Text("Wähle die Art der Aktion",
            style: TextStyle(color: DweTheme.purple));
  ***REMOVED***

  Text timButtonCaption(ActionData termin) {
    String beschriftung = '';
    if (termin.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(termin.von);
    if (termin.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(termin.bis);
    if (beschriftung.isEmpty)
      return Text('Wähle eine Uhrzeit',
          style: TextStyle(color: DweTheme.purple));
    beschriftung += ',';
    return Text(beschriftung);
  ***REMOVED***

  Text locationButtonCaption(ActionData termin) {
    if (termin.ort == null)
      return Text("Wähle einen Ort", style: TextStyle(color: DweTheme.purple));
    return Text(
      "in " + termin.ort.ort,
    );
  ***REMOVED***

  List<Termin> onApply(bool use_data) {
    if (use_data) {
      if (this.action.von != null &&
          this.action.bis != null &&
          this.action.tage != null &&
          !this.action.tage.isEmpty &&
          this.action.ort != null &&
          this.action.typ != null &&
          this.action.typ != '') {
        List<Termin> termine = new List<Termin>();
        for (final tag in this.action.tage) {
          DateTime begin = new DateTime(tag.year, tag.month, tag.day,
              this.action.von.hour, this.action.von.minute);
          DateTime end = new DateTime(tag.year, tag.month, tag.day,
              this.action.bis.hour, this.action.bis.minute);

          termine.add(Termin(0, begin, end, this.action.ort, this.action.typ,
              this.action.terminDetails));
        ***REMOVED***
        return termine;
      ***REMOVED***
    ***REMOVED*** else {
      return null;
    ***REMOVED***
  ***REMOVED***
***REMOVED***

class InputButton extends StatelessWidget {
  Function onTap;
  Widget child;

  InputButton({this.onTap, this.child***REMOVED***);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            padding: EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Icon(
                Icons.keyboard_arrow_right,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(width: 200.0 ,child: child),

            ])),
        onTap: onTap);
  ***REMOVED***
***REMOVED***
