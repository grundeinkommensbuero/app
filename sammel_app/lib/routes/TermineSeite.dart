import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/LocationPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';
import 'FilterWidget.dart';
import 'TerminDetailsWidget.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
}

class CreatedTermin {
  TimeOfDay von;
  TimeOfDay bis;
  Ort ort;
  String typ;
  List<DateTime> tage = List<DateTime>();
  TerminDetails terminDetails = TerminDetails('', '', '');
}

class CreateTerminWidget extends StatefulWidget {
  void Function() onApply;

  CreateTerminWidget(void Function() this.onApply, {Key key}) : super(key: key);

  @override
  _CreateTerminWidget createState() => _CreateTerminWidget();
}

class _CreateTerminWidget extends State<CreateTerminWidget> {
  CreatedTermin termin = CreatedTermin();
  var filter = TermineFilter.leererFilter();

  var _zeroPadding = MaterialTapTargetSize.shrinkWrap;
  TextStyle default_text_style = TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

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
                onPressed: () => ortAuswahl(),
                child: ortButtonBeschriftung(this.termin),
              ),
              FlatButton(
                  materialTapTargetSize: _zeroPadding,
                  onPressed: () => treffpunktAuswahl(),
                  child: treffpunktButtonBeschriftung(this.termin))
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
                onPressed: () => tageAuswahl(),
                child: tageButtonBeschriftung(),
              ),
              FlatButton(
                materialTapTargetSize: _zeroPadding,
                onPressed: () => zeitAuswahl(),
                child: uhrzeitButtonBeschriftung(this.termin),
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
                onPressed: () => artAuswahl(),
                child: artButtonBeschriftung(),
              ),
              FlatButton(
                  materialTapTargetSize: _zeroPadding,
                  onPressed: () => kommentarAuswahl(),
                  child: kommentarButtonBeschriftung(this.termin))
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
                  onPressed: () => kontaktAuswahl(),
                  child: kontaktButtonBeschriftung(this.termin))
            ])
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FlatButton(
                child: Text('Abbrechen'), onPressed: () {onApply(false); Navigator.pop(context, null);}),
            FlatButton(child: Text('Fertig'), onPressed: () {List<Future<Termin>> list = pushTermineToDB(onApply(true)); Navigator.pop(context, list);} )
          ])
        ]);
  }

  List<Future<Termin>> pushTermineToDB(List<Termin> termine)
  {
    print(termine);
    if(termine != null) {
      List<Future<Termin>> new_meetings = List<Future<Termin>>();
      AbstractTermineService termine_service = Provider.of<
          AbstractTermineService>(context);
      for (final termin in termine) {
        new_meetings.add(termine_service.createTermin(termin));
      }
      return new_meetings;
    }
    return null;
  }

  Text tageButtonBeschriftung() {
    if (this.termin.tage == null || this.termin.tage.isEmpty) {
      return Text("Wähle einen Tag");
    } else {
      return Text("am " +
          this
              .termin
              .tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",", style: default_text_style);
    }
  }

  void treffpunktAuswahl() async {
    var ergebnis =
        await showTextInputDialog(this.termin.terminDetails.treffpunkt, 'Treffpunkt', 'Dummy Text');
    setState(() {
      this.termin.terminDetails.treffpunkt = ergebnis;
    });
  }

  void kontaktAuswahl() async {
    var ergebnis =
        await showTextInputDialog(this.termin.terminDetails.kontakt, 'Kontakt', 'Dummy Text');
    setState(() {
      this.termin.terminDetails.kontakt = ergebnis;
    });
  }

  Future<String> showTextInputDialog(String current_value, String title, String description) {

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
      },
      onFieldSubmitted: (current_input_) {
        current_input = current_input_;
        print(current_input);
      },
      onChanged: (current_input_) {
        current_input = current_input_;
        print(current_input);
      },
    );

    Widget input_widget = null;

    if(description != null) {
      input_widget = SingleChildScrollView(child: ListBody( children: [Text(description),     SizedBox(height: 10),  input_field]));
    }
    else {
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

  void kommentarAuswahl() async{
    var ergebnis =
        await showTextInputDialog(this.termin.terminDetails.kommentar, 'Kommentar', 'Dummy Text');
    setState(() {
      this.termin.terminDetails.kommentar = ergebnis;
    });
  }

  Text artButtonBeschriftung() {
    return this.termin.typ != null && this.termin.typ != ''
        ? Text(this.termin.typ, style: default_text_style)
        : Text("Wähle eine Termin-Art");
  }

  Text uhrzeitButtonBeschriftung(CreatedTermin termin) {
    String beschriftung = '';
    if (termin.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(termin.von);
    if (termin.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(termin.bis);
    if (beschriftung.isEmpty) return Text('Wähle eine Uhrzeit');
    beschriftung += ',';
    return Text(beschriftung, style: default_text_style);
  }

  Text ortButtonBeschriftung(CreatedTermin termin) {
    if (termin.ort == null) return Text("Wähle einen Ort");
    return Text("in " + termin.ort.ort, style: default_text_style,);
  }

  List<Termin> onApply(bool use_data) {
    if (use_data) {
      if (this.termin.von != null &&
          this.termin.bis != null &&
          this.termin.tage != null &&
          !this.termin.tage.isEmpty &&
          this.termin.ort != null &&
          this.termin.typ != null &&
          this.termin.typ != '') {
        List<Termin> termine = new List<Termin>();
        for (final tag in this.termin.tage) {
          DateTime begin = new DateTime(tag.year, tag.month, tag.day,
              this.termin.von.hour, this.termin.von.minute);
          DateTime end = new DateTime(tag.year, tag.month, tag.day,
              this.termin.bis.hour, this.termin.bis.minute);

          termine.add(Termin(0, begin, end, this.termin.ort, this.termin.typ,
              this.termin.terminDetails));
        }
        return termine;
      }
    } else {
      return null;
    }
  }

  artAuswahl() async {
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
                            });
                          },
                        )),
                    RaisedButton(
                        child: Text('Fertig'),
                        onPressed: () => Navigator.pop(context))
                  ]);
            }));

    setState(() {
      this.termin.typ = ausgewTyp;
    });
  }

  tageAuswahl() async {
    var selectedDates = await showMultipleDatePicker(this.filter.tage, context,
        key: Key('days selection dialog'));
    setState(() {
      if (selectedDates != null)
        this.termin.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
    });
  }

  zeitAuswahl() async {
    TimeRange timeRange = await showTimeRangePicker(
        context, this.filter.von?.hour, this.filter.bis?.hour);
    setState(() {
      this.termin.von = timeRange.from;
      this.termin.bis = timeRange.to;
    });
  }

  ortAuswahl() async {
    var allLocations =
        await Provider.of<AbstractStammdatenService>(context).ladeOrte();
    var selectedLocations =
        await LocationPicker(locations: allLocations, multiMode: false)
            .showLocationPicker(context, List<Ort>());

    setState(() {
      if(!selectedLocations.isEmpty)
        {
          this.termin.ort = selectedLocations[0];
        }
    });
  }

  Text treffpunktButtonBeschriftung(CreatedTermin termin) {
    return (termin.terminDetails.treffpunkt == null ||
            termin.terminDetails.treffpunkt == '')
        ? Text('Treffpunkt eingeben')
        : Text(termin.terminDetails.treffpunkt, style: default_text_style);
  }

  Text kontaktButtonBeschriftung(CreatedTermin termin) {
    return (termin.terminDetails.kontakt == null ||
            termin.terminDetails.kontakt == '')
        ? Text('Kontakt eingeben')
        : Text(termin.terminDetails.kontakt, style: default_text_style);
  }

  Text kommentarButtonBeschriftung(CreatedTermin termin) {
    return (termin.terminDetails.kommentar == null ||
            termin.terminDetails.kommentar == '')
        ? Text('Beschreibung eingeben')
        : Text(termin.terminDetails.kommentar, style: default_text_style);
  }
}

class _TermineSeiteState extends State<TermineSeite> {
  static AbstractTermineService termineService;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  bool _initialized = false;
  List<Termin> termine = [];

  FilterWidget filterWidget;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) intialize(context);

    // TODO: Memory-Leak beheben
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title,
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 50.0,
          )
        ],
      )),
      body: Column(
        children: <Widget>[
          filterWidget,
          Expanded(
              child: ListView.builder(
                  itemCount: termine.length,
                  itemBuilder: (context, index) => ListTile(
                      title: TerminCard(termine[index]),
                      contentPadding: EdgeInsets.only(bottom: 0.1)))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          key: Key('create termin button'),
          onPressed: () {
            _displayStepper(context);
          },
          icon: Icon(
            Icons.add,
          ),
          label: Text("Zum Sammeln einladen"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void intialize(BuildContext context) {
    termineService = Provider.of<AbstractTermineService>(context);
    filterWidget = FilterWidget(ladeTermine);
    _initialized = true;
  }

  void ladeTermine(TermineFilter filter) {
    termineService.ladeTermine(filter).then((termine) {
      setState(() {
        this.termine = termine;
      });
    });
  }

  _displayStepper(BuildContext context) async {
    List<Future<Termin>> new_meetings = await showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
                titlePadding: EdgeInsets.zero,
                title: AppBar(
                  leading: null,
                  automaticallyImplyLeading: false,
                  title: Text('Termin erstellen',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Color.fromARGB(255, 129, 28, 98))),
                ),
                contentPadding: EdgeInsets.all(10.0),
                children: <Widget>[
                  CreateTerminWidget(() {
                    print('done');
                  })
                ]);
          });

    if(new_meetings != null) {
      setState(() {
        for (final termin in new_meetings) {
          termin.then((Termin termin) => termine.add(termin));
        }
      });
    }
  }

  openTerminDetailsWidget(BuildContext context, Termin termin) async {
    var terminMitDetails = await termineService.getTerminMitDetails(termin.id);
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              title: AppBar(
                  leading: null,
                  automaticallyImplyLeading: false,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(terminMitDetails.getAsset(), width: 30.0),
                        Container(width: 10.0),
                        Text(terminMitDetails.typ,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: Color.fromARGB(255, 129, 28, 98))),
                      ])),
              key: Key('termin details dialog'),
              contentPadding: EdgeInsets.all(10.0),
              children: <Widget>[
                TerminDetailsWidget(terminMitDetails),
                RaisedButton(
                  key: Key('close termin details button'),
                  child: Text('Schließen'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}
