import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChronoHelfer {
  static String wochentag(DateTime datetime) {
    switch (datetime.weekday) {
      case 1:
        return 'Montag';
      case 2:
        return 'Dienstag';
      case 3:
        return 'Mittwoch';
      case 4:
        return 'Donnerstag';
      case 5:
        return 'Freitag';
      case 6:
        return 'Samstag';
      case 7:
        return 'Sonntag';
    ***REMOVED***
    throw Exception('Unbekannter Wochentag');
  ***REMOVED***

  static String monthName(int month) {
    switch (month) {
      case 1:
        return 'Januar';
      case 2:
        return 'Februar';
      case 3:
        return 'März';
      case 4:
        return 'April';
      case 5:
        return 'Mai';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Dezember';
    ***REMOVED***
    throw Exception('Unbekannter Monat');
  ***REMOVED***

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

  static String formatDateOfDateTimeMitWochentag(DateTime date) {
    if (date == null) return '';
    return '${wochentag(date)***REMOVED***, ${date.day.toString()***REMOVED***. ${monthName(date.month)***REMOVED*** ${date.year.toString()***REMOVED***';
  ***REMOVED***

  static String formatDateOfDateTime(DateTime date) {
    if (date == null) return '';
    return '${date.day.toString()***REMOVED***. ${monthName(date.month)***REMOVED*** ${date.year.toString()***REMOVED***';
  ***REMOVED***

  static String formatFromToTimeOfDateTimes(DateTime start, DateTime end) {
    if (start == null || end == null) return '';
    return 'von ${dateTimeToStringHHmm(start)***REMOVED*** bis ${dateTimeToStringHHmm(end)***REMOVED*** Uhr';
  ***REMOVED***
***REMOVED***
