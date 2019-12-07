import 'dart:convert';

import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/showLocationPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
}

class _TermineSeiteState extends State<TermineSeite> {
  static var termineService;
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
      termineService = Provider.of<TermineService>(context);
      filterWidget = FilterWidget(() => ladeTermine());
      ladeTermine();
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
            style: TextStyle(
              color: Color.fromARGB(255, 129, 28, 98),
            ),
          ),
          Image.asset('assets/images/logo.png')
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
    );
  }

  void ladeTermine() {
    termineService.ladeTermine(filterWidget.filter).then((termine) {
      setState(() {
        this.termine = termine;
      });
    });
  }

  oeffneFilter() {}
}

class FilterWidget extends StatefulWidget {
  void Function() onAnwenden;
  TermineFilter filter = TermineFilter.leererFilter();

  FilterWidget(void Function() this.onAnwenden, {Key key}) : super(key: key);

  @override
  _FilterWidget createState() => _FilterWidget();
}

class _FilterWidget extends State<FilterWidget> with TickerProviderStateMixin {
  var _zeroPadding = MaterialTapTargetSize.shrinkWrap;

  var buttonText = "Filter";
  var filterOffen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 100),
      child: Column(
        children: [
          !filterOffen
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => artAuswahl(),
                          child: Text(artButtonBeschriftung()),
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => tageAuswahl(),
                          child: tageButtonBeschriftung(),
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => zeitAuswahl(),
                          child: Text(uhrzeitButtonBeschriftung(widget.filter)),
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Color.fromARGB(255, 149, 48, 118),
                          textColor: Colors.amberAccent,
                          materialTapTargetSize: _zeroPadding,
                          onPressed: () => ortAuswahl(),
                          child: Text(ortButtonBeschriftung(widget.filter)),
                        )),
                  ],
                ),
          SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Color.fromARGB(255, 129, 28, 98),
                textColor: Colors.amberAccent,
                materialTapTargetSize: _zeroPadding,
                child: Text(buttonText),
                onPressed: () => onClicked(),
              )),
        ],
      ),
    );
  }

  Text tageButtonBeschriftung() {
    if (widget.filter.tage == null || widget.filter.tage.isEmpty) {
      return Text("alle Tage,");
    } else {
      return Text("am " +
          widget.filter.tage
              .map((tag) => DateFormat("dd.MM.").format(tag))
              .join(", ") +
          ",");
    }
  }

  String artButtonBeschriftung() {
    return widget.filter.typen != null && widget.filter.typen.isNotEmpty
        ? widget.filter.typen.join(", ")
        : "Alle Termin-Arten,";
  }

  static String uhrzeitButtonBeschriftung(TermineFilter filter) {
    String beschriftung = '';
    if (filter.von != null)
      beschriftung += 'von ' + ChronoHelfer.timeToStringHHmm(filter.von);
    if (filter.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(filter.bis);
    if (beschriftung.isEmpty) beschriftung = 'jederzeit';
    beschriftung += ',';
    return beschriftung;
  }

  String ortButtonBeschriftung(TermineFilter filter) {
    if (filter?.orte == null || filter.orte.isEmpty) return "überall";
    return "in " + filter.orte.map((ort) => ort.ort).toList().join(", ");
  }

  void onClicked() {
    setState(() {
      if (filterOffen) {
        buttonText = "Filter";
        filterOffen = false;
        widget.onAnwenden();
      } else {
        buttonText = "Anwenden";
        filterOffen = true;
      }
    });
  }

  artAuswahl() async {
    List<String> moeglicheTypen = ['Sammel-Termin', 'Info-Veranstaltung'];
    List<String> ausgewTypen = List<String>()..addAll(widget.filter.typen);
    await showDialog<List<String>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return SimpleDialog(
                  title: const Text('Wähle Termin-Arten'),
                  children: <Widget>[
                    ...moeglicheTypen.map((typ) => CheckboxListTile(
                          value: ausgewTypen.contains(typ),
                          title: Text(typ),
                          onChanged: (neuerWert) {
                            setDialogState(() {
                              if (neuerWert) {
                                ausgewTypen.add(typ);
                              } else {
                                ausgewTypen.remove(typ);
                              }
                            });
                          },
                        )),
                    RaisedButton(
                        child: Text('Fertig'),
                        onPressed: () => Navigator.pop(context))
                  ]);
            }));

    setState(() {
      widget.filter.typen = ausgewTypen;
    });
  }

  tageAuswahl() async {
    var selectedDates =
        await showMultipleDatePicker(widget.filter.tage, context);
    setState(() {
      if (selectedDates != null)
        widget.filter.tage = selectedDates
          ..sort((dt1, dt2) => dt1.compareTo(dt2));
    });
  }

  zeitAuswahl() async {
    TimeRange timeRange = await showTimeRangePicker(
        context, widget.filter.von?.hour, widget.filter.bis?.hour);
    setState(() {
      widget.filter.von = timeRange.from;
      widget.filter.bis = timeRange.to;
    });
  }

  ortAuswahl() async {
    var allLocations = await Provider.of<StammdatenService>(context).ladeOrte();
    var selectedLocations = await showMultipleLocationPicker(
        context, widget.filter.orte, allLocations, multiple: true);

    setState(() {
      widget.filter.orte = selectedLocations;
    });
  }
}
