import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Duration parseTime(String time) {
  var times = time.split(":");

  return Duration(hours: int.parse(times[0]), minutes: int.parse(times[1]));
}

/// Returns local [DateTime] with the same properties of the parameter,
/// regardless of time zone.
///
/// It can be compared to `DateTime.now()` in the same time zone.
DateTime parseDateTime(String dateTime) {
  var _d = DateTime.parse(dateTime);

  return DateTime(_d.year, _d.month, _d.day, _d.hour, _d.minute);
}

extension Midnight on DateTime {
  /// local [DateTime] of UTC-midnight
  DateTime get midnight =>
      DateTime.utc(this.year, this.month, this.day).toLocal();
}

String timeToString(Duration time) {
  String Function(int n) _twoDigits = (n) => n.toString().padLeft(2, "0");

  var _twoDigitMinutes =
      _twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));

  return "${_twoDigits(time.inHours)}:$_twoDigitMinutes";
}

String? textEdit(TextEditingController edit) =>
    edit.text.isEmpty ? null : edit.text;

/// yy/MM/dd HH:mm
String formatDateTime(DateTime dateTime) =>
    DateFormat("yy/MM/dd HH:mm").format(dateTime);

/// HH:mm
String formatTime(DateTime time) => DateFormat("HH:mm").format(time);

/// yy/MM/dd HH:mm ~ HH:mm
String formatDateTimeRange(DateTime start, DateTime end) =>
    formatDateTime(start) + " ~ " + formatTime(end);
