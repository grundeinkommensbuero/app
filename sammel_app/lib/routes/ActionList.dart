import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'TerminCard.dart';

class ActionList extends StatefulWidget {
  final List<Termin> termine;
  final Function openActionDetails;
  final Function isMyAction;

  ActionList(this.termine, this.isMyAction, this.openActionDetails, {Key key})
      : super(key: key);

  @override
  ActionListState createState() => ActionListState();
}

class ActionListState extends State<ActionList> {
  ActionListState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.termine.length, itemBuilder: cardListBuilder);
  }

  Widget cardListBuilder(context, index) {
    Widget tile = ListTile(
        title: TerminCard(widget.termine[index],
            widget.isMyAction(widget.termine[index].id), Key('action card')),
        onTap: () => widget.openActionDetails(context, widget.termine[index]),
        contentPadding: EdgeInsets.only(bottom: 0.1));
    var now = DateTime.now();
    // An erstes Element Abstand nach oben anhängen, damit oberste Aktion nicht von Filter verdeckt wird
    if (index == 0)
      tile = Column(children: [
        SizedBox(
          height: 50.0,
        ),
        tile
      ]);
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
        ),
      ]);
    return tile;
  }
}
