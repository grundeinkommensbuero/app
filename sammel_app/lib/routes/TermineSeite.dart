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
import 'package:sammel_app/shared/DweTheme.dart';
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

class CreatedTermin{

  TimeOfDay von;
  TimeOfDay bis;
  Ort ort;
  String typ;
  List<DateTime> tage = List<DateTime>();
  TerminDetails terminDetails = TerminDetails('','','');
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

  @override
  Widget build(BuildContext context) {
    return Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                    //          color: Color.fromARGB(255, 149, 48, 118),
                    //         textColor: Colors.amberAccent,
                    materialTapTargetSize: _zeroPadding,
                    onPressed: () => ortAuswahl(),
                    child: Text(ortButtonBeschriftung(this.termin)),
                  ),
                  FlatButton(
                    //       color: Color.fromARGB(255, 149, 48, 118),
                    //     textColor: Colors.amberAccent,
                      materialTapTargetSize: _zeroPadding,
                      onPressed: () => treffpunktAuswahl(),
                      child: Text(treffpunktButtonBeschriftung(this.termin)))])]),
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
                  //      color: Color.fromARGB(255, 149, 48, 118),
                  //      textColor: Colors.amberAccent,
                  materialTapTargetSize: _zeroPadding,
                  onPressed: () => tageAuswahl(),
                  child: tageButtonBeschriftung(),
                ),
                  FlatButton(
                    //         color: Color.fromARGB(255, 149, 48, 118),
                    //           textColor: Colors.amberAccent,
                    materialTapTargetSize: _zeroPadding,
                    onPressed: () => zeitAuswahl(),
                    child: Text(uhrzeitButtonBeschriftung(this.termin)),
                  )
                ])]),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline, size: 40.0),
            SizedBox(
              width: 10.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Was?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ), FlatButton(
                //        color: Color.fromARGB(255, 149, 48, 118),
                //      textColor: Colors.amberAccent,
                materialTapTargetSize: _zeroPadding,
                onPressed: () => artAuswahl(),
                child: Text(artButtonBeschriftung()),
              ),
              FlatButton(
                //       color: Color.fromARGB(255, 149, 48, 118),
                //       textColor: Colors.amberAccent,
                  materialTapTargetSize: _zeroPadding,
                  onPressed: () => kommentarAuswahl(),
                  child: Text(kommentarButtonBeschriftung(this.termin)))])]),
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
            child: Text(kontaktButtonBeschriftung(this.termin)))])]),
            Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [FlatButton(child: Text('Abbrechen'), onPressed: () => onApply(false)),
            FlatButton(child: Text('Fertig'), onPressed: () => onApply(true))])]);
  }

  Text tageButtonBeschriftung() {
    if (this.termin.tage == null || this.termin.tage.isEmpty) {
      return Text("alle Tage,");
    } else {
      return Text("am " +
          this.termin.tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",");
    }
  }

  void treffpunktAuswahl() {
    String treffpunkt = this.termin.terminDetails.treffpunkt;
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {    setState(() {
        this.termin.terminDetails.treffpunkt = treffpunkt;
      }); Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Treffpunkt"),
      content: TextFormField( initialValue: this.termin.terminDetails.treffpunkt,
        onSaved: (treffpunkt_) {
          treffpunkt = treffpunkt_;
        },
        onFieldSubmitted: (treffpunkt_) {
          treffpunkt = treffpunkt_;
        },

        onChanged: (treffpunkt_) {
          treffpunkt = treffpunkt_;
        },

      ),

      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void kontaktAuswahl() {
    String kontakt = this.termin.terminDetails.kontakt;
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {    setState(() {
        this.termin.terminDetails.kontakt = kontakt;
      }); Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Kontakt"),
      content: TextFormField( initialValue: this.termin.terminDetails.kontakt,
        onSaved: (kontakt_) {
          kontakt = kontakt_;
        },
        onFieldSubmitted: (kontakt_) {
          kontakt = kontakt_;
        },

        onChanged: (kontakt_) {
          kontakt = kontakt_;
        },

      ),

      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void kommentarAuswahl() {
    String kommentar = this.termin.terminDetails.kommentar;
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {    setState(() {
        this.termin.terminDetails.kommentar = kommentar;
      }); Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Kommentar"),
      content: TextFormField( initialValue: this.termin.terminDetails.kommentar,
        onSaved: (kommentar_) {
          kommentar = kommentar_;
        },
        onFieldSubmitted: (kommentar_) {
          kommentar = kommentar_;
        },

        onChanged: (kommentar_) {
          kommentar = kommentar_;
        },

      ),

      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String artButtonBeschriftung() {
    return this.termin.typ != null && this.termin.typ != ''
        ? this.termin.typ
        : "Alle Termin-Arten,";
  }

  static String uhrzeitButtonBeschriftung(CreatedTermin termin) {
    String beschriftung = '';
    if (termin.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(termin.von);
    if (termin.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(termin.bis);
    if (beschriftung.isEmpty) beschriftung = 'jederzeit';
    beschriftung += ',';
    return beschriftung;
  }

  String ortButtonBeschriftung(CreatedTermin termin) {
    if (termin.ort == null) return "überall";
    return "in " + termin.ort.ort;
  }

  void onApply(bool use_data) {
    if(use_data) {
      if (this.termin.von != null && this.termin.bis != null &&
          this.termin.tage != null
          && !this.termin.tage.isEmpty && this.termin.ort != null &&
          this.termin.typ != null && this.termin.typ != '') {
        List<Termin> termine = new List<Termin>();
        for (final tag in this.termin.tage) {
          DateTime begin = new DateTime(
              tag.year, tag.month, tag.day, this.termin.von.hour,
              this.termin.von.minute);
          DateTime end = new DateTime(
              tag.year, tag.month, tag.day, this.termin.bis.hour,
              this.termin.bis.minute);

          termine.add(Termin(
              0,
              begin,
              end,
              this.termin.ort,
              this.termin.typ,
              this.termin.terminDetails));
        }
        Navigator.pop(context, termine);
      }
    }
    else {
      Navigator.pop(context, null);
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
    var selectedDates =
    await showMultipleDatePicker(this.filter.tage, context, key: Key('days selection dialog'));
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

    var selectedLocations = await LocationPicker(locations: this.filter.orte, multiMode: false)
        .showLocationPicker(context, List<Ort>());

    setState(() {
      this.termin.ort = selectedLocations[0];
    });
  }

  String treffpunktButtonBeschriftung(CreatedTermin termin) {
    return (termin.terminDetails.treffpunkt == null || termin.terminDetails.treffpunkt == '') ? 'Treffpunkt' : termin.terminDetails.treffpunkt;
  }

  String kontaktButtonBeschriftung(CreatedTermin termin) {
    return (termin.terminDetails.kontakt == null || termin.terminDetails.kontakt == '') ? 'Kontakt' : termin.terminDetails.kontakt;
  }

  String kommentarButtonBeschriftung(CreatedTermin termin) {
    return (termin.terminDetails.kommentar == null || termin.terminDetails.kommentar == '') ? 'Beschreibung' : termin.terminDetails.kommentar;
  }
}


class _TermineSeiteState extends State<TermineSeite> {
  static AbstractTermineService termineService;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  bool initialized = false;
  List<Termin> termine = [];

  FilterWidget filterWidget;

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      termineService = Provider.of<AbstractTermineService>(context);
      filterWidget = FilterWidget(ladeTermine);
      ladeTermine(TermineFilter.leererFilter());
      initialized = true;
    }
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

  void ladeTermine(TermineFilter filter) {
    termineService.ladeTermine(filter).then((termine) {
      setState(() {
        this.termine = termine;
      });
    });
  }

  _displayStepper(BuildContext context) async {
    Future<List<Termin>> _asyncTerminDialog(BuildContext context) async{
      return showDialog(
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
                children: <Widget>[CreateTerminWidget((){print('done');})] );
          });}

          print(_asyncTerminDialog(context));

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
