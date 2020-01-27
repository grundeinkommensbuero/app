import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:uuid/uuid.dart';
import 'FilterWidget.dart';
import 'ActionDetailsPage.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
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

  List<int> myActions;

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
                  key: Key('action list'),
                  itemCount: termine.length,
                  itemBuilder: cardListBuilder)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          key: Key('create termin button'),
          onPressed: () => openCreateDialog(context),
          icon: Icon(
            Icons.add,
          ),
          label: Text("Zum Sammeln einladen"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget cardListBuilder(context, index) {
    // insert "Jetzt" line
    var tile = ListTile(
        title: TerminCard(
            termine[index], isMyAction(termine[index].id), Key('action card')),
        onTap: () => openTerminDetails(context, termine[index]),
        contentPadding: EdgeInsets.only(bottom: 0.1));
    var now = DateTime.now();
    if ((termine[index].beginn.isBefore(now)) &&
        (index == termine.length - 1 || termine[index + 1].beginn.isAfter(now)))
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        tile,
        Text(
          'Jetzt',
          key: Key('action list now line'),
          style: TextStyle(color: DweTheme.purple, fontSize: 16.0),
        ),
      ]);
    else
      return tile;
  }

  bool isMyAction(int id) {
    return myActions?.contains(id);
  }

  void intialize(BuildContext context) {
//    Provider.of<StorageService>(context).clearAllPreferences();

    termineService = Provider.of<AbstractTermineService>(context);
    filterWidget = FilterWidget(ladeTermine);
    Provider.of<StorageService>(context)
        .loadAllStoredActionIds()
        .then((ids) => setState(() => myActions = ids));
    _initialized = true;
  }

  void ladeTermine(TermineFilter filter) {
    termineService.ladeTermine(filter).then((termine) {
      setState(() {
        this.termine = termine..sort(Termin.sortByStart());
      });
    });
  }

  openCreateDialog(BuildContext context) async {
    List<Termin> newActions = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              titlePadding: EdgeInsets.zero,
              title: AppBar(
                leading: null,
                automaticallyImplyLeading: false,
                title: Text('Aktion erstellen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Color.fromARGB(255, 129, 28, 98))),
              ),
              contentPadding: EdgeInsets.all(10.0),
              children: <Widget>[
                ActionEditor(
                  Termin.emptyAction(),
                  key: Key('action creator'),
                )
              ]);
        });

    if (newActions == null) return;

    for (final action in newActions) addNewAction(action);
  }

  addNewAction(Termin action) async {
    var uuid = Uuid().v1();

    Termin terminMitId = await termineService.createTermin(action);

    Provider.of<StorageService>(context).saveActionToken(terminMitId.id, uuid);

    setState(() {
      myActions.add(terminMitId.id);
      termine
        ..add(terminMitId)
        ..sort(Termin.sortByStart());
    });
  }

  openTerminDetails(BuildContext context, Termin termin) async {
    var terminMitDetails = await termineService.getTerminMitDetails(termin.id);
    TerminDetailsCommand command = await showDialog(
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
                ActionDetailsPage(terminMitDetails),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: addEditDeleteButtonsIfMyAction(termin, context)
                    ..add(RaisedButton(
                      key: Key('close termin details button'),
                      child: Text('Schließen'),
                      onPressed: () =>
                          Navigator.pop(context, TerminDetailsCommand.CLOSE),
                    )),
                ),
              ],
            ));

    if (command == TerminDetailsCommand.DELETE) deleteAction(terminMitDetails);

    if (command == TerminDetailsCommand.EDIT)
      editAction(context, terminMitDetails);
  }

  List<Widget> addEditDeleteButtonsIfMyAction(
      Termin termin, BuildContext context) {
    if (isMyAction(termin.id))
      return [
        RaisedButton(
            key: Key('action delete button'),
            color: DweTheme.red,
            child: Icon(Icons.delete),
            onPressed: () {
              showDialog<bool>(
                      context: context,
                      builder: (context) => confirmDeleteDialog(context))
                  .then((confirmed) {
                if (confirmed)
                  Navigator.pop(context, TerminDetailsCommand.DELETE);
              });
            }),
        RaisedButton(
          key: Key('action edit button'),
          child: Icon(Icons.edit),
          onPressed: () => Navigator.pop(context, TerminDetailsCommand.EDIT),
        )
      ];
    else
      return [];
  }

  Future editAction(BuildContext context, Termin terminMitDetails) async {
    Termin newAction = await openEditDialog(context, terminMitDetails);

    setState(() {
      termine[termine.indexWhere((a) => a.id == newAction.id)] = newAction;
      termine.sort(Termin.sortByStart());
    });

    openTerminDetails(context, newAction); // recursive and I know it
  }

  Future<void> deleteAction(Termin action) async {
    try {
      await termineService.deleteAction(action);

      Provider.of<StorageService>(context).deleteActionToken(action.id);

      setState(() {
        termine.remove(termine.where((a) => a.id == action.id).first);
        myActions.remove(action.id);
      });
    } on RestFehler catch (error) {
      print((error as RestFehler).meldung);
    }
  }

  openEditDialog(BuildContext context, Termin termin) async {
    List<Termin> editedAction = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              titlePadding: EdgeInsets.zero,
              title: AppBar(
                leading: null,
                automaticallyImplyLeading: false,
                title: Text('Aktion bearbeiten',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Color.fromARGB(255, 129, 28, 98))),
              ),
              contentPadding: EdgeInsets.all(10.0),
              children: <Widget>[
                ActionEditor(
                  termin,
                  key: Key('action editor'),
                )
              ]);
        });

    if (editedAction == null) return termin;

    await termineService.saveAction(editedAction[0]);
    return editedAction[0];
  }
}

AlertDialog confirmDeleteDialog(BuildContext context) => AlertDialog(
        key: Key('deletion confirmation dialog'),
        title: Text('Termin Löschen'),
        content: Text('Möchtest du diesen Termin wirklich löschen?'),
        actions: [
          RaisedButton(
              key: Key('delete confirmation yes button'),
              color: DweTheme.red,
              child: Text('Ja'),
              onPressed: () => Navigator.pop(context, true)),
          RaisedButton(
            key: Key('delete confirmation no button'),
            child: Text('Nein'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ]);
