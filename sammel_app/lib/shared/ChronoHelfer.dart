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

  static DateFormat dateFormat = DateFormat("HH:mm:ss");

  static String timeToString(TimeOfDay time) {
    if (time == null) return null;
    return dateFormat.format(DateTime(0, 1, 1, time.hour, time.minute, 0));
  ***REMOVED***
***REMOVED***
