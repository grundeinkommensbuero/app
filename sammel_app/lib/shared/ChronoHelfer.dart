import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChronoHelfer {
  static DateFormat _dateFormatHHmmss = DateFormat("HH:mm:ss");
  static DateFormat _dateFormatHHmm = DateFormat("HH:mm");

  static bool isTimeOfDayBefore(TimeOfDay timeofday1, TimeOfDay timeofday2) {
    if (timeofday1.hour < timeofday2.hour) {
      return true;
    }
    if (timeofday1.hour == timeofday2.hour) {
      return timeofday1.minute < timeofday2.minute;
    }
    return false;
  }

  static String? dateTimeToStringHHmmss(DateTime? time) {
    if(time == null) return null;
    return timeToStringHHmmss(TimeOfDay.fromDateTime(time));
  }

  static String? timeToStringHHmmss(TimeOfDay? time) {
    if (time == null) return null;
    return _dateFormatHHmmss
        .format(DateTime(0, 1, 1, time.hour, time.minute, 0));
  }

  static String? dateTimeToStringHHmm(DateTime? time) {
    if(time == null) return null;
    return timeToStringHHmm(TimeOfDay.fromDateTime(time));
  }

  static String? timeToStringHHmm(TimeOfDay? time) {
    if (time == null) return null;
    return _dateFormatHHmm.format(DateTime(0, 1, 1, time.hour, time.minute, 0));
  }

  static String formatDateOfDateTimeMitWochentag(DateTime? date,
      [Locale? locale]) {
    if (date == null) return '';
    return DateFormat('EEEE, d. MMMM yyyy', locale?.languageCode).format(date);
  }

  static String formatDateOfDateTimeMitWochentagOhneJahr(DateTime? date,
      [Locale? locale]) {
    if (date == null) return '';
    return DateFormat('EEEE, d. MMMM', locale?.languageCode).format(date);
  }

  static String formatDateOfDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d. MMMM yyyy').format(date);
  }

  static String formatFromToTimeOfDateTimes(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '';
    return 'von '.tr() +
        '${dateTimeToStringHHmm(start)}' +
        ' bis '.tr() +
        '${dateTimeToStringHHmm(end)}';
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

  static String? formatDateTime(DateTime? date) {
    if(date == null) return null;

    Duration messageSent = DateTime.now().difference(date);
    if (messageSent < Duration(minutes: 1))
      return 'gerade eben'.tr();
    else if (messageSent < Duration(hours: 1))
      return '{} Minuten'.plural(messageSent.inMinutes);
    else if (messageSent < Duration(hours: 12))
      return '{} Stunden'.plural(messageSent.inHours);
    else if (DateTime.now().difference(date) < Duration(days: 1))
      return ChronoHelfer.dateTimeToStringHHmm(date);
    else if (DateTime.now().difference(date) < Duration(days: 7)) {
      return DateFormat('EEE, hh:mm').format(date);
    }

    return DateFormat('MMM d, hh:mm').format(date);
  }
}

bool equalTimestamps(DateTime? timestamp1, DateTime? timestamp2) =>
    timestamp1 == null
        ? timestamp2 == null
        : timestamp2 != null && timestamp1.isAtSameMomentAs(timestamp2);

int compareTimestamp(DateTime? timestamp1, DateTime? timestamp2) {
  if (timestamp1 == null && timestamp2 == null) return 0;
  if (timestamp1 == null) return -1;
  if (timestamp2 == null) return 1;
  return timestamp1.compareTo(timestamp2);
}
