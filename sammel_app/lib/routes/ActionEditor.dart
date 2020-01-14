import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
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

  var _zeroPadding = MaterialTapTargetSize.shrinkWrap;
  TextStyle default_text_style =
      TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

  get filter => null;

  @override
  Widget build(BuildContext context) {
    return Column(
        //    crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Die Initiative lebt von deiner Beteiligung'),
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
              FlatButton(
                materialTapTargetSize: _zeroPadding,
                onPressed: () => locationSelection(),
                child: locationButtonCaption(this.action),
              ),
              FlatButton(
                  materialTapTargetSize: _zeroPadding,
                  onPressed: () => venueSelection(),
                  child: venueButtonCaption(this.action))
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
              FlatButton(
                materialTapTargetSize: _zeroPadding,
                onPressed: () => daysSelection(),
                child: daysButtonCaption(),
              ),
              FlatButton(
                materialTapTargetSize: _zeroPadding,
                onPressed: () => timeSelection(),
                child: timButtonCaption(this.action),
              )
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
              FlatButton(
                materialTapTargetSize: _zeroPadding,
                onPressed: () => typeSelection(),
                child: typeButtonCaption(),
              ),
              FlatButton(
                  materialTapTargetSize: _zeroPadding,
                  onPressed: () => descriptionSelection(),
                  child: descriptionButtonCaption(this.action))
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
              FlatButton(
                  //          color: Color.fromARGB(255, 149, 48, 118),
                  //       textColor: Color.fromARGB(255, 129, 28, 98),
                  materialTapTargetSize: _zeroPadding,
                  onPressed: () => contactSelection(),
                  child: contactButtonCaption(this.action))
            ])
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            RaisedButton(
                child: Text('Abbrechen'),
                onPressed: () {
                  onApply(false);
                  Navigator.pop(context, null);
                ***REMOVED***),
            RaisedButton(
                child: Text('Erstellen'),
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

  Text daysButtonCaption() {
    if (this.action.tage == null || this.action.tage.isEmpty) {
      return Text("Wähle einen Tag");
    ***REMOVED*** else {
      return Text(
          "am " +
              this
                  .action
                  .tage
                  .map((tag) => DateFormat("dd.MM.").format(tag))
                  .join(", ") +
              ",",
          style: default_text_style);
    ***REMOVED***
  ***REMOVED***

  void venueSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.treffpunkt, 'Treffpunkt', 'Dummy Text');
    setState(() {
      this.action.terminDetails.treffpunkt = ergebnis;
    ***REMOVED***);
  ***REMOVED***

  void contactSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.kontakt, 'Kontakt', 'Dummy Text');
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
    List<String> moeglicheTypen = ['Sammel-Termin', 'Info-Veranstaltung'];
    var ausgewTyp = '';
    await showDialog<String>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.all(15.0),
                  title: const Text('Wähle Termin-Arten'),
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
    var selectedDates = await showMultipleDatePicker(this.filter.tage, context,
        key: Key('days selection dialog'));
    setState(() {
      if (selectedDates != null)
        this.action.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
    ***REMOVED***);
  ***REMOVED***

  timeSelection() async {
    TimeRange timeRange = await showTimeRangePicker(
        context, this.filter.von?.hour, this.filter.bis?.hour);
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
        this.action.terminDetails.kommentar, 'Kommentar', 'Dummy Text');
    setState(() {
      this.action.terminDetails.kommentar = ergebnis;
    ***REMOVED***);
  ***REMOVED***

  Text venueButtonCaption(ActionData termin) {
    return (termin.terminDetails.treffpunkt == null ||
            termin.terminDetails.treffpunkt == '')
        ? Text('Treffpunkt eingeben')
        : Text(termin.terminDetails.treffpunkt, style: default_text_style);
  ***REMOVED***

  Text contactButtonCaption(ActionData termin) {
    return (termin.terminDetails.kontakt == null ||
            termin.terminDetails.kontakt == '')
        ? Text('Kontakt eingeben')
        : Text(termin.terminDetails.kontakt, style: default_text_style);
  ***REMOVED***

  Text descriptionButtonCaption(ActionData termin) {
    return (termin.terminDetails.kommentar == null ||
            termin.terminDetails.kommentar == '')
        ? Text('Beschreibung eingeben')
        : Text(termin.terminDetails.kommentar, style: default_text_style);
  ***REMOVED***

  Text typeButtonCaption() {
    return this.action.typ != null && this.action.typ != ''
        ? Text(this.action.typ, style: default_text_style)
        : Text("Wähle eine Termin-Art");
  ***REMOVED***

  Text timButtonCaption(ActionData termin) {
    String beschriftung = '';
    if (termin.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(termin.von);
    if (termin.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(termin.bis);
    if (beschriftung.isEmpty) return Text('Wähle eine Uhrzeit');
    beschriftung += ',';
    return Text(beschriftung, style: default_text_style);
  ***REMOVED***

  Text locationButtonCaption(ActionData termin) {
    if (termin.ort == null) return Text("Wähle einen Ort");
    return Text(
      "in " + termin.ort.ort,
      style: default_text_style,
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
