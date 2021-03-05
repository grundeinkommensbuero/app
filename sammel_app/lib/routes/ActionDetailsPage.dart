import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/ExpandableConstrainedBox.dart';

import 'ChatWindow.dart';

enum TerminDetailsCommand { EDIT, DELETE, EVALUATE, CLOSE, FOCUS ***REMOVED***

Future<TerminDetailsCommand> showActionDetailsPage(
    BuildContext context,
    Termin action,
    bool isMyAction,
    bool iAmParticipant,
    Function(Termin) joinAction,
    Function(Termin) leaveAction) async {
  return await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, setDialogState) => Dialog(
              key: Key('termin details dialog'),
              child: ActionDetailsPage(action, isMyAction, iAmParticipant,
                  joinAction, leaveAction))));
***REMOVED***

// ignore: must_be_immutable
class ActionDetailsPage extends StatefulWidget {
  final Termin action;
  Marker marker;
  final bool isMyAction;
  final bool iAmParticipant;

  final Function(Termin) joinAction;
  final Function(Termin) leaveAction;

  ActionDetailsPage(this.action, this.isMyAction, this.iAmParticipant,
      this.joinAction, this.leaveAction) {
    marker = Marker(
        anchorPos: AnchorPos.align(AnchorAlign.top),
        point: LatLng(action.latitude, action.longitude),
        builder: (context) => Icon(
              Icons.location_on,
              key: Key('action details map marker'),
              size: 30,
            ));
  ***REMOVED***

  @override
  State<StatefulWidget> createState() =>
      ActionDetailsPageState(this.isMyAction, this.iAmParticipant);
***REMOVED***

class ActionDetailsPageState extends State<ActionDetailsPage> {
  bool iAmParticipant;
  bool isMyAction;

  ActionDetailsPageState(this.isMyAction, this.iAmParticipant);

  List<int> myEvaluations = [];
  User me;

  AbstractTermineService termineService;
  ChatMessageService chatMessageService;
  var initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      termineService = Provider.of<AbstractTermineService>(context);
      chatMessageService = Provider.of<ChatMessageService>(context);
      Provider.of<StorageService>(context)
          .loadAllStoredEvaluations()
          .then((evaluations) => setState(() => myEvaluations = evaluations));
      Provider.of<AbstractUserService>(context)
          .user
          .listen((user) => setState(() => me = user));
      initialized = true;
    ***REMOVED***

    final color = DweTheme.actionColor(
        widget.action.ende, isMyAction, this.iAmParticipant);

    PopupMenuButton menu =
        menuButton(widget.action, isMyAction, iAmParticipant);

    Locale locale;
    try {
      locale = context.locale;
    ***REMOVED*** catch (_) {
      print('Konnte Locale nicht ermitteln');
    ***REMOVED***

    return Scaffold(
        backgroundColor: color,
        appBar: AppBar(
            leading: null,
            automaticallyImplyLeading: false,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Image.asset(widget.action.getAsset(), width: 30.0),
              Container(width: 10.0),
              Expanded(
                  child: Text(widget.action.typ,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Color.fromARGB(255, 129, 28, 98)))
                      .tr()),
            ]),
            actions: [menu]),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(key: Key('action details page'), children: [
              // Time
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
                      SelectableText(
                          ChronoHelfer.formatDateOfDateTimeMitWochentag(
                              widget.action.beginn, locale)),
                      SelectableText(ChronoHelfer.formatFromToTimeOfDateTimes(
                          widget.action.beginn, widget.action.ende)),
                      isPastAction(widget.action)
                          ? Text('diese Aktion ist beendet',
                                  style: TextStyle(
                                      color: DweTheme.purple,
                                      fontWeight: FontWeight.bold))
                              .tr()
                          : SizedBox()
                    ]))
              ]),
              SizedBox(
                height: 10.0,
              ),

              // Description
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
                      ExpandableConstrainedBox(
                        child: SelectableText(
                          widget.action.details.beschreibung,
                          // onTap: () => {***REMOVED***,
                          // TODO: SelectableText stiehlt ExpandableContraintBox den onTap
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        maxHeight: 105.0,
                        expandableCondition:
                            widget.action.details.beschreibung.length > 200,
                      )
                    ]))
              ]),
              SizedBox(
                height: 10.0,
              ),

              // Contact
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
                      ExpandableConstrainedBox(
                        child: SelectableText(
                          widget.action.details.kontakt,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        maxHeight: 105.0,
                        expandableCondition:
                            widget.action.details.kontakt.length > 200,
                      )
                    ]))
              ]),

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
                      ExpandableConstrainedBox(
                        child: SelectableText(
                            tr('{kiez***REMOVED*** in {bezirk***REMOVED***\n Treffpunkt: {treffpunkt***REMOVED***',
                                namedArgs: {
                                  'kiez': widget.action.ort.name,
                                  'bezirk': widget.action.ort.ortsteil,
                                  'treffpunkt':
                                      widget.action.details.treffpunkt,
                                ***REMOVED***),
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        maxHeight: 80,
                        expandableCondition:
                            widget.action.details.treffpunkt.length > 70,
                      ),
                    ]))
              ]),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                child: Container(
                  height: 150.0,
                  width: 250.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: DweTheme.purple, width: 1.0)),
                  child: FlutterMap(
                    key: Key('action details map'),
                    options: MapOptions(
                      center: LatLng(
                          widget.action.latitude, widget.action.longitude),
                      zoom: 15,
                      interactive: false,
                    ),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              "https://{s***REMOVED***.tile.openstreetmap.de/{z***REMOVED***/{x***REMOVED***/{y***REMOVED***.png",
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(markers: [widget.marker]),
                    ],
                  ),
                ),
                onTap: () => Navigator.pop(context, TerminDetailsCommand.FOCUS),
              ),
            ])),
        persistentFooterButtons: [
          determineActionButton(),
          SizedBox(
              child: RaisedButton(
            key: Key('action details close button'),
            padding: EdgeInsets.all(8.0),
            child: Text('Schließen').tr(),
            onPressed: () => Navigator.pop(context, TerminDetailsCommand.CLOSE),
          ))
        ]);
  ***REMOVED***

  PopupMenuButton menuButton(
      Termin action, bool isMyAction, bool iAmParticipant) {
    final List<PopupMenuItem> items = [];

    if (!isMyAction && !iAmParticipant && !isPastAction(action))
      items.add(PopupMenuItem(
          key: Key('action details join menu item'),
          child: Row(children: [
            Icon(Icons.assignment_turned_in_outlined),
            SizedBox(width: 8),
            Text('Mitmachen').tr()
          ]),
          value: 'Mitmachen'));

    if (!isMyAction && iAmParticipant)
      items.add(PopupMenuItem(
          key: Key('action details menu leave item'),
          child: Row(children: [
            Icon(Icons.assignment_return_outlined),
            SizedBox(width: 8),
            Text('Verlassen').tr()
          ]),
          value: 'Verlassen'));

    if (iAmParticipant)
      items.add(PopupMenuItem(
          key: Key('action details chat menu item'),
          child: Row(children: [
            Icon(Icons.message_outlined),
            SizedBox(width: 8),
            Text('Zum Chat').tr()
          ]),
          value: 'Zum Chat'));

    if (isPastAction(action) &&
        iAmParticipant &&
        !action.isEvaluated(myEvaluations))
      items.add(PopupMenuItem(
          key: Key('action details feedback menu item'),
          child: Row(children: [
            Icon(Icons.rss_feed_outlined),
            SizedBox(width: 8),
            Text('Feedback').tr()
          ]),
          value: 'Feedback'));

    if (isMyAction) {
      items.add(PopupMenuItem(
          key: Key('action details edit menu item'),
          child: Row(children: [
            Icon(Icons.edit),
            SizedBox(width: 8),
            Text('Bearbeiten').tr()
          ]),
          value: 'Bearbeiten'));
      items.add(PopupMenuItem(
          key: Key('action details delete menu item'),
          child: Row(children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 8),
            Text('Löschen', style: TextStyle(color: Colors.red)).tr()
          ]),
          value: 'Löschen'));
    ***REMOVED***

    return PopupMenuButton(
        key: Key('action details menu button'),
        color: DweTheme.yellowLight,
        itemBuilder: (BuildContext context) => items,
        onSelected: (command) {
          if (command == 'Mitmachen') joinAction();
          if (command == 'Verlassen') leaveAction();
          if (command == 'Zum Chat') openChatWindow()();
          if (command == 'Feedback') evaluateAction();
          if (command == 'Bearbeiten') editAction();
          if (command == 'Löschen') deleteAction();
        ***REMOVED***);
  ***REMOVED***

  openChatWindow() async {
    ChatChannel message_channel =
        await chatMessageService.getActionChannel(widget.action.id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChatWindow(message_channel, widget.action, true)));
  ***REMOVED***

  SizedBox editButton() {
    return SizedBox(
        width: 50.0,
        child: RaisedButton(
          key: Key('action edit button'),
          padding: EdgeInsets.all(5.0),
          child: Icon(Icons.edit),
          onPressed: () => editAction(),
        ));
  ***REMOVED***

  SizedBox deleteButton() {
    return SizedBox(
        width: 50.0,
        child: RaisedButton(
            key: Key('action delete button'),
            padding: EdgeInsets.all(5.0),
            color: DweTheme.red,
            child: Icon(Icons.delete),
            onPressed: () => deleteAction()));
  ***REMOVED***

  Widget leaveButton(Termin terminMitDetails) => RaisedButton(
      key: Key('leave action button'),
      child: Text('Verlassen').tr(),
      onPressed: () => leaveAction());

  Widget determineActionButton() {
    if (isPastAction(widget.action) &&
        iAmParticipant &&
        !widget.action.isEvaluated(myEvaluations))
      return RaisedButton(
          key: Key('action evaluate button'),
          padding: EdgeInsets.all(8.0),
          color: DweTheme.purple,
          child: Text('Feedback'),
          onPressed: () => evaluateAction());

    if (iAmParticipant)
      return RaisedButton(
          textColor: DweTheme.yellow,
          padding: EdgeInsets.all(8.0),
          key: Key('open chat window'),
          child: Row(children: [
            Icon(Icons.message, size: 20),
            SizedBox(width: 10),
            Text('Zum Chat').tr()
          ]),
          onPressed: () => openChatWindow());

    if (!isPastAction(widget.action))
      return RaisedButton(
          key: Key('join action button'),
          padding: EdgeInsets.all(8.0),
          child: Text('Mitmachen').tr(),
          onPressed: () => joinAction());
  ***REMOVED***

  void joinAction() {
    widget.joinAction(widget.action);
    setState(() {
      widget.action.participants.add(me);
      iAmParticipant = true;
    ***REMOVED***);
  ***REMOVED***

  void leaveAction() {
    widget.leaveAction(widget.action);
    setState(() {
      widget.action.participants
          .remove(widget.action.participants.firstWhere((u) => u.id == me?.id));
      iAmParticipant = false;
    ***REMOVED***);
  ***REMOVED***

  void evaluateAction() =>
      Navigator.pop(context, TerminDetailsCommand.EVALUATE);

  void editAction() => Navigator.pop(context, TerminDetailsCommand.EDIT);

  void deleteAction() => showDialog<bool>(
          context: context,
          builder: (context) => confirmDeleteDialog(context)).then((confirmed) {
        if (confirmed) Navigator.pop(context, TerminDetailsCommand.DELETE);
      ***REMOVED***);
***REMOVED***
