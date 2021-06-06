import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/ExpandableConstrainedBox.dart';
import 'package:share/share.dart';

import 'ChatWindow.dart';

enum TerminDetailsCommand { EDIT, DELETE, EVALUATE, CLOSE, FOCUS }

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
}

// ignore: must_be_immutable
class ActionDetailsPage extends StatefulWidget {
  final Termin action;
  late final Marker marker;
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
  }

  @override
  State<StatefulWidget> createState() =>
      ActionDetailsPageState(this.isMyAction, this.iAmParticipant);
}

class ActionDetailsPageState extends State<ActionDetailsPage> {
  bool iAmParticipant;
  bool isMyAction;

  List<int> myEvaluations = [];
  User? me;

  late AbstractTermineService termineService;
  late ChatMessageService chatMessageService;
  var initialized = false;

  ActionDetailsPageState(this.isMyAction, this.iAmParticipant);

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
    }

    final color = CampaignTheme.actionColor(
        widget.action.ende, isMyAction, this.iAmParticipant);

    PopupMenuButton menu =
        menuButton(widget.action, isMyAction, iAmParticipant);

    Locale? locale;
    try {
      locale = context.locale;
    } catch (_) {
      print('Konnte Locale nicht ermitteln');
    }

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
                                      color: CampaignTheme.secondary,
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
                          widget.action.details!.beschreibung,
                          // onTap: () => {},
                          // TODO: SelectableText stiehlt ExpandableContraintBox den onTap
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        maxHeight: 105.0,
                        expandableCondition:
                            widget.action.details!.beschreibung.length > 200,
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
                          widget.action.details!.kontakt,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        maxHeight: 105.0,
                        expandableCondition:
                            widget.action.details!.kontakt.length > 200,
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
                            tr('{kiez} in {bezirk}\n Treffpunkt: {treffpunkt}',
                                namedArgs: {
                                  'kiez': widget.action.ort.name,
                                  'bezirk': widget.action.ort.ortsteil,
                                  'treffpunkt':
                                      widget.action.details!.treffpunkt,
                                }),
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        maxHeight: 80,
                        expandableCondition:
                            widget.action.details!.treffpunkt.length > 70,
                      ),
                    ]))
              ]),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 150.0,
                width: 250.0,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: CampaignTheme.secondary, width: 1.0)),
                child: FlutterMap(
                  key: Key('action details map'),
                  options: MapOptions(
                      center: LatLng(
                          widget.action.latitude, widget.action.longitude),
                      zoom: 15,
                      interactiveFlags: InteractiveFlag.none,
                      onTap: (_) {
                        return Navigator.pop(
                            context, TerminDetailsCommand.FOCUS);
                      }),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    MarkerLayerOptions(markers: [widget.marker]),
                  ],
                ),
              ),
            ])),
        persistentFooterButtons: determineActionButton()
          ..add(SizedBox(
              child: ElevatedButton(
            key: Key('action details close button'),
            child: Text('Schließen').tr(),
            onPressed: () => Navigator.pop(context, TerminDetailsCommand.CLOSE),
          ))));
  }

  PopupMenuButton menuButton(
      Termin action, bool isMyAction, bool iAmParticipant) {
    final List<PopupMenuItem> items = [];

    if (!isMyAction && !iAmParticipant && !isPastAction(action))
      items.add(PopupMenuItem(
          key: Key('action details join menu item'),
          child: Row(children: [
            Icon(Icons.assignment_turned_in_outlined),
            SizedBox(width: 8),
            Text('Mitmachen', textScaleFactor: 0.8).tr()
          ]),
          value: 'Mitmachen'));

    if (!isMyAction && iAmParticipant)
      items.add(PopupMenuItem(
          key: Key('action details menu leave item'),
          child: Row(children: [
            Icon(Icons.assignment_return_outlined),
            SizedBox(width: 8),
            Text('Verlassen', textScaleFactor: 0.8).tr()
          ]),
          value: 'Verlassen'));

    if (iAmParticipant)
      items.add(PopupMenuItem(
          key: Key('action details calendar menu item'),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined),
              SizedBox(width: 8),
              Text('In den Kalender', textScaleFactor: 0.8).tr()
            ],
          ),
          value: 'In den Kalender'));

    if (iAmParticipant)
      items.add(PopupMenuItem(
          key: Key('action details share menu item'),
          child: Row(
            children: [
              Icon(Icons.share),
              SizedBox(width: 8),
              Text('Teilen', textScaleFactor: 0.8).tr()
            ],
          ),
          value: 'Teilen'));

    if (iAmParticipant)
      items.add(PopupMenuItem(
          key: Key('action details chat menu item'),
          child: Row(children: [
            Icon(Icons.message_outlined),
            SizedBox(width: 8),
            Text('Zum Chat', textScaleFactor: 0.8).tr()
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
            Text('Feedback', textScaleFactor: 0.8).tr()
          ]),
          value: 'Feedback'));

    if (isMyAction) {
      items.add(PopupMenuItem(
          key: Key('action details edit menu item'),
          child: Row(children: [
            Icon(Icons.edit),
            SizedBox(width: 8),
            Text('Bearbeiten', textScaleFactor: 0.8).tr()
          ]),
          value: 'Bearbeiten'));
      items.add(PopupMenuItem(
          key: Key('action details delete menu item'),
          child: Row(children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 8),
            Text('Löschen',
                    textScaleFactor: 0.8, style: TextStyle(color: Colors.red))
                .tr()
          ]),
          value: 'Löschen'));
    }

    return PopupMenuButton(
        key: Key('action details menu button'),
        color: CampaignTheme.primaryLight,
        itemBuilder: (BuildContext context) => items,
        onSelected: (command) {
          if (command == 'Mitmachen') joinAction();
          if (command == 'Verlassen') leaveAction();
          if (command == 'In den Kalender') calendarAction();
          if (command == 'Teilen') shareAction();
          if (command == 'Zum Chat') openChatWindow()();
          if (command == 'Feedback') evaluateAction();
          if (command == 'Bearbeiten') editAction();
          if (command == 'Löschen') deleteAction();
        });
  }

  openChatWindow() async {
    ChatChannel messageChannel =
        await chatMessageService.getActionChannel(widget.action.id!);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChatWindow(messageChannel, widget.action, true)));
  }

  List<Widget> determineActionButton() {
    if (isPastAction(widget.action) &&
        iAmParticipant &&
        !widget.action.isEvaluated(myEvaluations))
      return [
        ElevatedButton(
            key: Key('action evaluate button'),
            child: Text('Feedback'),
            onPressed: () => evaluateAction())
      ];

    if (iAmParticipant)
      return [
        ElevatedButton(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(CampaignTheme.primary)),
            key: Key('open chat window'),
            child: Row(children: [
              Icon(Icons.message, size: 20),
              SizedBox(width: 10),
              Text('Zum Chat').tr()
            ]),
            onPressed: () => openChatWindow())
      ];

    if (!isPastAction(widget.action))
      return [
        ElevatedButton(
            key: Key('join action button'),
            child: Text('Mitmachen').tr(),
            onPressed: () => joinAction())
      ];

    // default
    return [];
  }

  void joinAction() {
    widget.joinAction(widget.action);
    if (me == null) return;
    setState(() {
      (widget.action.participants ?? []).add(me!);
      iAmParticipant = true;
    });
  }

  void leaveAction() {
    widget.leaveAction(widget.action);
    setState(() {
      widget.action.participants?.remove(
          widget.action.participants?.firstWhere((u) => u.id == me?.id));
      iAmParticipant = false;
    });
  }

  void calendarAction() {
    final Event event = Event(
        title: '{typ} in {ortsteil}'.tr(namedArgs: {
          'typ': widget.action.typ.tr(),
          'ortsteil': widget.action.ort.ortsteil
        }),
        description: widget.action.details!.beschreibung,
        location: widget.action.details!.treffpunkt,
        startDate: widget.action.beginn,
        endDate: widget.action.ende);
    Add2Calendar.addEvent2Cal(event);
  }

  void shareAction() {
    Share.share('{typ} in {ortsteil}, {treffpunkt} am {zeitpunkt}\n{url}'
        .tr(namedArgs: {
      'typ': widget.action.typ.tr(),
      'ortsteil': widget.action.ort.ortsteil,
      'treffpunkt': widget.action.details!.treffpunkt,
      'zeitpunkt': ''
          '${DateFormat.MMMd(Localizations.localeOf(context).languageCode).format(widget.action.beginn)},'
          '${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.action.beginn)}',
      'url': 'www.dwenteignen.de/die-sammel-app?aktion=${widget.action.id}'
    }));
  }

  void evaluateAction() =>
      Navigator.pop(context, TerminDetailsCommand.EVALUATE);

  void editAction() => Navigator.pop(context, TerminDetailsCommand.EDIT);

  void deleteAction() => showDialog<bool>(
          context: context,
          builder: (context) => confirmDeleteDialog(context)).then((confirmed) {
        if (confirmed == true)
          Navigator.pop(context, TerminDetailsCommand.DELETE);
      });
}
