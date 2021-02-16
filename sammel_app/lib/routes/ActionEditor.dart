import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';

import 'LocationDialog.dart';

enum ValidationState { not_validated, error, ok ***REMOVED***

class ActionData {
  TimeOfDay von;
  TimeOfDay bis;
  Kiez ort;
  String typ;
  List<DateTime> tage;
  TerminDetails terminDetails;
  LatLng coordinates;

  ActionData(
      [this.typ,
      this.von,
      this.bis,
      this.ort,
      this.tage,
      this.terminDetails,
      this.coordinates]) {
    this.typ = this.typ ?? 'Sammeln';
    this.tage = this.tage ?? [];
    this.terminDetails = this.terminDetails ?? TerminDetails('', '', '');
  ***REMOVED***

  var validated = {
    'von': ValidationState.not_validated,
    'bis': ValidationState.not_validated,
    'ort': ValidationState.not_validated,
    'typ': ValidationState.ok,
    'tage': ValidationState.not_validated,
    'all': ValidationState.not_validated,
    'venue': ValidationState.not_validated,
    'kontakt': ValidationState.not_validated,
    'beschreibung': ValidationState.not_validated,
    'finish_pressed': false
  ***REMOVED***
***REMOVED***

// ignore: must_be_immutable
class ActionEditor extends StatefulWidget {
  final Termin initAction;
  Function onFinish;

  ActionEditor({this.initAction, this.onFinish, Key key***REMOVED***) : super(key: key) {
    if (onFinish == null) onFinish = (List<Termin> _) {***REMOVED***
  ***REMOVED***

  @override
  ActionEditorState createState() => ActionEditorState(this.initAction);
***REMOVED***

class ActionEditorState extends State<ActionEditor>
    with AfterLayoutMixin<ActionEditor> {
  ActionData action = ActionData();

  ActionEditorState(Termin initAction) : super() {
    if (initAction != null) assign_initial_termin(initAction);
    validateAllInput();
  ***REMOVED***

  void assign_initial_termin(Termin initAction) {
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
    action.coordinates = LatLng(initAction.latitude, initAction.longitude);
  ***REMOVED***

  get isNewAction => widget.initAction == null;

  @override
  void afterFirstLayout(BuildContext context) {
    if (isNewAction)
      Provider.of<StorageService>(context).loadContact().then((stored) {
        setState(() => action.terminDetails.kontakt = stored);
        validateContact();
      ***REMOVED***);
  ***REMOVED***

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
                isNewAction ? motivationText() : Container(),
                SizedBox(height: 15),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.my_location, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Wo?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            key: Key('Open location dialog'),
                            onTap: locationSelection,
                            child: locationButtonCaption(this.action)),
                      ]))
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.access_time, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Wann?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            onTap: daysSelection, child: daysButtonCaption()),
                        InputButton(
                            onTap: timeSelection,
                            child: timeButtonCaption(this.action),
                            key: Key('open time span dialog')),
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
                          'Was?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                          onTap: typeSelection,
                          child: typeButtonCaption(),
                          key: Key('open type selection dialog'),
                        ),
                        InputButton(
                            onTap: descriptionSelection,
                            child: descriptionButtonCaption(this.action)),
                      ]))
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.face, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Wer?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            key: Key('action editor contact button'),
                            onTap: contactSelection,
                            child: contactButtonCaption(this.action)),
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
                key: Key('action editor cancel button'),
                child: Text('Abbrechen').tr(),
                onPressed: () {
                  resetAction();
                  Navigator.maybePop(context);
                ***REMOVED***),
            RaisedButton(
                key: Key('action editor finish button'),
                child: Text('Fertig').tr(),
                onPressed: () => finishPressed())
          ]),
        ));
  ***REMOVED***

  static Widget motivationText() =>
      Column(key: Key('motivation text'), children: [
        Text(
          'Das Volksbegehren lebt von deiner Beteiligung! \n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        Text(
          'Wenn du keine passende Sammel-Aktion findest, dann lade doch andere zum gemeinsamen Sammeln ein. '
          'Andere können deinen Sammel-Aufruf sehen und teilnehmen. Du kannst die Aktion jederzeit bearbeiten oder wieder löschen.',
          textScaleFactor: 1.0,
        ).tr()
      ]);

  void locationSelection() async {
    Location ergebnis = await showLocationDialog(
        context: context,
        initDescription: action.terminDetails.treffpunkt,
        initCoordinates: action.coordinates,
        initKiez: action.ort,
        center: determineMapCenter(action));

    setState(() {
      action.terminDetails.treffpunkt = ergebnis?.description;
      action.coordinates = ergebnis?.coordinates;
      action.ort = ergebnis?.kiez;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  static LatLng determineMapCenter(ActionData action) {
    // at old coordinates
    if (action.coordinates?.latitude != null &&
        action.coordinates?.longitude != null)
      return LatLng(action.coordinates.latitude, action.coordinates.longitude);

    return null;
  ***REMOVED***

  void contactSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.kontakt,
        'Kontakt',
        'Hier kannst du ein paar Worte über dich verlieren. Wer bist du, woran '
            'erkennt man dich vor Ort, wie kann man dich vorher kontaktieren, usw.\n'
            'Beachte dass alle Sammler*innen deine Angaben lesen können!',
        Key('contact input dialog'));
    setState(() {
      this.action.terminDetails.kontakt = ergebnis;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Future<String> showTextInputDialog(
      String current_value, String title, String description, Key key) {
    String current_input = current_value;

    TextFormField input_field = TextFormField(
      key: Key('text input dialog field'),
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

    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        key: key,
        title: Text(title).tr(),
        content: description != null
            ? SingleChildScrollView(
                child: ListBody(children: [
                Text(description).tr(),
                SizedBox(height: 10),
                input_field
              ]))
            : input_field,
        actions: [
          FlatButton(
            child: Text("Abbrechen").tr(),
            onPressed: () {
              Navigator.pop(context, current_value);
            ***REMOVED***,
          ),
          FlatButton(
            key: Key('action editor text input accept button'),
            child: Text("Fertig").tr(),
            onPressed: () => Navigator.pop(context, current_input),
          ),
        ],
      ),
    );
  ***REMOVED***

  typeSelection() async {
    List<String> moeglicheTypen = [
      'Sammeln',
      'Infoveranstaltung',
      'Workshop',
      'Plakatieren',
      'Kundgebung'
    ];
    var ausgewTyp = action.typ;
    await showDialog<String>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  key: Key('type selection dialog'),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.all(15.0),
                  title: const Text('Wähle Aktions-Arten').tr(),
                  children: []
                    ..addAll(moeglicheTypen.map((typ) => RadioListTile(
                          groupValue: ausgewTyp,
                          value: typ,
                          title: Text(typ).tr(),
                          onChanged: (neuerWert) {
                            setDialogState(() {
                              ausgewTyp = neuerWert;
                            ***REMOVED***);
                          ***REMOVED***,
                        )))
                    ..add(RaisedButton(
                        child: Text('Fertig').tr(),
                        onPressed: () => Navigator.pop(context))));
            ***REMOVED***));

    setState(() {
      this.action.typ = ausgewTyp;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  daysSelection() async {
    var selectedDates = await showMultipleDatePicker(
      this.action.tage,
      context,
      key: Key('days selection dialog'),
      multiMode: isNewAction ? true : false,
      maxTage: 5,
    );
    setState(() {
      if (selectedDates != null)
        this.action.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  timeSelection() async {
    TimeRange timeRange =
        await showTimeRangePicker(context, this.action.von, this.action.bis);
    setState(() {
      this.action.von = timeRange.from;
      this.action.bis = timeRange.to;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  void descriptionSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.beschreibung,
        'Beschreibung',
        'Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammler*innen mitbringen? Kann man auch später dazustoßen?',
        Key('description input dialog'));
    setState(() {
      this.action.terminDetails.beschreibung = ergebnis;
      validateAllInput();
    ***REMOVED***);
  ***REMOVED***

  Widget daysButtonCaption() {
    Text text;
    if (this.action.validated['tage'] == ValidationState.error ||
        this.action.validated['tage'] == ValidationState.not_validated) {
      text = Text("Wähle einen Tag", style: TextStyle(color: DweTheme.purple))
          .tr();
    ***REMOVED*** else {
      text = Text('am '.tr() +
          this
              .action
              .tage
              .map((tag) => DateFormat('dd.MM.').format(tag))
              .join(', ') +
          ',');
    ***REMOVED***
    return build_text_row(text, this.action.validated['tage']);
  ***REMOVED***

  Widget locationButtonCaption(ActionData termin) {
    Widget text;
    if (this.action.validated['venue'] == ValidationState.error ||
        this.action.validated['venue'] == ValidationState.not_validated) {
      text = Text(
        'Gib einen Treffpunkt an',
        style: TextStyle(color: DweTheme.purple),
      ).tr();
    ***REMOVED*** else {
      text =
          Text('{kiez***REMOVED*** in {bezirk***REMOVED***\n Treffpunkt: {treffpunkt***REMOVED***').tr(namedArgs: {
        'kiez': termin.ort.name,
        'bezirk': termin.ort.ortsteil,
        'treffpunkt': termin.terminDetails.treffpunkt,
      ***REMOVED***);
    ***REMOVED***
    return build_text_row(text, this.action.validated['venue']);
  ***REMOVED***

  Widget contactButtonCaption(ActionData termin) {
    Text text;
    ValidationState val;
    if (this.action.validated['kontakt'] == ValidationState.ok) {
      text = Text(termin.terminDetails.kontakt);
      val = ValidationState.ok;
    ***REMOVED*** else {
      text = Text('Ein paar Worte über dich',
              style: TextStyle(color: DweTheme.purple))
          .tr();
      val = ValidationState.error;
    ***REMOVED***
    return build_text_row(text, val);
  ***REMOVED***

  Widget descriptionButtonCaption(ActionData termin) {
    Text text;
    if (this.action.validated['beschreibung'] == ValidationState.ok) {
      text = Text('Beschreibung: {beschreibung***REMOVED***')
          .tr(namedArgs: {'beschreibung': termin.terminDetails.beschreibung***REMOVED***);
    ***REMOVED*** else {
      text = Text('Beschreibe die Aktion kurz',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    ***REMOVED***
    return build_text_row(text, this.action.validated['beschreibung']);
  ***REMOVED***

  Widget typeButtonCaption() {
    Text text;
    if (this.action.validated['typ'] == ValidationState.ok) {
      text = Text(this.action.typ).tr();
    ***REMOVED*** else {
      text = Text('Wähle die Art der Aktion',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    ***REMOVED***
    return build_text_row(text, this.action.validated['typ']);
  ***REMOVED***

  Row timeButtonCaption(ActionData termin) {
    String beschriftung = '';
    ValidationState val;
    if (termin.von != null)
      beschriftung += tr('von ') + ChronoHelfer.timeToStringHHmm(termin.von);
    if (termin.bis != null)
      beschriftung += tr(' bis ') + ChronoHelfer.timeToStringHHmm(termin.bis);
    Text text;
    if (beschriftung.isEmpty) {
      val = ValidationState.error;
      text =
          Text('Wähle eine Uhrzeit', style: TextStyle(color: DweTheme.purple))
              .tr();
    ***REMOVED*** else {
      val = ValidationState.ok;
      text = Text(beschriftung);
    ***REMOVED***
    //beschriftung += ',';

    return build_text_row(text, val);
  ***REMOVED***

  void validateAllInput() {
    validateAgainstNull(action.von, 'von');
    validateAgainstNull(action.bis, 'bis');
    validateAgainstNull(action.ort, 'ort');
    validateDays();
    validateTyp();
    validateVenue();
    validateDescription();
    validateContact();

    action.validated['all'] = ValidationState.ok;
    for (var value in action.validated.values) {
      if (value == ValidationState.error ||
          value == ValidationState.not_validated) {
        action.validated['all'] = ValidationState.error;
        break;
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  void validateAgainstNull(field, name) {
    if (field != null) {
      this.action.validated[name] = ValidationState.ok;
    ***REMOVED*** else {
      this.action.validated[name] = ValidationState.error;
    ***REMOVED***
  ***REMOVED***

  void validateContact() {
    if (this.action.terminDetails.kontakt == null) {
      this.action.validated['kontakt'] = ValidationState.error;
    ***REMOVED*** else {
      this.action.validated['kontakt'] = this.action.terminDetails.kontakt == ''
          ? ValidationState.error
          : ValidationState.ok;
    ***REMOVED***
  ***REMOVED***

  void validateDescription() {
    if (this.action.terminDetails.beschreibung == null) {
      this.action.validated['beschreibung'] = ValidationState.error;
    ***REMOVED*** else {
      this.action.validated['beschreibung'] =
          this.action.terminDetails.beschreibung == ''
              ? ValidationState.error
              : ValidationState.ok;
    ***REMOVED***
  ***REMOVED***

  void validateVenue() {
    if ((action.terminDetails.treffpunkt?.isEmpty ?? true) ||
        action.coordinates?.latitude == null ||
        action.coordinates?.longitude == null) {
      this.action.validated['venue'] = ValidationState.error;
    ***REMOVED*** else
      this.action.validated['venue'] = ValidationState.ok;
  ***REMOVED***

  void validateDays() {
    validateAgainstNull(this.action.tage, 'tage');

    if (this.action.tage?.isEmpty ?? true) {
      this.action.validated['tage'] = ValidationState.error;
    ***REMOVED***
  ***REMOVED***

  void validateTyp() {
    validateAgainstNull(this.action.typ, 'typ');

    if (this.action.validated['typ'] == ValidationState.ok) {
      this.action.validated['typ'] =
          this.action.typ == '' ? ValidationState.error : ValidationState.ok;
    ***REMOVED***
  ***REMOVED***

  Future<bool> showMultipleActionsQuestion(int anzahl) async =>
      await showDialog(
          context: context,
          child: AlertDialog(
            key: Key('multiple actions question dialog'),
            title: Text('Mehrere Aktionen erstellen?'.tr()),
            content: SelectableText(
                'Du hast ${anzahl***REMOVED*** Tage ausgewählt. Soll für jeden eine Aktion erstellt werden?'
                    .tr(namedArgs: {'anzahl': anzahl.toString()***REMOVED***)),
            actions: <Widget>[
              RaisedButton(
                child: Text('Zurück').tr(),
                onPressed: () => Navigator.pop(context, false),
              ),
              RaisedButton(
                child: Text('Ja').tr(),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ));

  Future<List<Termin>> generateActions() async {
    validateAllInput();
    if (action.validated['all'] == ValidationState.ok) {
      List<Termin> termine = new List<Termin>();
      for (final tag in this.action.tage) {
        DateTime begin = new DateTime(tag.year, tag.month, tag.day,
            this.action.von.hour, this.action.von.minute);
        DateTime end = new DateTime(tag.year, tag.month, tag.day,
            this.action.bis.hour, this.action.bis.minute);
        if (ChronoHelfer.isTimeOfDayBefore(this.action.bis, this.action.von)) {
          end = end.add(Duration(days: 1));
        ***REMOVED***
        User me = await Provider.of<AbstractUserService>(context).user.first;
        termine.add(Termin(
            widget.initAction?.id,
            begin,
            end,
            this.action.ort,
            this.action.typ,
            action.coordinates.latitude,
            action.coordinates.longitude,
            [me],
            this.action.terminDetails));
      ***REMOVED***
      return termine;
    ***REMOVED*** else {
      return null;
    ***REMOVED***
  ***REMOVED***

  finishPressed() async {
    setState(() {
      action.validated['finish_pressed'] = true;
      validateAllInput();
    ***REMOVED***);
    if (action.validated['all'] == ValidationState.ok) {
      var name =
          (await Provider.of<AbstractUserService>(context).user.first).name;
      if (isBlank(name)) {
        var name = await showUsernameDialog(context: context);
        if (name == null) return;
      ***REMOVED***
      if (action.tage.length > 1) {
        final resume = await showMultipleActionsQuestion(action.tage.length);
        if (!resume) return;
      ***REMOVED***
      List<Termin> termine = await generateActions();
      if (termine != null) {
        widget.onFinish(termine);
        if (isNewAction)
          resetAction();
        else
          Navigator.maybePop(context);
        Provider.of<StorageService>(context)
            .saveContact(action.terminDetails.kontakt);
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  void resetAction() {
    final contact = action.terminDetails.kontakt;
    setState(() => action = ActionData()..terminDetails.kontakt = contact);
    validateContact();
  ***REMOVED***

  Row build_text_row(Text text, ValidationState valState) {
    List<Widget> w = [Flexible(child: text)];
    if (action.validated['finish_pressed']) {
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
