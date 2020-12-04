import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
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

enum ValidationState { not_validated, error, ok }

class ActionData {
  TimeOfDay von;
  TimeOfDay bis;
  Ort ort;
  String typ;
  List<DateTime> tage;
  TerminDetails terminDetails;
  LatLng coordinates;

  ActionData.testDaten() {
    this.von = TimeOfDay.fromDateTime(DateTime.now());
    this.bis = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
    this.ort = Ort(1, 'Friedrichshain-Kreuzberg', 'Friedrichshain Nordkiez',
        52.51579, 13.45399);
    this.coordinates = LatLng(52.51579, 13.45399);
    this.typ = 'Sammeln';
    this.tage = [DateTime.now()];
    this.terminDetails =
        TerminDetails('Weltzeituhr', 'Es gibt Kuchen', 'Ich bin ich');
  }

  ActionData(
      [this.von,
      this.bis,
      this.ort,
      this.typ,
      this.tage,
      this.terminDetails,
      this.coordinates]) {
    this.tage = this.tage ?? [];
    this.terminDetails = this.terminDetails ?? TerminDetails('', '', '');
  }

  var validated = {
    'von': ValidationState.not_validated,
    'bis': ValidationState.not_validated,
    'ort': ValidationState.not_validated,
    'typ': ValidationState.not_validated,
    'tage': ValidationState.not_validated,
    'all': ValidationState.not_validated,
    'venue': ValidationState.not_validated,
    'kontakt': ValidationState.not_validated,
    'beschreibung': ValidationState.not_validated,
    'finish_pressed': false
  };
}

// ignore: must_be_immutable
class ActionEditor extends StatefulWidget {
  final Termin initAction;
  Function onFinish;

  ActionEditor({this.initAction, this.onFinish, Key key}) : super(key: key) {
    if (onFinish == null) onFinish = (List<Termin> _) {};
  }

  @override
  ActionEditorState createState() => ActionEditorState(this.initAction);
}

class ActionEditorState extends State<ActionEditor> {
  ActionData action = ActionData.testDaten();

  ActionEditorState(Termin initAction) : super() {
    if (initAction != null) assign_initial_termin(initAction);
    validateAllInput();
  }

  void assign_initial_termin(Termin initAction) {
    action.ort = initAction.ort;
    action.typ = initAction.typ;
    if (initAction.details != null) action.terminDetails = initAction.details;
    if (initAction.beginn != null) {
      action.von = TimeOfDay.fromDateTime(initAction.beginn);
      action.tage.add(initAction.beginn);
    }
    if (initAction.ende != null)
      action.bis = TimeOfDay.fromDateTime(initAction.ende);
    if (initAction.details != null) {
      action.terminDetails = initAction.details;
    }
    action.coordinates = LatLng(initAction.latitude, initAction.longitude);
  }

  get isNewAction => widget.initAction == null;

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
                isNewAction ? motivationText : Container(),
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
                          'Wo? ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InputButton(
                            onTap: locationSelection,
                            child: locationButtonCaption(this.action),
                            key: Key('Open location dialog')),
                        InputButton(
                            onTap: venueSelection,
                            child: venueButtonCaption(this.action)),
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
                        ),
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
                        ),
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
                        ),
                        InputButton(
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
                child: Text('Abbrechen'),
                onPressed: () {
                  setState(() => action = ActionData());
                  Navigator.maybePop(context);
                }),
            RaisedButton(
                key: Key('action editor finish button'),
                child: Text('Fertig'),
                onPressed: () => finishPressed())
          ]),
        ));
  }

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

  void venueSelection() async {
    Venue ergebnis = await showVenueDialog(
        context: context,
        initDescription: action.terminDetails.treffpunkt,
        initCoordinates: action.coordinates,
        center: determineMapCenter(action));

    setState(() {
      action.terminDetails.treffpunkt = ergebnis?.description;
      action.coordinates = ergebnis?.coordinates;
      validateAllInput();
    });
  }

  static LatLng determineMapCenter(ActionData action) {
    // at old coordinates
    if (action.coordinates?.latitude != null &&
        action.coordinates?.longitude != null)
      return LatLng(action.coordinates.latitude, action.coordinates.longitude);
    // at location
    if (action.ort?.latitude != null && action.ort?.latitude != null)
      return LatLng(action.ort.latitude, action.ort.longitude);

    return null;
  }

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
      validateAllInput();
    });
  }

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
      },
    );

    Widget input_widget;

    if (description != null) {
      input_widget = SingleChildScrollView(
          child: ListBody(children: [
        Text(description),
        SizedBox(height: 10),
        input_field
      ]));
    } else {
      input_widget = input_field;
    }

    Widget cancelButton = FlatButton(
      child: Text("Abbrechen"),
      onPressed: () {
        Navigator.pop(context, current_value);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Fertig"),
      onPressed: () {
        Navigator.pop(context, current_input);
      },
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
      },
    );
  }

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
                  children: []
                    ..addAll(moeglicheTypen.map((typ) => RadioListTile(
                          groupValue: ausgewTyp,
                          value: typ,
                          title: Text(typ),
                          onChanged: (neuerWert) {
                            setDialogState(() {
                              ausgewTyp = neuerWert;
                            });
                          },
                        )))
                    ..add(RaisedButton(
                        child: Text('Fertig'),
                        onPressed: () => Navigator.pop(context))));
            }));

    setState(() {
      this.action.typ = ausgewTyp;
      validateAllInput();
    });
  }

  daysSelection() async {
    var selectedDates = await showMultipleDatePicker(this.action.tage, context,
        key: Key('days selection dialog'),
        multiMode: /*widget.initAction == null ? true : false*/ true);
    setState(() {
      if (selectedDates != null)
        this.action.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
      validateAllInput();
    });
  }

  timeSelection() async {
    TimeRange timeRange =
        await showTimeRangePicker(context, this.action.von, this.action.bis);
    setState(() {
      this.action.von = timeRange.from;
      this.action.bis = timeRange.to;
      validateAllInput();
    });
  }

  locationSelection() async {
    var allLocations =
        await Provider.of<AbstractStammdatenService>(context).ladeOrte();
    var selectedLocations = await LocationPicker(
            key: Key('Location Picker'),
            locations: allLocations,
            multiMode: false)
        .showLocationPicker(context, List<Ort>());

    setState(() {
      if (selectedLocations.isNotEmpty) {
        this.action.ort = selectedLocations[0];
        validateAllInput();
      }
    });
  }

  void descriptionSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.terminDetails.beschreibung,
        'Beschreibung',
        'Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammlerinnen und Sammler mitbringen? Kann man auch später dazustoßen, usw',
        Key('description input dialog'));
    setState(() {
      this.action.terminDetails.beschreibung = ergebnis;
      validateAllInput();
    });
  }

  Widget daysButtonCaption() {
    Text text;
    if (this.action.validated['tage'] == ValidationState.error ||
        this.action.validated['tage'] == ValidationState.not_validated) {
      text = Text("Wähle einen Tag", style: TextStyle(color: DweTheme.purple));
    } else {
      text = Text("am " +
          this
              .action
              .tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",");
    }
    return build_text_row(text, this.action.validated['tage']);
  }

  Widget venueButtonCaption(ActionData termin) {
    Text text;
    if (this.action.validated['venue'] == ValidationState.error ||
        this.action.validated['venue'] == ValidationState.not_validated) {
      text = Text(
        'Gib einen Treffpunkt an',
        style: TextStyle(color: DweTheme.purple),
      );
    } else {
      text = Text('Treffpunkt: ${termin.terminDetails.treffpunkt}');
    }
    return build_text_row(text, this.action.validated['venue']);
  }

  Widget contactButtonCaption(ActionData termin) {
    Text text;
    ValidationState val;
    if (this.action.validated['kontakt'] == ValidationState.ok) {
      text = Text(termin.terminDetails.kontakt);
      val = ValidationState.ok;
    } else {
      text = Text('Ein paar Worte über dich',
          style: TextStyle(color: DweTheme.purple));
      val = ValidationState.error;
    }
    return build_text_row(text, val);
    /*
    return (termin.terminDetails.kontakt == null ||
            termin.terminDetails.kontakt == '')
        ? Text('Ein paar Worte über dich',
            style: TextStyle(color: DweTheme.purple))
        : ;*/
  }

  Widget descriptionButtonCaption(ActionData termin) {
    Text text;
    if (this.action.validated['beschreibung'] == ValidationState.ok) {
      text = Text('Beschreibung: ${termin.terminDetails.beschreibung}');
    } else {
      text = Text('Beschreibe die Aktion kurz',
          style: TextStyle(color: DweTheme.purple));
    }
    return build_text_row(text, this.action.validated['beschreibung']);
  }

  Widget typeButtonCaption() {
    Text text;
    if (this.action.validated['typ'] == ValidationState.ok) {
      text = Text(this.action.typ);
    } else {
      text = Text('Wähle die Art der Aktion',
          style: TextStyle(color: DweTheme.purple));
    }
    return build_text_row(text, this.action.validated['typ']);
  }

  Row timeButtonCaption(ActionData termin) {
    String beschriftung = '';
    ValidationState val;
    if (termin.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(termin.von);
    if (termin.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(termin.bis);
    Text text;
    if (beschriftung.isEmpty) {
      val = ValidationState.error;
      text =
          Text('Wähle eine Uhrzeit', style: TextStyle(color: DweTheme.purple));
    } else {
      val = ValidationState.ok;
      text = Text(beschriftung);
    }
    //beschriftung += ',';

    return build_text_row(text, val);
  }

  Widget locationButtonCaption(ActionData termin) {
    Text text;
    if (termin.validated['ort'] == ValidationState.not_validated ||
        termin.validated['ort'] == ValidationState.error)
      text = Text("Wähle einen Ort", style: TextStyle(color: DweTheme.purple));
    else {
      text = Text("in " + termin.ort.ort);
    }
    return build_text_row(text, termin.validated['ort']);
  }

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
      }
    }
  }

  void validateAgainstNull(field, name) {
    if (field != null) {
      this.action.validated[name] = ValidationState.ok;
    } else {
      this.action.validated[name] = ValidationState.error;
    }
  }

  void validateContact() {
    if (this.action.terminDetails.kontakt == null) {
      this.action.validated['kontakt'] = ValidationState.error;
    } else {
      this.action.validated['kontakt'] = this.action.terminDetails.kontakt == ''
          ? ValidationState.error
          : ValidationState.ok;
    }
  }

  void validateDescription() {
    if (this.action.terminDetails.beschreibung == null) {
      this.action.validated['beschreibung'] = ValidationState.error;
    } else {
      this.action.validated['beschreibung'] =
          this.action.terminDetails.beschreibung == ''
              ? ValidationState.error
              : ValidationState.ok;
    }
  }

  void validateVenue() {
    if ((action.terminDetails.treffpunkt?.isEmpty ?? true) ||
        action.coordinates?.latitude == null ||
        action.coordinates?.longitude == null) {
      this.action.validated['venue'] = ValidationState.error;
    } else
      this.action.validated['venue'] = ValidationState.ok;
  }

  void validateDays() {
    validateAgainstNull(this.action.tage, 'tage');

    if (this.action.tage?.isEmpty ?? true) {
      this.action.validated['tage'] = ValidationState.error;
    }
  }

  void validateTyp() {
    validateAgainstNull(this.action.typ, 'typ');

    if (this.action.validated['typ'] == ValidationState.ok) {
      this.action.validated['typ'] =
          this.action.typ == '' ? ValidationState.error : ValidationState.ok;
    }
  }

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
        }
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
      }
      return termine;
    } else {
      return null;
    }
  }

  finishPressed() async {
    setState(() {
      action.validated['finish_pressed'] = true;
      validateAllInput();
    });
    if (action.validated['all'] == ValidationState.ok) {
      var name = Provider.of<AbstractUserService>(context).latestUser.name;
      if(isBlank(name)) {
        var name = await showUsernameDialog(context: context);
        if(name == null) return;
      }
      List<Termin> termine = await generateActions();
      if (termine != null) {
        widget.onFinish(termine);
        if (isNewAction)
          setState(() => action = ActionData()); // reset Form for next use
        else
          Navigator.maybePop(context);
      }
    }
  }

  Row build_text_row(Text text, ValidationState valState) {
    List<Widget> w = [Flexible(child: text)];
    if (action.validated['finish_pressed']) {
      if (valState == ValidationState.ok) {
        w.add(Icon(Icons.done, color: Colors.black));
      } else {
        w.add(Icon(Icons.error_outline));
      }
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: w);
  }
}

class InputButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final Key key;

  InputButton({this.onTap, this.child, this.key}) : super(key: key);

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
  }
}
