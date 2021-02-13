import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChronoHelfer {
  static DateFormat _dateFormatHHmmss = DateFormat("HH:mm:ss");
  static DateFormat _dateFormatHHmm = DateFormat("HH:mm");

  static bool isTimeOfDayBefore(TimeOfDay timeofday1, TimeOfDay timeofday2)
  {
    if(timeofday1.hour<timeofday2.hour){
      return true;
    ***REMOVED***
    if(timeofday1.hour == timeofday2.hour) {
      return timeofday1.minute < timeofday2.minute;
    ***REMOVED***
    return false;
  ***REMOVED***

  static String dateTimeToStringHHmmss(DateTime time) =>
      timeToStringHHmmss(TimeOfDay.fromDateTime(time));

  static String timeToStringHHmmss(TimeOfDay time) {
    if (time == null) return null;
    return _dateFormatHHmmss
        .format(DateTime(0, 1, 1, time.hour, time.minute, 0));
  ***REMOVED***

  static String dateTimeToStringHHmm(DateTime time) =>
      timeToStringHHmm(TimeOfDay.fromDateTime(time));

  static String timeToStringHHmm(TimeOfDay time) {
    if (time == null) return null;
    return _dateFormatHHmm.format(DateTime(0, 1, 1, time.hour, time.minute, 0));
  ***REMOVED***

  static String formatDateOfDateTimeMitWochentag(DateTime date, [Locale locale]) {
    if (date == null) return '';
    return DateFormat('E, d. MMMM yyyy', locale.languageCode).format(date);
  ***REMOVED***

  static String formatDateOfDateTime(DateTime date) {
    if (date == null) return '';
    return DateFormat('d. MMMM yyyy').format(date);
  ***REMOVED***

  static String formatFromToTimeOfDateTimes(DateTime start, DateTime end) {
    if (start == null || end == null) return '';
    return 'von ${dateTimeToStringHHmm(start)***REMOVED*** bis ${dateTimeToStringHHmm(end)***REMOVED*** Uhr';
  ***REMOVED***

  // Unterstützt DateTime-String-Repräsentationen und Objekte
  static DateTime deserializeJsonDateTime(dynamic json) {
    if (json is String) return DateTime.parse(json);
    return DateTime(
        json['date']['year'],
        json['date']['month'],
        json['date']['day'],
        json['time']['hour'],
        json['time']['minute'],
        json['time']['second']);
  ***REMOVED***

  static String formatDateTime(DateTime date) {
    Duration message_sent = DateTime.now().difference(date);
    if (message_sent < Duration(minutes: 1))
      return 'gerade eben'.tr();
    else if (message_sent < Duration(hours: 1))
      return '{***REMOVED*** Minuten'.plural(message_sent.inMinutes);
    else if (message_sent < Duration(hours: 12))
      return '{***REMOVED*** Stunden'.plural(message_sent.inHours);
    else if (DateTime.now().difference(date) < Duration(days: 1))
      return ChronoHelfer.dateTimeToStringHHmm(date);
    else if (DateTime.now().difference(date) < Duration(days: 7)) {
      return DateFormat('EEE, hh:mm').format(date);
    ***REMOVED***

    return DateFormat('MMM d, hh:mm').format(date);
  ***REMOVED***

***REMOVED***
