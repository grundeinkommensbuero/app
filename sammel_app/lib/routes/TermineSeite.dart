import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Evaluation.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/ActionMap.dart';
import 'package:sammel_app/routes/EvaluationForm.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/RestFehler.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:uuid/uuid.dart';

import 'ActionDetailsPage.dart';
import 'ActionEditor.dart';
import 'ActionList.dart';
import 'ActionMap.dart';
import 'FilterWidget.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key? key***REMOVED***) : super(key: key ?? Key('action page'));

  @override
  TermineSeiteState createState() => TermineSeiteState();
***REMOVED***

class TermineSeiteState extends State<TermineSeite>
    with SingleTickerProviderStateMixin {
  static var filterKey = GlobalKey();
  AbstractTermineService? termineService;
  StorageService? storageService;
  ChatMessageService? chatMessageService;
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  final MapController mapController = MapController();
  bool _initialized = false;

  List<Termin> termine = [];
  List<ListLocation> listLocations = [];

  FilterWidget? filterWidget;

  List<int> myActions = [];
  User? me;

  int navigation = 0;
  late AnimationController _animationController;
  Animation<Offset>? _slide;
  Animation<double>? _fade;
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
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    if (!_initialized) intialize(context);

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

    return ScaffoldMessenger(
        // um Snackbar oberhalb der Footer-Buttons zu zeigen
        child: Scaffold(
      body: Container(
          decoration: CampaignTheme.background,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              FadeTransition(
                opacity: _fade!,
                child: SlideTransition(
                  position: _slide!,
                  child: IndexedStack(
                      children: [actionListView, actionMapView],
                      index: navigation),
                ),
              ),
              filterWidget!
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigation,
        onTap: swithPage,
        backgroundColor: CampaignTheme.secondary,
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
    ));
  ***REMOVED***

  swithPage(index) async {
    if (index == navigation) return;
    setState(() => swipeLeft = index > navigation);
    await _animationController.forward();
    setState(() {
      navigation = index;
      swipeLeft = !swipeLeft;
    ***REMOVED***);
    await _animationController.reverse();
  ***REMOVED***

  // funktioniert nicht im Konstruktor, weil da der BuildContext fehlt
  // und auch nicht im initState(), weil da InheritedWidgets nicht angefasst werden können
  // und didChangeDependencies() wird mehrfach aufgerufen
  void intialize(BuildContext context) {
    termineService = Provider.of<AbstractTermineService>(context);
    storageService = Provider.of<StorageService>(context);
    chatMessageService = Provider.of<ChatMessageService>(context);
    filterWidget = FilterWidget(ladeTermine, key: filterKey);

    storageService!
        .loadAllStoredActionIds()
        .then((ids) => setState(() => myActions = ids));

    var listLocationService = Provider.of<AbstractListLocationService>(context);
    listLocationService.getActiveListLocations().then((listLocations) {
      setState(() {
        this.listLocations = listLocations;
      ***REMOVED***);
    ***REMOVED***);

    Provider.of<AbstractUserService>(context)
        .user
        .listen((user) => setState(() => me = user));

    _initialized = true;
  ***REMOVED***

  Future<void> ladeTermine(TermineFilter filter) async {
    await termineService!
        .loadActions(filter)
        .then((termine) =>
            setState(() => this.termine = termine..sort(Termin.compareByStart)))
        .catchError((e, s) => ErrorService.handleError(e, s,
            context: 'Aktionen konnten nicht geladen werden.'));
  ***REMOVED***

  void showRestError(RestFehler e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Aktion konnte nicht angelegt werden').tr(),
              content: SelectableText(e.message),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Okay...').tr(),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  ***REMOVED***

  openTerminDetails(Termin termin) async {
    if (termin.id == null) return;
    try {
      var terminMitDetails =
          await termineService!.getActionWithDetails(termin.id!);
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
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht geladen werden.');
    ***REMOVED***
  ***REMOVED***

  bool isMyAction(Termin action) => myActions.contains(action.id);

  bool iAmParticipant(Termin action) =>
      action.participants?.map((e) => e.id).contains(me?.id) ?? false;

  editAction(BuildContext context, Termin termin) async {
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
        ***REMOVED***);
  ***REMOVED***

  afterActionEdit(List<Termin> editedAction) async {
    await saveAction(editedAction[0]);
    openTerminDetails(editedAction[0]); // recursive and I know it
  ***REMOVED***

  Future<void> saveAction(Termin editedAction) async {
    try {
      String? token = await storageService!.loadActionToken(editedAction.id!);
      if (token == null) throw Exception('Fehlende Authorisierung zu Aktion');
      await termineService!.saveAction(editedAction, token);
      setState(() => updateAction(editedAction, false));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht gespeichert werden.');
    ***REMOVED***
  ***REMOVED***

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
                            color: Color.fromARGB(255, 129, 28, 98)))
                    .tr(),
              ),
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: EvaluationForm(termin,
                        onFinish: afterActionEvaluation,
                        key: Key('evaluation editor')))
              ]);
        ***REMOVED***);
  ***REMOVED***

  afterActionEvaluation(Evaluation evaluation) async {
    Navigator.pop(context, false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Vielen Dank, dass Du Eure Erfahrungen geteilt hast.'.tr(),
          style: TextStyle(color: Colors.black87)),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      backgroundColor: Color.fromARGB(220, 255, 255, 250),
    ));
    await saveEvaluation(evaluation);
  ***REMOVED***

  Future<void> saveEvaluation(Evaluation evaluation) async {
    try {
      await termineService?.saveEvaluation(evaluation);
      await storageService?.markActionIdAsEvaluated(evaluation.terminId!);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Evaluation konnte nicht gespeichert werden.');
    ***REMOVED***
    return;
  ***REMOVED***

  Future<void> deleteAction(Termin action) async {
    if (action.id == null) return;
    String? token = await storageService!.loadActionToken(action.id!);
    try {
      if (token == null) throw Exception('Fehlende Authorisierung zu Aktion');
      await termineService?.deleteAction(action, token);
      storageService!.deleteActionToken(action.id!);
      setState(() => updateAction(action, true));
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht gelöscht werden.');
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

  createAndAddAction(Termin action) async {
    try {
      Termin actionWithId = await createNewAction(action);
      myActions.add(actionWithId.id!);
      setState(() {
        termine
          ..add(actionWithId)
          ..sort(Termin.compareByStart);
      ***REMOVED***);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Aktion konnte nicht erzeugt werden.');
    ***REMOVED***
  ***REMOVED***

  Future<Termin> createNewAction(Termin action) async {
    String uuid = Uuid().v1();
    Termin actionWithId = await termineService!.createAction(action, uuid);
    storageService?.saveActionToken(actionWithId.id!, uuid);
    return actionWithId;
  ***REMOVED***

  void showActionOnMap(Termin action) {
    setState(() => navigation = 1);
    mapController.move(LatLng(action.latitude, action.longitude), 15.0);
  ***REMOVED***

  Future<void> joinAction(Termin action) async {
    if (action.id == null || me == null) return;
    await termineService?.joinAction(action.id!);
    setState(() {
      // ignore: unnecessary_cast
      (termine as List<Termin?>)
          .firstWhere((t) => t!.id == action.id, orElse: () => null)
          ?.participants
          ?.add(me!);
    ***REMOVED***);
  ***REMOVED***

  Future<void> leaveAction(Termin action) async {
    if (action.id == null || me == null) return;
    await termineService?.leaveAction(action.id!);
    setState(() {
      var actionFromList = termine.firstWhere((t) => t.id == action.id);
      actionFromList.participants?.removeWhere((user) => user.id == me!.id);
    ***REMOVED***);
  ***REMOVED***

  bool participant(Termin termin) =>
      termin.participants?.map((e) => e.id).contains(me?.id) ?? false;

  void zeigeAktionen(String title, List<Termin> actions) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: Text(title)),
                body: ActionList(actions, isMyAction, isPastAction,
                    iAmParticipant, openTerminDetails))));
  ***REMOVED***
***REMOVED***

class ButtonRow extends StatelessWidget {
  final List<Widget> widgets;

  ButtonRow(this.widgets);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: widgets
            .expand((widget) => [SizedBox(width: 5.0), widget])
            .skip(1)
            .toList());
  ***REMOVED***
***REMOVED***

AlertDialog confirmDeleteDialog(BuildContext context) => AlertDialog(
        key: Key('deletion confirmation dialog'),
        title: Text('Aktion Löschen').tr(),
        content: Text('Möchtest du diese Aktion wirklich löschen?').tr(),
        actions: [
          ElevatedButton(
              key: Key('delete confirmation yes button'),
              style: ButtonStyle(backgroundColor: CampaignTheme.red),
              child: Text('Ja').tr(),
              onPressed: () => Navigator.pop(context, true)),
          ElevatedButton(
            key: Key('delete confirmation no button'),
            child: Text('Nein').tr(),
            onPressed: () => Navigator.pop(context, false),
          ),
        ]);

bool isPastAction(Termin action) => action.ende.isBefore(DateTime.now());
