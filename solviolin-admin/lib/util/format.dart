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

Duration timeOfDayToDuration(TimeOfDay time) =>
    Duration(hours: time.hour, minutes: time.minute);

extension DowToString on int {
  String get dowToString =>
      {
        0: "SUN",
        1: "MON",
        2: "TUE",
        3: "WED",
        4: "THU",
        5: "FRI",
        6: "SAT",
        7: "SUN",
      }[this] ??
      "Null";
}

String? textEdit(TextEditingController edit, {bool trimText = true}) =>
    edit.text.isEmpty
        ? null
        : trimText
            ? edit.text.trim()
            : edit.text;

int? intEdit(TextEditingController edit) =>
    edit.text.isEmpty ? null : int.parse(edit.text.trim());

/// `RegExp(r"^#[0-9A-Fa-f]{6}$")`
bool checkHex(String input) => RegExp(r"^#[0-9A-Fa-f]{6}$").hasMatch(input);

Color? parseColor(String? input) {
  if (input != null && checkHex(input)) {
    return Color(int.parse(input.replaceFirst("#", "FF"), radix: 16));
  }
  return null;
}

String? formatColor(Color? color) =>
    color?.value.toRadixString(16).toUpperCase().replaceFirst("FF", "#");

/// `RegExp(r"^01([016789])-?(\d{3,4})-?(\d{4})$")`
bool checkPhone(String input) =>
    RegExp(r"^01([016789])-?(\d{3,4})-?(\d{4})$").hasMatch(input);

/// `RegExp(r"^(\d{3})(\d{3,4})(\d{4})$")`
String formatPhone(String phone) => phone.replaceFirstMapped(
      RegExp(r"^(\d{3})(\d{3,4})(\d{4})$"),
      (m) => "${m[1]}-${m[2]}-${m[3]}",
    );

String trimPhone(String phone) => phone.replaceAll("-", "");

/// yy/MM/dd
String formatDate(DateTime date) => DateFormat("yy/MM/dd").format(date);

/// yy/MM/dd ~ yy/MM/dd
String formatDateRange(DateTime start, DateTime end) =>
    formatDate(start) + " ~ " + formatDate(end);

/// HH:mm
String formatTime(DateTime time) => DateFormat("HH:mm").format(time);

/// HH:mm ~ HH:mm
String formatTimeRange(DateTime start, DateTime end) =>
    formatTime(start) + " ~ " + formatTime(end);

/// yy/MM/dd HH:mm
String formatDateTime(DateTime dateTime) =>
    formatDate(dateTime) + " " + formatTime(dateTime);

/// yy/MM/dd HH:mm ~ HH:mm
String formatDateTimeRange(DateTime start, DateTime end) =>
    formatDateTime(start) + " ~ " + formatTime(end);

/// #,###원
String formatCurrency(num n) => NumberFormat("#,###원").format(n);

/// #,###.#회
String formatWorkNumber(num n) => NumberFormat("#,###.#회").format(n);
