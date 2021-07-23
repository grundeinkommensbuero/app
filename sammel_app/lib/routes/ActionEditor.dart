import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/action_types.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';

import 'LocationDialog.dart';

enum ValidationState { not_validated, error, ok, pressed, unpressed }

class ActionData {
  TimeOfDay? von;
  TimeOfDay? bis;
  Kiez? ort;
  String typ;
  late List<DateTime> tage;
  String? treffpunkt;
  String? beschreibung;
  String? kontakt;
  LatLng? coordinates;

  ActionData(
      [this.typ = 'Sammeln',
      this.von,
      this.bis,
      this.ort,
      tage,
      this.treffpunkt,
      this.beschreibung,
      this.kontakt,
      this.coordinates]) {
    this.tage = tage ?? [];
  }

  Map<String, ValidationState> validated = {
    'von': ValidationState.not_validated,
    'bis': ValidationState.not_validated,
    'ort': ValidationState.not_validated,
    'typ': ValidationState.ok,
    'tage': ValidationState.not_validated,
    'all': ValidationState.not_validated,
    'venue': ValidationState.not_validated,
    'kontakt': ValidationState.not_validated,
    'beschreibung': ValidationState.not_validated,
    'finish_pressed': ValidationState.unpressed,
  };
}

// ignore: must_be_immutable
class ActionEditor extends StatefulWidget {
  final Termin? initAction;
  late Function onFinish;

  ActionEditor({this.initAction, required this.onFinish, Key? key})
      : super(key: key);

  @override
  ActionEditorState createState() => ActionEditorState(this.initAction);
}

class ActionEditorState extends State<ActionEditor>
    with AfterLayoutMixin<ActionEditor> {
  ActionData action = ActionData();

  ActionEditorState(Termin? initAction) : super() {
    if (initAction != null) assignInitialAction(initAction);
    validateAllInput();
  }

  void assignInitialAction(Termin initAction) {
    action.ort = initAction.ort;
    action.typ = initAction.typ;
    action.tage.add(initAction.beginn);
    action.von = TimeOfDay.fromDateTime(initAction.beginn);
    action.bis = TimeOfDay.fromDateTime(initAction.ende);
    action.treffpunkt = initAction.details?.treffpunkt;
    action.beschreibung = initAction.details?.beschreibung;
    action.kontakt = initAction.details?.kontakt;
    action.coordinates = LatLng(initAction.latitude, initAction.longitude);
  }

  get isNewAction => widget.initAction == null;

  @override
  void afterFirstLayout(BuildContext context) {
    if (isNewAction)
      Provider.of<StorageService>(context, listen: false)
          .loadContact()
          .then((stored) {
        setState(() => action.kontakt = stored);
        validateContact();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(color: CampaignTheme.primaryLight),
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
              color: CampaignTheme.primary),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                key: Key('action editor cancel button'),
                child: Text('Abbrechen').tr(),
                onPressed: () {
                  resetAction();
                  Navigator.maybePop(context);
                }),
            ElevatedButton(
                key: Key('action editor finish button'),
                child: Text('Fertig').tr(),
                onPressed: () => finishPressed())
          ]),
        ));
  }

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

  void locationSelection({LatLng? initPosition}) async {
    Location? ergebnis = await showLocationDialog(
        context: context,
        initDescription: action.treffpunkt,
        initCoordinates: action.coordinates ?? initPosition,
        initKiez: action.ort,
        center: determineMapCenter(action));

    setNewLocation(ergebnis);
  }

  void setNewLocation(Location? ergebnis) {
    setState(() {
      action.treffpunkt = ergebnis?.description;
      action.coordinates = ergebnis?.coordinates;
      action.ort = ergebnis?.kiez;
      validateAllInput();
    });
  }

  static LatLng? determineMapCenter(ActionData action) {
    // at old coordinates
    if (action.coordinates?.latitude == null &&
        action.coordinates?.longitude == null)
      return null;
    else
      return LatLng(
          action.coordinates!.latitude, action.coordinates!.longitude);
  }

  void contactSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.kontakt,
        'Kontakt',
        'Hier kannst du ein paar Worte über dich verlieren. Wer bist du, woran '
            'erkennt man dich vor Ort, wie kann man dich vorher kontaktieren, usw.\n'
            'Beachte dass alle Sammler*innen deine Angaben lesen können!',
        Key('contact input dialog'));
    setState(() {
      this.action.kontakt = ergebnis;
      validateAllInput();
    });
  }

  Future<String?> showTextInputDialog(
      String? initialValue, String title, String? description, Key key) {
    String? currentValue = initialValue;

    TextFormField inputField = TextFormField(
      key: Key('text input dialog field'),
      minLines: 3,
      initialValue: initialValue,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      onChanged: (newValue) {
        currentValue = newValue;
      },
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
                inputField
              ]))
            : inputField,
        actions: [
          TextButton(
            child: Text("Abbrechen").tr(),
            onPressed: () {
              Navigator.pop(context, initialValue);
            },
          ),
          TextButton(
            key: Key('action editor text input accept button'),
            child: Text("Fertig").tr(),
            onPressed: () => Navigator.pop(context, currentValue),
          ),
        ],
      ),
    );
  }

  typeSelection() async {
    String? ausgewTyp = action.typ;
    await showDialog<String>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  key: Key('type selection dialog'),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.all(15.0),
                  title: const Text('Wähle Aktions-Art').tr(),
                  children: []
                    ..addAll(moeglicheTypen.map((typ) => RadioListTile(
                          groupValue: ausgewTyp,
                          value: typ,
                          title: Text(typ).tr(),
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              ausgewTyp = newValue ?? 'Sammeln';
                            });
                          },
                        )))
                    ..add(ElevatedButton(
                        child: Text('Fertig').tr(),
                        onPressed: () => Navigator.pop(context))));
            }));

    if (ausgewTyp != null)
      setState(() {
        this.action.typ = ausgewTyp!;
        validateAllInput();
      });
  }

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

  void descriptionSelection() async {
    var ergebnis = await showTextInputDialog(
        this.action.beschreibung,
        'Beschreibung',
        'Gib eine kurze Beschreibung der Aktion an. Wo willst du sammeln gehen, was sollen die anderen Sammler*innen mitbringen? Kann man auch später dazustoßen?',
        Key('description input dialog'));
    setState(() {
      this.action.beschreibung = ergebnis;
      validateAllInput();
    });
  }

  Widget daysButtonCaption() {
    Text text;
    if (this.action.validated['tage'] == ValidationState.error ||
        this.action.validated['tage'] == ValidationState.not_validated) {
      text = Text("Wähle einen Tag",
              style: TextStyle(color: CampaignTheme.secondary))
          .tr();
    } else {
      text = Text('am '.tr() +
          this
              .action
              .tage
              .map((tag) => DateFormat('dd.MM.').format(tag))
              .join(', ') +
          ',');
    }
    return buildTextRow(text, this.action.validated['tage']!);
  }

  Widget locationButtonCaption(ActionData termin) {
    Text text;
    if (this.action.validated['venue'] == ValidationState.error ||
        this.action.validated['venue'] == ValidationState.not_validated) {
      text = Text(
        'Gib einen Treffpunkt an',
        style: TextStyle(color: CampaignTheme.secondary),
      ).tr();
    } else {
      text =
          Text('{kiez} in {bezirk}\n Treffpunkt: {treffpunkt}').tr(namedArgs: {
        'kiez': termin.ort!.name,
        'bezirk': termin.ort!.ortsteil,
        'treffpunkt': termin.treffpunkt!,
      });
    }
    return buildTextRow(text, this.action.validated['venue']!);
  }

  Widget contactButtonCaption(ActionData termin) {
    Text text;
    ValidationState val;
    if (this.action.validated['kontakt'] == ValidationState.ok) {
      text = Text(termin.kontakt!);
      val = ValidationState.ok;
    } else {
      text = Text('Ein paar Worte über dich',
              style: TextStyle(color: CampaignTheme.secondary))
          .tr();
      val = ValidationState.error;
    }
    return buildTextRow(text, val);
  }

  Widget descriptionButtonCaption(ActionData termin) {
    Text text;
    if (this.action.validated['beschreibung'] == ValidationState.ok) {
      text = Text('Beschreibung: {beschreibung}')
          .tr(namedArgs: {'beschreibung': termin.beschreibung!});
    } else {
      text = Text('Beschreibe die Aktion kurz',
              style: TextStyle(color: CampaignTheme.secondary))
          .tr();
    }
    return buildTextRow(text, this.action.validated['beschreibung']!);
  }

  Widget typeButtonCaption() {
    Text text;
    if (this.action.validated['typ'] == ValidationState.ok) {
      text = Text(this.action.typ).tr();
    } else {
      text = Text('Wähle die Art der Aktion',
              style: TextStyle(color: CampaignTheme.secondary))
          .tr();
    }
    return buildTextRow(text, this.action.validated['typ']!);
  }

  Row timeButtonCaption(ActionData termin) {
    String beschriftung = '';
    ValidationState val;
    if (termin.von != null)
      beschriftung += tr('von ') + ChronoHelfer.timeToStringHHmm(termin.von)!;
    if (termin.bis != null)
      beschriftung += tr(' bis ') + ChronoHelfer.timeToStringHHmm(termin.bis)!;
    Text text;
    if (beschriftung.isEmpty) {
      val = ValidationState.error;
      text = Text('Wähle eine Uhrzeit',
              style: TextStyle(color: CampaignTheme.secondary))
          .tr();
    } else {
      val = ValidationState.ok;
      text = Text(beschriftung);
    }
    //beschriftung += ',';

    return buildTextRow(text, val);
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
    if (this.action.kontakt == null) {
      this.action.validated['kontakt'] = ValidationState.error;
    } else {
      this.action.validated['kontakt'] = this.action.kontakt == ''
          ? ValidationState.error
          : ValidationState.ok;
    }
  }

  void validateDescription() {
    if (this.action.beschreibung == null) {
      this.action.validated['beschreibung'] = ValidationState.error;
    } else {
      this.action.validated['beschreibung'] = this.action.beschreibung == ''
          ? ValidationState.error
          : ValidationState.ok;
    }
  }

  void validateVenue() {
    if ((action.treffpunkt?.isEmpty ?? true) ||
        action.coordinates?.latitude == null ||
        action.coordinates?.longitude == null) {
      this.action.validated['venue'] = ValidationState.error;
    } else
      this.action.validated['venue'] = ValidationState.ok;
  }

  void validateDays() {
    validateAgainstNull(this.action.tage, 'tage');

    if (this.action.tage.isEmpty) {
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

  Future<bool> showMultipleActionsQuestion(int anzahl) async =>
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                key: Key('multiple actions question dialog'),
                title: Text('Mehrere Aktionen erstellen?'.tr()),
                content: SelectableText(
                    'Du hast $anzahl Tage ausgewählt. Soll für jeden eine Aktion erstellt werden?'
                        .tr(namedArgs: {'anzahl': anzahl.toString()})),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('Zurück').tr(),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  ElevatedButton(
                    child: Text('Ja').tr(),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ));

  Future<List<Termin>?> generateActions() async {
    validateAllInput();
    if (action.validated['all'] == ValidationState.ok) {
      List<Termin> termine = [];
      for (final tag in this.action.tage) {
        DateTime begin = new DateTime(tag.year, tag.month, tag.day,
            this.action.von!.hour, this.action.von!.minute);
        DateTime end = new DateTime(tag.year, tag.month, tag.day,
            this.action.bis!.hour, this.action.bis!.minute);
        if (ChronoHelfer.isTimeOfDayBefore(
            this.action.bis!, this.action.von!)) {
          end = end.add(Duration(days: 1));
        }
        User me = await Provider.of<AbstractUserService>(context, listen: false)
            .user
            .first
            .timeout(Duration(seconds: 5), onTimeout: () => throw Exception());
        termine.add(Termin(
            widget.initAction?.id,
            begin,
            end,
            this.action.ort!,
            this.action.typ,
            action.coordinates!.latitude,
            action.coordinates!.longitude,
            [me],
            TerminDetails(
                action.treffpunkt!, action.beschreibung!, action.kontakt!)));
      }
      return termine;
    } else {
      return null;
    }
  }

  finishPressed() async {
    setState(() {
      action.validated['finish_pressed'] = ValidationState.pressed;
      validateAllInput();
    });
    if (action.validated['all'] == ValidationState.ok) {
      var name = (await Provider.of<AbstractUserService>(context, listen: false)
              .user
              .first)
          .name;
      if (isBlank(name)) {
        var name = await showUsernameDialog(context: context);
        if (name == null) return;
      }
      if (action.tage.length > 1) {
        final resume = await showMultipleActionsQuestion(action.tage.length);
        if (!resume) return;
      }
      List<Termin>? termine = await generateActions();
      if (termine != null) {
        widget.onFinish(termine);
        if (isNewAction)
          resetAction();
        else
          Navigator.maybePop(context);
        Provider.of<StorageService>(context, listen: false)
            .saveContact(action.kontakt!);
      }
    }
  }

  void resetAction() {
    final contact = action.kontakt;
    setState(() => action = ActionData()..kontakt = contact);
    validateContact();
  }

  setPosition(LatLng position) async =>
      setNewLocation(await getDescriptionAndKiezToPoint(position));

  Future<Location> getDescriptionAndKiezToPoint(LatLng point) async {
    var geodata = await Provider.of<GeoService>(context, listen: false)
        .getDescriptionToPoint(point)
        .catchError((e, s) {
      ErrorService.handleError(e, s);
      return GeoData('', '', '');
    });

    Kiez? kiez = await Provider.of<StammdatenService>(context, listen: false)
        .getKiezAtLocation(point);

    return Location(geodata.description, point, kiez);
  }

  Row buildTextRow(Text text, ValidationState valState) {
    List<Widget> w = [Flexible(child: text)];
    if (action.validated['finish_pressed'] == ValidationState.pressed) {
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
  final Function() onTap;
  final Widget child;

  InputButton({required this.onTap, required this.child, key})
      : super(key: key);

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
