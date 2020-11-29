import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/main.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChatMessageService.dart';
import 'package:sammel_app/shared/ChatWindow.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/user_data.dart';
import 'package:uuid/uuid.dart';
import 'ActionList.dart';
import 'FilterWidget.dart';
import 'ActionDetailsPage.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key}) : super(key: key ?? Key('action page'));

  @override
  TermineSeiteState createState() => TermineSeiteState();
}

class TermineSeiteState extends State<TermineSeite>
    with SingleTickerProviderStateMixin {
  static var filterKey = GlobalKey();
  static AbstractTermineService termineService;
  static StorageService storageService;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  static MapController mapController = MapController();
  bool _initialized = false;

  List<Termin> termine = [];
  List<ListLocation> listLocations = [];

  FilterWidget filterWidget;

  List<int> myActions = [];
  User me;

  int navigation = 0;
  AnimationController _animationController;
  Animation<Offset> _slide;
  Animation<double> _fade;
  bool swipeLeft = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _fade = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) intialize(context);
    // TODO: Memory-Leak beheben

    _slide = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(swipeLeft ? -0.5 : 0.5, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    var actionListView = ActionList(
        termine, isMyAction, iAmParticipant, openTerminDetails,
        key: Key('action list'));
    var actionMapView = ActionMap(
      key: Key('action map'),
      termine: termine,
      listLocations: listLocations,
      isMyAction: isMyAction,
      iAmParticipant: iAmParticipant,
      openActionDetails: openTerminDetails,
      mapController: mapController,
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: IndexedStack(
                  children: [actionListView, actionMapView], index: navigation),
            ),
          ),
          filterWidget,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigation,
        onTap: swithPage,
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
  }

  swithPage(index) async {
    if (index == navigation) return;
    setState(() => swipeLeft = index > navigation);
    await _animationController.forward();
    setState(() {
      navigation = index;
      swipeLeft = !swipeLeft;
    });
    await _animationController.reverse();
  }

  // funktioniert nicht im Konstruktor, weil da der BuildContext fehlt
  // und auch nicht im initState(), weil da InheritedWidgets nicht angefasst werden können
  // und didChangeDependencies() wird mehrfach aufgerufen
  void intialize(BuildContext context) {
    if (clearAllPreferences)
      Provider.of<StorageService>(context).clearAllPreferences();

    termineService = Provider.of<AbstractTermineService>(context);
    storageService = Provider.of<StorageService>(context);
    filterWidget = FilterWidget(ladeTermine, key: filterKey);

    storageService
        .loadAllStoredActionIds()
        .then((ids) => setState(() => myActions = ids));

    var listLocationService = Provider.of<AbstractListLocationService>(context);
    listLocationService.getActiveListLocations().then((listLocations) {
      setState(() {
        this.listLocations = listLocations;
      });
    });

    Provider.of<AbstractUserService>(context)
        .user
        .then((user) => setState(() => me = user));

    _initialized = true;
  }

  void ladeTermine(TermineFilter filter) {
    termineService.loadActions(filter).then((termine) {
      setState(() {
        this.termine = termine..sort(Termin.compareByStart);
      });
    }).catchError((e) => ErrorService.handleError(e));
  }

  void showRestError(RestFehler e) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Aktion konnte nicht angelegt werden'),
          content: SelectableText(e.message),
          actions: <Widget>[
            RaisedButton(
              child: Text('Okay...'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ));
  }

  openTerminDetails(BuildContext context, Termin termin) async {
    try {
      var terminMitDetails =
          await termineService.getActionWithDetails(termin.id);
      TerminDetailsCommand command = await showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: (BuildContext context, setDialogState) => SimpleDialog(
                    titlePadding: EdgeInsets.zero,
                    backgroundColor: determineColor(terminMitDetails),
                    title: AppBar(
                        leading: null,
                        automaticallyImplyLeading: false,
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(terminMitDetails.getAsset(),
                                  width: 30.0),
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
                      participant(terminMitDetails)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                    key: Key('open chat window'),
                                    child: Text('Zum Chat'),
                                    onPressed: () =>
                                        openChatWindow(terminMitDetails)),
                              ],
                            )
                          : null,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isMyAction(termin.id)
                              ? editAndDeleteButtons(termin, context)
                              : joinOrLeaveButton(
                                  terminMitDetails, setDialogState),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: []..add(RaisedButton(
                                  key: Key('action details close button'),
                                  child: Text('Schließen'),
                                  onPressed: () => Navigator.pop(
                                      context, TerminDetailsCommand.CLOSE),
                                )))
                        ],
                      ),
                    ].where((element) => element != null).toList(),
                  )));

      if (command == TerminDetailsCommand.DELETE)
        deleteAction(terminMitDetails);

      if (command == TerminDetailsCommand.EDIT)
        editAction(context, terminMitDetails);

      if (command == TerminDetailsCommand.FOCUS)
        showActionOnMap(terminMitDetails);
    } catch (e) {
      ErrorService.handleError(e);
    }
  }

  void openChatWindow(Termin termin) {
    String channel_id = '${termin.id}';
    Channel message_channel = Provider.of<ChatMessageService>(context)
        .get_simple_message_channel(channel_id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatWindow(message_channel, termin)));
  }

  Color determineColor(Termin action) {
    bool participant = action.participants.map((e) => e.id).contains(me?.id);
    bool owner = isMyAction(action.id);
    return DweTheme.actionColor(action.ende, owner, participant);
  }

  Widget editAndDeleteButtons(Termin termin, BuildContext context) {
    return Row(children: [
      SizedBox(
          width: 50.0,
          child: RaisedButton(
              key: Key('action delete button'),
              padding: EdgeInsets.all(5.0),
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
              })),
      SizedBox(width: 5.0),
      SizedBox(
          width: 50.0,
          child: RaisedButton(
            key: Key('action edit button'),
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.edit),
            onPressed: () => Navigator.pop(context, TerminDetailsCommand.EDIT),
          ))
    ]);
  }

  Widget joinOrLeaveButton(Termin terminMitDetails, Function setDialogState) {
    if (!participant(terminMitDetails))
      return RaisedButton(
          key: Key('join action button'),
          child: Text('Mitmachen'),
          onPressed: () {
            joinAction(terminMitDetails);
            setDialogState(() => terminMitDetails.participants.add(me));
          });
    else
      return RaisedButton(
          key: Key('leave action button'),
          child: Text('Absagen'),
          onPressed: () {
            leaveAction(terminMitDetails);
            setDialogState(() => terminMitDetails.participants.remove(
                terminMitDetails.participants
                    .firstWhere((u) => u.id == me.id)));
          });
  }

  bool isMyAction(int id) {
    return myActions?.contains(id);
  }

  bool iAmParticipant(List<User> participants) =>
      participants.map((e) => e.id).contains(me?.id);

  Future editAction(BuildContext context, Termin termin) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
              titlePadding: EdgeInsets.zero,
              title: AppBar(
                leading: null,
                automaticallyImplyLeading: false,
                title: Text('Deine Aktion bearbeiten',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Color.fromARGB(255, 129, 28, 98))),
              ),
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ActionEditor(
                      initAction: termin,
                      onFinish: afterActionEdit,
                      key: Key('action editor')),
                )
              ]);
        });
  }

  afterActionEdit(List<Termin> editedAction) async {
    await saveAction(editedAction[0]);
    openTerminDetails(context, editedAction[0]); // recursive and I know it
  }

  Future<void> saveAction(Termin editedAction) async {
    try {
      String token = await storageService.loadActionToken(editedAction.id);
      await termineService.saveAction(editedAction, token);
      setState(() => updateAction(editedAction, false));
    } catch (error) {
      ErrorService.handleError(error);
    }
  }

  Future<void> deleteAction(Termin action) async {
    String token = await storageService.loadActionToken(action.id);
    try {
      await termineService.deleteAction(action, token);
      storageService.deleteActionToken(action.id);
      setState(() => updateAction(action, true));
    } on RestFehler catch (error) {
      ErrorService.pushMessage(
          'Aktion konnte nicht gelöscht werden', error.message);
    }
  }

  updateAction(Termin updatedAction, bool remove) {
    var index =
        termine.indexWhere((Termin action) => action.id == updatedAction.id);

    if (index == -1) return;

    if (remove) {
      termine.removeAt(index);
      myActions.remove(updatedAction.id);
    } else {
      termine[index] = updatedAction;
      termine.sort(Termin.compareByStart);
    }
  }

  createAndAddAction(Termin action) async {
    try {
      Termin actionWithId = await createNewAction(action);
      myActions.add(actionWithId.id);
      setState(() {
        termine
          ..add(actionWithId)
          ..sort(Termin.compareByStart);
      });
    } catch (error) {
      ErrorService.handleError(error);
    }
  }

  Future<Termin> createNewAction(Termin action) async {
    String uuid = Uuid().v1();
    Termin actionWithId = await termineService.createAction(action, uuid);
    storageService.saveActionToken(actionWithId.id, uuid);
    return actionWithId;
  }

  void showActionOnMap(Termin action) {
    mapController.move(LatLng(action.latitude, action.longitude), 15.0);
    setState(() {
      navigation = 1; // change to map view
    });
  }

  Future<void> joinAction(Termin termin) async {
    Provider.of<ChatMessageService>(context)
        .get_simple_message_channel("channel:${termin.id}");
    await termineService.joinAction(termin.id);
    setState(() {
      termine.firstWhere((t) => t.id == termin.id).participants.add(me);
    });
  }

  Future<void> leaveAction(Termin termin) async {
    await termineService.leaveAction(termin.id);
    setState(() {
      var actionFromList = termine.firstWhere((t) => t.id == termin.id);
      actionFromList.participants.removeWhere((user) => user.id == me.id);
    });
  }

  participant(Termin termin) =>
      termin.participants.map((e) => e.id).contains(me?.id);
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
