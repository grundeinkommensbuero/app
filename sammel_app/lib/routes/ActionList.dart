import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'TerminCard.dart';

class ActionList extends StatefulWidget {
  final List<Termin> termine;
  final Function(Termin) openActionDetails;
  final Function(int) isMyAction;
  final Function(List<User>) iAmParticipant;
  final Function(Termin) isPastAction;

  ActionList(this.termine, this.isMyAction, this.isPastAction,
      this.iAmParticipant, this.openActionDetails,
      {Key key***REMOVED***)
      : super(key: key);

  @override
  ActionListState createState() => ActionListState();
***REMOVED***

class ActionListState extends State<ActionList> {
  ActionListState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.termine.length, itemBuilder: cardListBuilder);
  ***REMOVED***

  Widget cardListBuilder(context, index) {
    Widget tile = ListTile(
        title: TerminCard(
            widget.termine[index],
            widget.isMyAction(widget.termine[index].id),
            widget.iAmParticipant(widget.termine[index].participants),
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
