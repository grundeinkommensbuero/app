import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/DweTheme.dart';
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
      {Key key})
      : super(key: key);

  @override
  ActionListState createState() => ActionListState();
}

class ActionListState extends State<ActionList> {
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
    }
    return scrollableList;
  }

  int getIndexOfNow() {
    var now = DateTime.now();
    for (int index = 0; index < widget.termine.length; index++) {
      if ((widget.termine[index].beginn.isBefore(now)) &&
          (index == widget.termine.length - 1 ||
              widget.termine[index + 1].beginn.isAfter(now))) {
        if(index > widget.termine.length - 5)
          return (widget.termine.length > 5 ? widget.termine.length - 5 : 0);
        else
          return index;
      }
    }
    return 0;
  }

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
  }
}
