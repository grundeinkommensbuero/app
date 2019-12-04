import 'dart:convert';

import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

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
    var selectedDates = await showDialog<List<DateTime>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              List<DateTime> selectedDates = widget.filter.tage;
              int aktuellerMonat = DateTime.now().month;
              if (selectedDates == null) selectedDates = [];
              return SimpleDialog(children: <Widget>[
                Row(
                  children: [Text(aktuellerMonat.toString())],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Container(
                    height: 260.0,
                    width: 1.0,
                    child: Calendarro(
                      selectedDates: selectedDates,
                      weekdayLabelsRow: GerCalendarroWeekdayLabelsView(),
                      selectionMode: SelectionMode.MULTI,
                      displayMode: DisplayMode.MONTHS,
                    )),
                ButtonBar(alignment: MainAxisAlignment.center, children: [
                  RaisedButton(
                    child: Text("Keine"),
                    onPressed: () => Navigator.pop(context, <DateTime>[]),
                  ),
                  RaisedButton(
                    child: Text("Auswählen"),
                    onPressed: () => Navigator.pop(context, selectedDates),
                  )
                ])
              ]);
            }));
    setState(() {
      widget.filter.tage = selectedDates;
    });
  }

  zeitAuswahl() async {
    var von = await zeigeZeitAuswahl('von', widget.filter.von?.hour ?? 12);
    var bis = await zeigeZeitAuswahl('bis', widget.filter.bis?.hour ?? 12);

    setState(() {
      widget.filter.von = von;
      widget.filter.bis = bis;
    });
  }

  Future<TimeOfDay> zeigeZeitAuswahl(String titel, int startStunde) =>
      showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: startStunde, minute: 0),
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: Container(
                  child: Column(
                children: <Widget>[Text(titel), child],
              )),
            );
          });

  ortAuswahl() async {
    var orte = await Provider.of<StammdatenService>(context).ladeOrte();
    List<BezirkItem> bezirke = erzeugeBezirkDaten(orte);
    await showDialog<List<int>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              List<int> ausgewOrte =
                  widget.filter.orte?.map((ort) => ort.id).toList();
              if (ausgewOrte == null) ausgewOrte = []; // Null-Sicherheit

              return SimpleDialog(
                  title: const Text('Wähle einen oder mehrere Orte'),
                  children: <Widget>[
                    ExpansionPanelList(
                        expansionCallback: (int index, bool ausgeklappt) {
                          setDialogState(() {
                            bezirke[index].ausgeklappt = !ausgeklappt;
                          });
                        },
                        children: expansionPanelListe(
                            orte, ausgewOrte, bezirke, setDialogState)),
                    RaisedButton(
                        child: Text('Fertig'),
                        onPressed: () => Navigator.pop(context, ausgewOrte))
                  ]);
            }));

    setState(() {
      widget.filter.orte = bezirke
          .expand((bezirk) => bezirk.ortAuswahl.entries)
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
    });
  }

  List<BezirkItem> erzeugeBezirkDaten(List<Ort> orte) {
    var bezirkNamen = orte.map((ort) => ort.bezirk).toSet();
    return bezirkNamen
        .map((name) => BezirkItem(
            name,
            Map<Ort, bool>()
              ..addEntries(orte.where((ort) => ort.bezirk == name).map((ort) =>
                  MapEntry(
                      ort,
                      widget.filter.orte
                          .any((filterOrt) => filterOrt.id == ort.id)))),
            false))
        .toList();
  }

  List<ExpansionPanel> expansionPanelListe(List<Ort> orte, List<int> ausgewOrte,
      List<BezirkItem> bezirke, Function setdialogState) {
    return bezirke
        .map((item) => expansionPanel(item, orte, ausgewOrte, setdialogState))
        .toList();
  }

  ExpansionPanel expansionPanel(BezirkItem bezirk, List<Ort> orte,
      List<int> ausgewOrte, Function setdialogState) {
    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) =>
            bezirkCheckbox(bezirk, orte, ausgewOrte, setdialogState),
        canTapOnHeader: true,
        isExpanded: bezirk.ausgeklappt,
        body: Column(
            children: bezirk.ortAuswahl.keys
                .map((ort) => ortCheckbox(ort, bezirk, setdialogState))
                .toList()));
  }

  CheckboxListTile bezirkCheckbox(BezirkItem item, List<Ort> orte,
      List<int> ausgewOrte, Function setDialogState) {
    return CheckboxListTile(
      value: item.ortAuswahl.values.every((ausgewaehlt) => ausgewaehlt == true),
      title: Text(item.bezirk),
      onChanged: (bool ausgewaehlt) {
        setDialogState(() {
          if (ausgewaehlt) {
            item.ortAuswahl.keys.forEach((ort) => item.ortAuswahl[ort] = true);
          } else {
            item.ortAuswahl.keys.forEach((ort) => item.ortAuswahl[ort] = false);
          }
        });
      },
    );
  }

  bool alleOrteDesBezirksAusgewaehlt(
      String bezirk, List<Ort> orte, List<int> ausgewOrte) {
    return orte.every((ortStammdaten) =>
        ortStammdaten.bezirk != bezirk ||
        ausgewOrte.contains(ortStammdaten.id));
  }

  CheckboxListTile ortCheckbox(Ort ort, BezirkItem bezirk, setDialogState) {
    return CheckboxListTile(
      value: bezirk.ortAuswahl[ort],
      title: Text('      ' + ort.ort),
      onChanged: (bool wurdeAusgewaehlt) {
        print('Wert: ' + wurdeAusgewaehlt.toString());
        print('Vorher: ' + bezirk.ortAuswahl[ort].toString());
        setDialogState(() => bezirk.ortAuswahl[ort] = wurdeAusgewaehlt);
        print('Nachher: ' + bezirk.ortAuswahl[ort].toString());
      },
    );
  }
}

class GerCalendarroWeekdayLabelsView extends CalendarroWeekdayLabelsView {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("Mo", textAlign: TextAlign.center)),
        Expanded(child: Text("Di", textAlign: TextAlign.center)),
        Expanded(child: Text("Mi", textAlign: TextAlign.center)),
        Expanded(child: Text("Do", textAlign: TextAlign.center)),
        Expanded(child: Text("Fr", textAlign: TextAlign.center)),
        Expanded(child: Text("Sa", textAlign: TextAlign.center)),
        Expanded(child: Text("So", textAlign: TextAlign.center)),
      ],
    );
  }
}

class BezirkItem {
  String bezirk;
  Map<Ort, bool> ortAuswahl;
  bool ausgeklappt;

  BezirkItem(this.bezirk, this.ortAuswahl, this.ausgeklappt);

  @override
  String toString() {
    return bezirk +
        ':' +
        ortAuswahl.entries
            .map((entry) =>
                jsonEncode(entry.key) + ' (' + entry.value.toString() + ') ')
            .toList()
            .toString() +
        ' (' +
        ausgeklappt.toString() +
        ')';
  }
}
