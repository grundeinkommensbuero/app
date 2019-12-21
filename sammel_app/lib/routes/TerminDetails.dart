import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

class TerminDetailsWidget extends StatefulWidget {
  Termin termin;

  TerminDetailsWidget(this.termin) {
    termin.terminDetails = TerminDetails('Ubhf Samariterstraße',
        'Wir machen die U8', 'Ihr erreicht mich unter 01234567');
  ***REMOVED***

  @override
  State<StatefulWidget> createState() {
    return _TerminDetailsWidget();
  ***REMOVED***
***REMOVED***

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
              size: 20.0,
            ),
            Text(widget.termin.ort.ort),
          ]),
          ExpandableConstrainedBox(
            child: Text(
              'Treffpunkt: ' + widget.termin.terminDetails.treffpunkt,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            maxHeight: 40.0,
            expandableCondition:
                widget.termin.terminDetails.treffpunkt.length > 70,
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
          Text(formatiereDatum(widget.termin.beginn)),
          Text(formatiereUhrzeit(widget.termin.beginn, widget.termin.ende))
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
              widget.termin.terminDetails.kommentar,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            maxHeight: 105.0,
            expandableCondition:
                widget.termin.terminDetails.kommentar.length > 200,
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
              widget.termin.terminDetails.kontakt,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            maxHeight: 105.0,
            expandableCondition:
                widget.termin.terminDetails.kontakt.length > 200,
          )
        ])
      ]),
    ]);
  ***REMOVED***

  String formatiereDatum(DateTime date) {
    return ChronoHelfer.wochentag(date) +
        ', ' +
        date.day.toString() +
        '. ' +
        ChronoHelfer.monthName(date.month) +
        ' ' +
        date.year.toString();
  ***REMOVED***

  String formatiereUhrzeit(DateTime start, DateTime end) =>
      'von ' +
      ChronoHelfer.dateTimeToStringHHmm(start) +
      ' bis ' +
      ChronoHelfer.dateTimeToStringHHmm(end) +
      ' Uhr';
***REMOVED***

class ExpandableConstrainedBox extends StatefulWidget {
  Widget child = Placeholder();
  double maxHeight = 40.0;
  bool expandableCondition = true;

  ExpandableConstrainedBox(
      {this.child, this.maxHeight, this.expandableCondition***REMOVED***);

  @override
  State<StatefulWidget> createState() {
    return _ExpandableConstraintBox();
  ***REMOVED***
***REMOVED***

class _ExpandableConstraintBox extends State<ExpandableConstrainedBox> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.expandableCondition
        ? FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight:
                              expanded ? double.infinity : widget.maxHeight,
                          maxWidth: 220.0,
                          minWidth: 220.0),
                      child: widget.child),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ]),
            onPressed: () => setState(() => expanded = !expanded),
          )
        : widget.child;
  ***REMOVED***
***REMOVED***
