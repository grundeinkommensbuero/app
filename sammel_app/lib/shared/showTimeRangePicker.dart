import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/shared/DweTheme.dart';

Future<TimeRange> showTimeRangePicker(
    BuildContext context, TimeOfDay initialFrom, TimeOfDay initialTo) async {
  var from = await showSingleTimePicker(context,
      initialFrom ?? TimeOfDay(hour: 12, minute: 00), 'Startzeit', 'Weiter',
      key: Key('from time picker'));
  var to = await showSingleTimePicker(context,
      initialTo ?? TimeOfDay(hour: 12, minute: 00), 'Endzeit', 'Fertig',
      key: Key('to time picker'));
  return TimeRange(from, to);
***REMOVED***

Future<TimeOfDay> showSingleTimePicker(
    BuildContext context, TimeOfDay initialTime, String title, String next,
    {Key key***REMOVED***) async {
  TransitionBuilder builder = (BuildContext context, Widget timePicker) {
    return MediaQuery(
        key: key,
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        // aus unerklärlichen Gründen bezieht der TimePicker sein Styling seit
        // irgendeinem Flutter-Upgrade nicht mehr aus dem Theme, sondern muss
        // explizit gestylt werden
        child: TimePickerTheme(
            data: TimePickerTheme.of(context).copyWith(
                backgroundColor: DweTheme.yellowLight,
                dialBackgroundColor: DweTheme.yellowBright,
                dialHandColor: DweTheme.purple,
                hourMinuteTextColor: DweTheme.purple,
                helpTextStyle: TextStyle(
                    color: DweTheme.purple,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
            child: Theme(
                data: Theme.of(context).copyWith(
                    textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(primary: DweTheme.purple))),
                child: timePicker)));
  ***REMOVED***
  return await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: title.tr(),
      cancelText: 'Keine Auswahl'.tr(),
      confirmText: next.tr(),
      builder: builder);
***REMOVED***

class TimeRange {
  TimeOfDay from;
  TimeOfDay to;

  TimeRange(this.from, this.to);
***REMOVED***
