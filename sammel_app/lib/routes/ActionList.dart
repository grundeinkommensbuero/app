import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'TerminCard.dart';

class ActionList extends StatefulWidget {
  final List<Termin> termine;
  final Function(Termin) openActionDetails;
  final Function(Termin) isMyAction;
  final Function(Termin) iAmParticipant;
  final Function(Termin) isPastAction;

  ActionList(this.termine, this.isMyAction, this.isPastAction,
      this.iAmParticipant, this.openActionDetails,
      {Key? key***REMOVED***)
      : super(key: key);

  @override
  ActionListState createState() => ActionListState();
***REMOVED***

class ActionListState extends State<ActionList> {
  ItemScrollController _scrollController = ItemScrollController();

  Timer? snackbarTimer;

  List<int>? evaluations;

  @override
  Widget build(BuildContext context) {
    if (snackbarTimer == null) maybeShowEvaluationSnackBar(context);
    var indexOfNow = getIndexOfNow();

    var scrollableList = ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: widget.termine.length,
        itemBuilder: cardListBuilder,
        initialScrollIndex: indexOfNow);
    if (indexOfNow > 0 && _scrollController.isAttached) {
      Timer(
          Duration(milliseconds: 100),
          () => _scrollController.scrollTo(
              index: indexOfNow,
              alignment: 0,
              curve: Curves.easeOutCubic,
              duration: Duration(milliseconds: indexOfNow * 75)));
    ***REMOVED***
    return scrollableList;
  ***REMOVED***

  void maybeShowEvaluationSnackBar(BuildContext context) async {
    evaluations ??=
        await Provider.of<StorageService>(context).loadAllStoredEvaluations();

    for (Termin termin in widget.termine) {
      if (widget.isPastAction(termin) &&
          widget.iAmParticipant(termin) &&
          !termin.isEvaluated(evaluations!)) {
        snackbarTimer = Timer(
            Duration(seconds: 2),
            () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Dein Bericht zu einer Aktion fehlt noch'.tr(),
                    style: TextStyle(color: Colors.black87)),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 7),
                backgroundColor: Color.fromARGB(220, 255, 255, 250),
                action: SnackBarAction(
                    label: 'Zur Aktion'.tr(),
                    onPressed: () => widget.openActionDetails(termin)))));
        break;
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  int getIndexOfNow() {
    var now = DateTime.now();
    for (int index = 0; index < widget.termine.length; index++) {
      if ((widget.termine[index].beginn.isBefore(now)) &&
          (index == widget.termine.length - 1 ||
              widget.termine[index + 1].beginn.isAfter(now))) {
        if (index > widget.termine.length - 5)
          return (widget.termine.length > 5 ? widget.termine.length - 5 : 0);
        else
          return index;
      ***REMOVED***
    ***REMOVED***
    return 0;
  ***REMOVED***

  Widget cardListBuilder(context, index) {
    Widget tile = ListTile(
        title: TerminCard(
            widget.termine[index],
            widget.isMyAction(widget.termine[index]),
            widget.iAmParticipant(widget.termine[index]),
            Key('action card')),
        onTap: widget.termine[index].id == null
            ? null
            : () => widget.openActionDetails(widget.termine[index]),
        contentPadding: EdgeInsets.only(bottom: 0.1));
    var now = DateTime.now();
    // An erstes Element Abstand nach oben anhängen, damit oberste Aktion nicht von Filter verdeckt wird
    if (index == 0) {
      tile = Column(children: [
        SizedBox(
          height: 50.0,
        ),
        tile
      ]);
    ***REMOVED***
    // Jetzt-Zeile an die zuletzt vergangene Aktion anhängen
    if ((widget.termine[index].beginn.isBefore(now)) &&
        (index == widget.termine.length - 1 ||
            widget.termine[index + 1].beginn.isAfter(now)) &&
        widget.termine[index].typ != 'Listen ausgelegt')
      tile = Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        tile,
        Text(
          'Jetzt',
          key: Key('action list now line'),
          style: TextStyle(color: CampaignTheme.secondary, fontSize: 16.0),
        ).tr(),
      ]);
    return tile;
  ***REMOVED***

  @override
  void dispose() {
    snackbarTimer?.cancel();
    super.dispose();
  ***REMOVED***
***REMOVED***
