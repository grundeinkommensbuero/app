import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/EvaluationForm.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/Evaluation.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'ActionEditor.dart';
import 'ActionMap.dart';
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
  AbstractTermineService termineService;
  StorageService storageService;
  ChatMessageService chatMessageService;
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

    var actionListView = Column(children: [
      Expanded(
          child: ActionList(termine, isMyAction, isPastAction, iAmParticipant,
              openTerminDetails,
              key: Key('action list')))
    ]);
    var actionMapView = ActionMap(
      key: Key('action map'),
      termine: termine,
      listLocations: listLocations,
      isMyAction: isMyAction,
      isPastAction: isPastAction,
      iAmParticipant: iAmParticipant,
      openActionDetails: openTerminDetails,
      mapController: mapController,
    );

    return Scaffold(
      body: Container(
          decoration: DweTheme.happyHouseBackground,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: IndexedStack(
                      children: [actionListView, actionMapView],
                      index: navigation),
                ),
              ),
              filterWidget
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigation,
        onTap: swithPage,
        backgroundColor: DweTheme.purple,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list,
                  key: Key('list view navigation button')),
              label: 'Liste'.tr()),
          BottomNavigationBarItem(
              icon: Icon(Icons.map, key: Key('map view navigation button')),
              label: 'Karte'.tr())
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
    termineService = Provider.of<AbstractTermineService>(context);
    storageService = Provider.of<StorageService>(context);
    chatMessageService = Provider.of<ChatMessageService>(context);
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
        .listen((user) => setState(() => me = user));

    _initialized = true;
  }

  Future<void> ladeTermine(TermineFilter filter) async {
    await termineService
        .loadActions(filter)
        .then((termine) =>
            setState(() => this.termine = termine..sort(Termin.compareByStart)))
        .catchError((e, s) => ErrorService.handleError(e, s,
            context: 'Aktionen konnten nicht geladen werden.'));
  }

  void showRestError(RestFehler e) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Aktion konnte nicht angelegt werden').tr(),
          content: SelectableText(e.message),
          actions: <Widget>[
            RaisedButton(
              child: Text('Okay...').tr(),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ));
  }

  openTerminDetails(Termin termin) async {
    try {
      var terminMitDetails =
          await termineService.getActionWithDetails(termin.id);
      TerminDetailsCommand command = await showActionDetailsPage(
          context,
          terminMitDetails,
          isMyAction(termin),
          participant(termin),
          joinAction,
          leaveAction);

      if (command == TerminDetailsCommand.DELETE)
        deleteAction(terminMitDetails);

      if (command == TerminDetailsCommand.EDIT)
        editAction(context, terminMitDetails);

      if (command == TerminDetailsCommand.EVALUATE)
        evaluateAction(context, terminMitDetails);

      if (command == TerminDetailsCommand.FOCUS)
        showActionOnMap(terminMitDetails);
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht geladen werden.');
    }
  }

  bool isMyAction(Termin action) => myActions?.contains(action.id);

  bool iAmParticipant(Termin action) =>
      action.participants.map((e) => e.id).contains(me?.id);

  Future<List<Termin>> editAction(BuildContext context, Termin termin) async {
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
                            color: Color.fromARGB(255, 129, 28, 98)))
                    .tr(),
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
    openTerminDetails(editedAction[0]); // recursive and I know it
  }

  Future<void> saveAction(Termin editedAction) async {
    try {
      String token = await storageService.loadActionToken(editedAction.id);
      await termineService.saveAction(editedAction, token);
      setState(() => updateAction(editedAction, false));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht gespeichert werden.');
    }
  }

  Future evaluateAction(BuildContext context, Termin termin) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
              titlePadding: EdgeInsets.zero,
              title: AppBar(
                leading: null,
                automaticallyImplyLeading: false,
                title: Text('Über Aktion berichten',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Color.fromARGB(255, 129, 28, 98))).tr(),
              ),
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: EvaluationForm(termin,
                        onFinish: afterActionEvaluation,
                        key: Key('evaluation editor')))
              ]);
        });
  }

  afterActionEvaluation(Evaluation evaluation) async {
    Navigator.pop(context, false);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Vielen Dank, dass Du Eure Erfahrungen geteilt hast.'.tr(),
          style: TextStyle(color: Colors.black87)),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      backgroundColor: Color.fromARGB(220, 255, 255, 250),
    ));
    await saveEvaluation(evaluation);
  }

  Future<void> saveEvaluation(Evaluation evaluation) async {
    try {
      await termineService.saveEvaluation(evaluation);
      await storageService.markActionIdAsEvaluated(evaluation.terminId);
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Evaluation konnte nicht gespeichert werden.');
    }
    return;
  }

  Future<void> deleteAction(Termin action) async {
    String token = await storageService.loadActionToken(action.id);
    try {
      await termineService.deleteAction(action, token);
      storageService.deleteActionToken(action.id);
      setState(() => updateAction(action, true));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht gelöscht werden.');
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
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht erzeugt werden.');
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
    await termineService.joinAction(termin.id);
    setState(() {
      termine
          .firstWhere((t) => t.id == termin.id, orElse: () => null)
          ?.participants
          ?.add(me);
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

  void zeigeAktionen(String title, List<Termin> actions) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: Text(title)),
                body: ActionList(actions, isMyAction, isPastAction,
                    iAmParticipant, openTerminDetails))));
  }
}

class ButtonRow extends StatelessWidget {
  List<Widget> widgets;

  ButtonRow(List<Widget> this.widgets);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: widgets
            .expand((widget) => [SizedBox(width: 5.0), widget])
            .skip(1)
            .toList());
  }
}

AlertDialog confirmDeleteDialog(BuildContext context) => AlertDialog(
        key: Key('deletion confirmation dialog'),
        title: Text('Aktion Löschen').tr(),
        content: Text('Möchtest du diese Aktion wirklich löschen?').tr(),
        actions: [
          RaisedButton(
              key: Key('delete confirmation yes button'),
              color: DweTheme.red,
              child: Text('Ja').tr(),
              onPressed: () => Navigator.pop(context, true)),
          RaisedButton(
            key: Key('delete confirmation no button'),
            child: Text('Nein').tr(),
            onPressed: () => Navigator.pop(context, false),
          ),
        ]);

bool isPastAction(Termin action) => action.ende.isBefore(DateTime.now());
