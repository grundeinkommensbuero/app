import 'package:flutter/material.dart';

Future<TimeRange> showTimeRangePicker(
    BuildContext context, TimeOfDay initialFrom, TimeOfDay initialTo) async {
  var from = await showSingleTimePicker(
      context, initialFrom ?? TimeOfDay(hour: 12, minute: 00), 'von',
      key: Key('from time picker'));
  var to = await showSingleTimePicker(
      context, initialTo ?? TimeOfDay(hour: 12, minute: 00), 'bis',
      key: Key('to time picker'));
  return TimeRange(from, to);
***REMOVED***

Future<TimeOfDay> showSingleTimePicker(
    BuildContext context, TimeOfDay initialTime, String title,
    {Key key***REMOVED***) async {
  TransitionBuilder builder = (BuildContext context, Widget timePicker) {
    return MediaQuery(
      key: key,
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // hack, um über dem Dialog einen Titel darzustellen
          // ignore: missing_required_param
          FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              child: Text(
                title,
                style: TextStyle(fontSize: 25.0),
              )),
          timePicker
        ],
      ),
    );
  ***REMOVED***
  return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: builder);
***REMOVED***

class TimeRange {
  TimeOfDay from;
  TimeOfDay to;

  TimeRange(this.from, this.to);
***REMOVED***
