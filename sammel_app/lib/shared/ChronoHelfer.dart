import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

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
    }
    throw Exception('Unbekannter Wochentag');
  }

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
    }
    throw Exception('Unbekannter Monat');
  }

  static DateFormat _dateFormatHHmmss = DateFormat("HH:mm:ss");
  static DateFormat _dateFormatHHmm = DateFormat("HH:mm");

  static bool isTimeOfDayBefore(TimeOfDay timeofday1, TimeOfDay timeofday2)
  {
    if(timeofday1.hour<timeofday2.hour){
      return true;
    }
    if(timeofday1.hour == timeofday2.hour) {
      return timeofday1.minute < timeofday2.minute;
    }
    return false;
  }

  static String dateTimeToStringHHmmss(DateTime time) =>
      timeToStringHHmmss(TimeOfDay.fromDateTime(time));

  static String timeToStringHHmmss(TimeOfDay time) {
    if (time == null) return null;
    return _dateFormatHHmmss
        .format(DateTime(0, 1, 1, time.hour, time.minute, 0));
  }

  static String dateTimeToStringHHmm(DateTime time) =>
      timeToStringHHmm(TimeOfDay.fromDateTime(time));

  static String timeToStringHHmm(TimeOfDay time) {
    if (time == null) return null;
    return _dateFormatHHmm.format(DateTime(0, 1, 1, time.hour, time.minute, 0));
  }

  static String formatDateOfDateTimeMitWochentag(DateTime date) {
    if (date == null) return '';
    return '${wochentag(date)}, ${date.day.toString()}. ${monthName(date.month)} ${date.year.toString()}';
  }

  static String formatDateOfDateTime(DateTime date) {
    if (date == null) return '';
    return '${date.day.toString()}. ${monthName(date.month)} ${date.year.toString()}';
  }

  static String formatFromToTimeOfDateTimes(DateTime start, DateTime end) {
    if (start == null || end == null) return '';
    return 'von ${dateTimeToStringHHmm(start)} bis ${dateTimeToStringHHmm(end)} Uhr';
  }

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
  }

  static String formatDateTime(DateTime date) {
    Duration message_sent = DateTime.now().difference(date);
    if (message_sent < Duration(minutes: 1))
      return 'gerade eben'.tr();
    else if (message_sent < Duration(hours: 1))
      return '{} Minuten'.plural(message_sent.inMinutes);
    else if (message_sent < Duration(hours: 12))
      return '{} Stunden'.plural(message_sent.inHours);
    else if (DateTime.now().difference(date) < Duration(days: 1))
      return ChronoHelfer.dateTimeToStringHHmm(date);
    else if (DateTime.now().difference(date) < Duration(days: 7)) {
      return DateFormat('EEE, hh:mm').format(date);
    }

    return DateFormat('MMM d, hh:mm').format(date);
  }

}
