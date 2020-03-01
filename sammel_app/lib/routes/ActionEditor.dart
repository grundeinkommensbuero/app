import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/LocationPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';

enum ValidationState { not_validated, error, ok ***REMOVED***

class ActionData {
  TimeOfDay von = TimeOfDay.fromDateTime(DateTime.now());
  TimeOfDay bis =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  Ort ort =
      Ort(0, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez', null, null);
  String typ = 'Sammeln';
  List<DateTime> tage = [DateTime.now()];
  TerminDetails terminDetails =
      TerminDetails('Weltzeituhr', 'Es gibt Kuchen', 'Ich bin ich');

  ActionData.testDaten();

  ActionData(
      [this.von, this.bis, this.ort, this.typ, this.tage, this.terminDetails]) {
    if (this.tage == null) this.tage = [];
    if (this.terminDetails == null)
      this.terminDetails = TerminDetails('', '', '');
  ***REMOVED***

  var _validated = {
    'von': ValidationState.not_validated,
    'bis': ValidationState.not_validated,
    'ort': ValidationState.not_validated,
    'typ': ValidationState.not_validated,
    'tage': ValidationState.not_validated,
    'terminDetails': ValidationState.not_validated,
    'all': ValidationState.not_validated,
    'treffpunkt': ValidationState.not_validated,
    'kontakt': ValidationState.not_validated,
    'kommentar': ValidationState.not_validated,
    'fertig_pressed': false
  ***REMOVED***
***REMOVED***

class ActionEditor extends StatefulWidget {
  Termin initAction = null;

  ActionEditor(Termin initAction, {Key key***REMOVED***) : super(key: key) {
    this.initAction = initAction;
  ***REMOVED***

  @override
  ActionEditorState createState() => ActionEditorState(this.initAction);
***REMOVED***

class ActionEditorState extends State<ActionEditor> {
  ActionData action = ActionData.testDaten();

  ActionEditorState(Termin initAction) : super() {
    assign_initial_termin(initAction);
    validateInput();
  ***REMOVED***

  void assign_initial_termin(Termin initAction) {
    if (initAction != null) {
      action.ort = initAction.ort;
      action.typ = initAction.typ;
      if (initAction.details != null) action.terminDetails = initAction.details;
      if (initAction.beginn != null) {
        action.von = TimeOfDay.fromDateTime(initAction.beginn);
        action.tage.add(initAction.beginn);
      ***REMOVED***
      if (initAction.ende != null)
        action.bis = TimeOfDay.fromDateTime(initAction.ende);
      if (initAction.details != null) {
        action.terminDetails = initAction.details;
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
              child: locationButtonCaption(this.action),
              key: Key('Open location dialog')),
          InputButton(
              onTap: venueSelection, child: venueButtonCaption(this.action)),
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
              onTap: timeSelection,
              child: timeButtonCaption(this.action),
              key: Key('open time span dialog')),
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
          InputButton(
            onTap: typeSelection,
            child: typeButtonCaption(),
            key: Key('open type selection dialog'),
          ),
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
            key: Key('action editor cancel button'),
            child: Text('Abbrechen'),
            onPressed: () => Navigator.pop(context, null)),
        RaisedButton(
            key: Key('action editor finish button'),
            child: Text('Fertig'),
            onPressed: () => fertigPressed())
      ])
    ]);
  ***REMOVED***

  void venueSelection() async {
    Marker marker;
    String current_input = this.action.terminDetails.treffpunkt;

    var ergebnis = await showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
                key: Key('treffpunkt input dialog'),
                title: Text('Treffpunkt'),
                content: SingleChildScrollView(
                    child: ListBody(children: [
                  SizedBox(
                      height: 300.0,
                      width: 300.0,
                      child: FlutterMap(
                          options: MapOptions(
                              center: LatLng(52.5170365, 13.3888599),
                              zoom: 10.0,
                              maxZoom: 19.0,
                              onTap: (LatLng point) => setDialogState(() =>
                                  marker = Marker(
                                      point: point,
                                      builder: (context) => Icon(
                                          Icons.supervised_user_circle,
                                          size: 30.0)))),
                          layers: [
                            TileLayerOptions(
                                urlTemplate:
                                    "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
                                subdomains: ['a', 'b', 'c']),
                            MarkerLayerOptions(
                                markers: marker == null ? [] : [marker])
                          ])),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Du kannst auch eine eigene Beschreibung angeben, '
                    'z.B. "Unter der Weltzeituhr" oder "Tempelhofer Feld, '
                    'Eingang Kienitzstraße":',
                    textScaleFactor: 0.9,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    initialValue: this.action.terminDetails.treffpunkt,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (current_input_) {
                      current_input = current_input_;
                    ***REMOVED***,
                  ),
                ])),
                actions: [
                  FlatButton(
                    child: Text("Abbrechen"),
                    onPressed: () {
                      Navigator.pop(
                          context, this.action.terminDetails.treffpunkt);
                    ***REMOVED***,
                  ),
                  FlatButton(
                    child: Text("Fertig"),
                    onPressed: () {
                      Navigator.pop(context, current_input);
                    ***REMOVED***,
                  ),
                ],
              )),
    );
    setState(() {
      this.action.terminDetails.treffpunkt = ergebnis;
      validateInput();
    ***REMOVED***);
  ***REMOVED***

  void contactSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.kontakt,
        'Kontakt',
        'Hier kannst du ein paar Worte über dich verlieren, '
            'vor allem, wie man dich kontaktieren kann, damit andere sich mit dir zum Sammeln verabreden können. '
            'Beachte dass alle Sammler*innen deine Angaben lesen können.',
        Key('contact input dialog'));
    setState(() {
      this.action.terminDetails.kontakt = ergebnis;
      validateInput();
    ***REMOVED***);
  ***REMOVED***

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

  typeSelection() async {
    List<String> moeglicheTypen = ['Sammeln', 'Infoveranstaltung'];
    var ausgewTyp = '';
    await showDialog<String>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  key: Key('type selection dialog'),
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
      validateInput();
    ***REMOVED***);
  ***REMOVED***

  daysSelection() async {
    var selectedDates = await showMultipleDatePicker(this.action.tage, context,
        key: Key('days selection dialog'),
        multiMode: /*widget.initAction == null ? true : false*/ true);
    setState(() {
      if (selectedDates != null)
        this.action.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
      validateInput();
    ***REMOVED***);
  ***REMOVED***

  timeSelection() async {
    TimeRange timeRange =
        await showTimeRangePicker(context, this.action.von, this.action.bis);
    setState(() {
      this.action.von = timeRange.from;
      this.action.bis = timeRange.to;
      validateInput();
    ***REMOVED***);
  ***REMOVED***

  locationSelection() async {
    var allLocations =
        await Provider.of<AbstractStammdatenService>(context).ladeOrte();
    var selectedLocations = await LocationPicker(
            key: Key('Location Picker'),
            locations: allLocations,
            multiMode: false)
        .showLocationPicker(context, List<Ort>());

    setState(() {
      if (!selectedLocations.isEmpty) {
        this.action.ort = selectedLocations[0];
        validateInput();
      ***REMOVED***
    ***REMOVED***);
  ***REMOVED***

  void descriptionSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.kommentar,
        'Beschreibung',
        'Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw',
        Key('description input dialog'));
    setState(() {
      this.action.terminDetails.kommentar = ergebnis;
      validateInput();
    ***REMOVED***);
  ***REMOVED***

  Widget daysButtonCaption() {
    Text text = null;
    if (this.action._validated['tage'] == ValidationState.error ||
        this.action._validated['tage'] == ValidationState.not_validated) {
      text = Text("Wähle einen Tag", style: TextStyle(color: DweTheme.purple));
    ***REMOVED*** else {
      text = Text("am " +
          this
              .action
              .tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",");
    ***REMOVED***
    return build_text_row(text, this.action._validated['tage']);
  ***REMOVED***

  Widget venueButtonCaption(ActionData termin) {
    Text text = null;
    if (this.action._validated['treffpunkt'] == ValidationState.error ||
        this.action._validated['treffpunkt'] == ValidationState.not_validated) {
      text = Text(
        'Gib einen Treffpunkt an',
        style: TextStyle(color: DweTheme.purple),
      );
    ***REMOVED*** else {
      text = Text('Treffpunkt: ${termin.terminDetails.treffpunkt***REMOVED***');
    ***REMOVED***
    return build_text_row(text, this.action._validated['treffpunkt']);
  ***REMOVED***

  Widget contactButtonCaption(ActionData termin) {
    Text text = null;
    ValidationState val = null;
    if (this.action._validated['kontakt'] == ValidationState.ok &&
        this.action._validated['terminDetails'] == ValidationState.ok) {
      text = Text(termin.terminDetails.kontakt);
      val = ValidationState.ok;
    ***REMOVED*** else {
      text = Text('Ein paar Worte über dich',
          style: TextStyle(color: DweTheme.purple));
      val = ValidationState.error;
    ***REMOVED***
    return build_text_row(text, val);
    /*
    return (termin.terminDetails.kontakt == null ||
            termin.terminDetails.kontakt == '')
        ? Text('Ein paar Worte über dich',
            style: TextStyle(color: DweTheme.purple))
        : ;*/
  ***REMOVED***

  Widget descriptionButtonCaption(ActionData termin) {
    Text text = null;
    if (this.action._validated['kommentar'] == ValidationState.ok) {
      text = Text('Beschreibung: ${termin.terminDetails.kommentar***REMOVED***');
    ***REMOVED*** else {
      text = Text('Beschreibe die Aktion kurz',
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.action._validated['kommentar']);
  ***REMOVED***

  Widget typeButtonCaption() {
    Text text = null;
    if (this.action._validated['typ'] == ValidationState.ok) {
      text = Text(this.action.typ);
    ***REMOVED*** else {
      text = Text("Wähle die Art der Aktion",
          style: TextStyle(color: DweTheme.purple));
    ***REMOVED***
    return build_text_row(text, this.action._validated['typ']);
  ***REMOVED***

  Row timeButtonCaption(ActionData termin) {
    String beschriftung = '';
    ValidationState val = null;
    if (termin.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(termin.von);
    if (termin.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(termin.bis);
    Text text = null;
    if (beschriftung.isEmpty) {
      val = ValidationState.error;
      text =
          Text('Wähle eine Uhrzeit', style: TextStyle(color: DweTheme.purple));
    ***REMOVED*** else {
      val = ValidationState.ok;
      text = Text(beschriftung);
    ***REMOVED***
    //beschriftung += ',';

    return build_text_row(text, val);
  ***REMOVED***

  Widget locationButtonCaption(ActionData termin) {
    Text text = null;
    if (termin._validated['ort'] == ValidationState.not_validated ||
        termin._validated['ort'] == ValidationState.error)
      text = Text("Wähle einen Ort", style: TextStyle(color: DweTheme.purple));
    else {
      text = Text("in " + termin.ort.ort);
    ***REMOVED***
    return build_text_row(text, termin._validated['ort']);
  ***REMOVED***

  void validateAgainstNull(field, name) {
    if (field != null) {
      this.action._validated[name] = ValidationState.ok;
    ***REMOVED*** else {
      this.action._validated[name] = ValidationState.error;
    ***REMOVED***
  ***REMOVED***

  void validateInput() {
    validateAgainstNull(this.action.von, 'von');
    validateAgainstNull(this.action.bis, 'bis');
    validateAgainstNull(this.action.tage, 'tage');
    validateAgainstNull(this.action.typ, 'typ');

    if (this.action._validated['typ'] == ValidationState.ok) {
      this.action._validated['typ'] =
          this.action.typ == '' ? ValidationState.error : ValidationState.ok;
    ***REMOVED***

    if (this.action.tage?.isEmpty ?? true) {
      this.action._validated['tage'] = ValidationState.error;
    ***REMOVED***
    validateAgainstNull(this.action.ort, 'ort');
    validateTerminDetails();
    ValidationState all = ValidationState.ok;
    action._validated['all'] = ValidationState.ok;
    for (var value in this.action._validated.values) {
      if (value == ValidationState.error ||
          value == ValidationState.not_validated) {
        all = ValidationState.error;
        break;
      ***REMOVED***
    ***REMOVED***
    action._validated['all'] = all;
  ***REMOVED***

  List<Termin> generateActions() {
    validateInput();
    if (action._validated['all'] == ValidationState.ok) {
      List<Termin> termine = new List<Termin>();
      for (final tag in this.action.tage) {
        DateTime begin = new DateTime(tag.year, tag.month, tag.day,
            this.action.von.hour, this.action.von.minute);
        DateTime end = new DateTime(tag.year, tag.month, tag.day,
            this.action.bis.hour, this.action.bis.minute);
        if (ChronoHelfer.isTimeOfDayBefore(this.action.bis, this.action.von)) {
          end = end.add(Duration(days: 1));
        ***REMOVED***
        termine.add(Termin(widget.initAction?.id, begin, end, this.action.ort,
            this.action.typ, null, null, this.action.terminDetails));
      ***REMOVED***
      return termine;
    ***REMOVED***
    /*
    // TODO Popup bei Invalidem Inhalt
    if (this.action.von != null &&
        this.action.bis != null &&
        this.action.tage != null &&
        !this.action.tage.isEmpty &&
        this.action.ort != null &&
        this.action.typ != null &&
        this.action.typ != '') {

    ***REMOVED****/
    else {
      return null;
    ***REMOVED***
  ***REMOVED***

  fertigPressed() {
    setState(() {
      action._validated['fertig_pressed'] = true;
      validateInput();
    ***REMOVED***);
    if (action._validated['all'] == ValidationState.ok) {
      List<Termin> termine = generateActions();
      if (termine != null) {
        Navigator.pop(context, generateActions());
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  void validateTerminDetails() {
    if (this.action.terminDetails == null) {
      this.action._validated['terminDetails'] = ValidationState.error;
    ***REMOVED*** else {
      this.action._validated['terminDetails'] = ValidationState.ok;

      if (this.action.terminDetails.treffpunkt == null) {
        this.action._validated['treffpunkt'] = ValidationState.error;
      ***REMOVED*** else {
        this.action._validated['treffpunkt'] =
            this.action.terminDetails.treffpunkt == ''
                ? ValidationState.error
                : ValidationState.ok;
      ***REMOVED***
      if (this.action.terminDetails.kommentar == null) {
        this.action._validated['kommentar'] = ValidationState.error;
      ***REMOVED*** else {
        this.action._validated['kommentar'] =
            this.action.terminDetails.kommentar == ''
                ? ValidationState.error
                : ValidationState.ok;
      ***REMOVED***
      if (this.action.terminDetails.kontakt == null) {
        this.action._validated['kontakt'] = ValidationState.error;
      ***REMOVED*** else {
        this.action._validated['kontakt'] =
            this.action.terminDetails.kontakt == ''
                ? ValidationState.error
                : ValidationState.ok;
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  Row build_text_row(Text text, ValidationState val) {
    List<Widget> w = [Flexible( child: text)];
    if (action._validated['fertig_pressed']) {
      if (val == ValidationState.ok) {
        w.add(Icon(Icons.done, color: Colors.black));
      ***REMOVED***
      else {
        w.add(Icon(Icons.error_outline));
      ***REMOVED***
    ***REMOVED***
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: w);
  ***REMOVED***
***REMOVED***

class InputButton extends StatelessWidget {
  Function onTap;
  Widget child;
  Key key;
  InputButton({this.onTap, this.child, this.key***REMOVED***) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            padding: EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                Icons.keyboard_arrow_right,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(width: 200.0, child: child),
            ])),
        onTap: onTap);
  ***REMOVED***
***REMOVED***
