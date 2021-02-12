import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:after_layout/after_layout.dart';
import 'TerminCard.dart';

class ActionList extends StatefulWidget {
  final List<Termin> termine;
  final Function(Termin) openActionDetails;
  final Function(Termin) isMyAction;
  final Function(Termin) iAmParticipant;
  final Function(Termin) isPastAction;

  ActionList(this.termine, this.isMyAction, this.isPastAction,
      this.iAmParticipant, this.openActionDetails,
      {Key key***REMOVED***)
      : super(key: key);

  @override
  ActionListState createState() => ActionListState();
***REMOVED***

class ActionListState extends State<ActionList>
    with AfterLayoutMixin<ActionList> {
  ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    var index_of_now = getIndexOfNow();

    var scrollableList = ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: widget.termine.length,
        itemBuilder: cardListBuilder,
        initialScrollIndex: index_of_now);
    if (index_of_now > 0 && _scrollController.isAttached) {
      Timer(
          Duration(milliseconds: 100),
          () => _scrollController.scrollTo(
              index: index_of_now,
              alignment: 0,
              curve: Curves.easeOutCubic,
              duration: Duration(milliseconds: index_of_now * 75)));
    ***REMOVED***
    return scrollableList;
  ***REMOVED***

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      maybeShowEvaluationSnackBar(context);
    ***REMOVED***);
  ***REMOVED***

  void maybeShowEvaluationSnackBar(BuildContext context) {
    Provider.of<StorageService>(context)
        .loadAllStoredEvaluations()
        .then((evaluations) {
      for (Termin termin in widget.termine) {
        if (widget.isPastAction(termin) &&
            widget.iAmParticipant(termin) &&
            !evaluations.contains(termin.id)) {
          final snackBar = SnackBar(
              content: Text('Dein Feedback zu einer Aktion fehlt noch'.tr(),
                  style: TextStyle(color: Colors.black87)),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 7),
              backgroundColor: Color.fromARGB(220, 255, 255, 250),
              action: SnackBarAction(
                  label: 'Zur Aktion'.tr(),
                  onPressed: () => widget.openActionDetails(termin)));
          Scaffold.of(context).showSnackBar(snackBar);
          break;
        ***REMOVED***
      ***REMOVED***
    ***REMOVED***);
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
    // Jetzt-Zeile an die zuletzt vergangene Aktion anhängen
    if ((widget.termine[index].beginn.isBefore(now)) &&
        (index == widget.termine.length - 1 ||
            widget.termine[index + 1].beginn.isAfter(now)))
      tile = Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        tile,
        Text(
          'Jetzt',
          key: Key('action list now line'),
          style: TextStyle(color: DweTheme.purple, fontSize: 16.0),
        ).tr(),
      ]);
    if (index == 99)
      tile = Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        tile,
        Text(
          'In der Liste und auf der Karte werden höchstens 100 Aktionen angezeigt. Du kannst die Filterfunktion benutzen um konkreter nach Aktionen zu suchen.',
          key: Key('action list end line'),
          style: TextStyle(fontSize: 14.0),
          textAlign: TextAlign.center,
        ).tr(),
      ]);
    return tile;
  ***REMOVED***
***REMOVED***
