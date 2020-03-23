import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:uuid/uuid.dart';
import 'ActionList.dart';
import 'FilterWidget.dart';
import 'ActionDetailsPage.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title***REMOVED***) : super(key: key);
  final String title;

  @override
  TermineSeiteState createState() => TermineSeiteState();
***REMOVED***

class TermineSeiteState extends State<TermineSeite> {
  static AbstractTermineService termineService;
  static StorageService storageService;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  bool _initialized = false;

  List<Termin> termine = [];
  List<ListLocation> listLocations = [];

  FilterWidget filterWidget;

  List<int> myActions = [];

  var view;
  int navigation = 0;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) intialize(context);
    // TODO: Memory-Leak beheben

    view = [
      ActionList(termine, isMyAction, openTerminDetails,
          key: Key('action list')),
      ActionMap(
          termine: termine,
          listLocations: listLocations,
          isMyAction: isMyAction,
          openActionDetails: openTerminDetails,
          key: Key('action map')),
    ];

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
        children: <Widget>[filterWidget, Expanded(child: view[navigation])],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigation,
        onTap: (index) => setState(() => navigation = index),
        backgroundColor: DweTheme.purple,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list,
                  key: Key('list view navigation button')),
              title: Text('Liste')),
          BottomNavigationBarItem(
              icon: Icon(Icons.map, key: Key('map view navigation button')),
              title: Text('Karte'))
        ],
      ),
    );
  ***REMOVED***

  void intialize(BuildContext context) {
//    Provider.of<StorageService>(context).clearAllPreferences();

    termineService = Provider.of<AbstractTermineService>(context);
    storageService = Provider.of<StorageService>(context);
    filterWidget = FilterWidget(ladeTermine);

    storageService
        .loadAllStoredActionIds()
        .then((ids) => setState(() => myActions = ids));

    var listLocationService = Provider.of<AbstractListLocationService>(context);
    listLocationService.getActiveListLocations().then((listLocations) {
      setState(() {
        this.listLocations = listLocations;
      ***REMOVED***);
    ***REMOVED***);

    _initialized = true;
  ***REMOVED***

  void ladeTermine(TermineFilter filter) {
    termineService.ladeTermine(filter).then((termine) {
      setState(() {
        this.termine = termine..sort(Termin.compareByStart);
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***

  openCreateDialog(BuildContext context) async {
    List<Termin> newActions = await showDialog(
        context: context,
        barrierDismissible: false,
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
                  null,
                  key: Key('action creator'),
                )
              ]);
        ***REMOVED***);

    if (newActions != null) {
      newActions.forEach((action) => createNewAction(action).then((action) {
            if (action != null) setState(() => addAction(action));
          ***REMOVED***));
    ***REMOVED***
  ***REMOVED***

  Future<Termin> createNewAction(Termin action) async {
    String uuid = Uuid().v1();
    try {
      Termin terminMitId = await termineService.createTermin(action, uuid);
      storageService.saveActionToken(terminMitId.id, uuid);
      return terminMitId;
    ***REMOVED*** on RestFehler catch (error) {
      showErrorDialog('Aktion konnte nicht erstellt werden', error,
          key: Key('delete request failed dialog'));
      return null;
    ***REMOVED***
  ***REMOVED***

  void showRestError(RestFehler e) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Aktion konnte nicht angelegt werden'),
          content: SelectableText(e.message()),
          actions: <Widget>[
            RaisedButton(
              child: Text('Okay...'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ));
  ***REMOVED***

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
                      key: Key('action details close button'),
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
  ***REMOVED***

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
              ***REMOVED***);
            ***REMOVED***),
        RaisedButton(
          key: Key('action edit button'),
          child: Icon(Icons.edit),
          onPressed: () => Navigator.pop(context, TerminDetailsCommand.EDIT),
        )
      ];
    else
      return [];
  ***REMOVED***

  bool isMyAction(int id) {
    return myActions?.contains(id);
  ***REMOVED***

  Future editAction(BuildContext context, Termin terminMitDetails) async {
    Termin editedAction = await openEditDialog(context, terminMitDetails);

    if (editedAction == null) return;

    saveAction(editedAction);

    openTerminDetails(context, editedAction); // recursive and I know it
  ***REMOVED***

  Future<void> saveAction(Termin editedAction) async {
    try {
      String token = await storageService.loadActionToken(editedAction.id);
      await termineService.saveAction(editedAction, token);
      setState(() => updateAction(editedAction, false));
    ***REMOVED*** on RestFehler catch (error) {
      showErrorDialog('Aktion konnte nicht gespeichert werden', error,
          key: Key('edit request failed dialog'));
    ***REMOVED***
  ***REMOVED***

  Future<void> deleteAction(Termin action) async {
    String token = await storageService.loadActionToken(action.id);
    try {
      await termineService.deleteAction(action, token);
      storageService.deleteActionToken(action.id);
      setState(() => updateAction(action, true));
    ***REMOVED*** on RestFehler catch (error) {
      showErrorDialog('Aktion konnte nicht gelöscht werden', error,
          key: Key('delete request failed dialog'));
    ***REMOVED***
  ***REMOVED***

  updateAction(Termin updatedAction, bool remove) {
    var index =
        termine.indexWhere((Termin action) => action.id == updatedAction.id);

    if (index == -1) return;

    if (remove) {
      termine.removeAt(index);
      myActions.remove(updatedAction.id);
    ***REMOVED*** else {
      termine[index] = updatedAction;
      termine.sort(Termin.compareByStart);
    ***REMOVED***
  ***REMOVED***

  addAction(Termin newAction) {
    myActions.add(newAction.id);
    termine
      ..add(newAction)
      ..sort(Termin.compareByStart);
  ***REMOVED***

  openEditDialog(BuildContext context, Termin termin) async {
    List<Termin> editedAction = await showDialog(
        context: context,
        barrierDismissible: false,
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
        ***REMOVED***);
    if (editedAction == null) return null;
    return editedAction[0];
  ***REMOVED***

  Future showErrorDialog(String title, RestFehler error, {key: Key***REMOVED***) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              key: key,
              title: Text(title),
              content: Text(error.message()),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Okay...'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  ***REMOVED***
***REMOVED***

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
