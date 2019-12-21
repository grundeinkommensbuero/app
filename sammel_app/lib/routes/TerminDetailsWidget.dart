import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/ExpandableConstrainedBox.dart';

class TerminDetailsWidget extends StatefulWidget {
  Termin termin;

  TerminDetailsWidget(this.termin);

  @override
  State<StatefulWidget> createState() {
    return _TerminDetailsWidget();
  }
}

class _TerminDetailsWidget extends State<TerminDetailsWidget> {
  _TerminDetailsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image.asset(widget.termin.getAsset(), width: 30.0),
        Text(widget.termin.typ,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Color.fromARGB(255, 129, 28, 98))),
        Container(width: 20.0)
      ]),
      SizedBox(
        height: 20.0,
      ),

      // Location
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.location_searching, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wo? ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(widget.termin.ort.bezirk),
          Row(children: [
            Icon(
              Icons.subdirectory_arrow_right,
              size: 18.0,
            ),
            Text(widget.termin.ort.ort),
          ]),
          ExpandableConstrainedBox(
            child: Text(
              'Treffpunkt: ' + widget.termin.details.treffpunkt,
              style: TextStyle(fontWeight: FontWeight.normal),
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
            maxHeight: 40.0,
            expandableCondition: widget.termin.details.treffpunkt.length > 70,
          )
        ])
      ]),
      SizedBox(
        height: 10.0,
      ),

      // Time
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.access_time, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wann?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(ChronoHelfer.formatDateOfDateTime(widget.termin.beginn)),
          Text(ChronoHelfer.formatFromToTimeOfDateTimes(
              widget.termin.beginn, widget.termin.ende))
        ])
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
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Was?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ExpandableConstrainedBox(
            child: Text(
              widget.termin.details.kommentar,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            maxHeight: 105.0,
            expandableCondition: widget.termin.details.kommentar.length > 200,
          )
        ])
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
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wer?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ExpandableConstrainedBox(
            child: Text(
              widget.termin.details.kontakt,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            maxHeight: 105.0,
            expandableCondition: widget.termin.details.kontakt.length > 200,
          )
        ])
      ]),
    ]);
  }
}
