import 'package:flutter/material.dart';

DateTime parseDateOnly(String date) => DateUtils.dateOnly(DateTime.parse(date));

Duration parseTimeOnly(String time) {
  var times = time.split(":");

  return Duration(hours: int.parse(times[0]), minutes: int.parse(times[1]));
}

DateTime parseDateTime(String dateTime) {
  var _dateTime = DateTime.parse(dateTime);

  return DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
      _dateTime.hour, _dateTime.minute);
}

String _twoDigits(int n) => n < 10 ? "0$n" : "$n";

String timeToString(Duration time) {
  var twoDigitMinutes =
      _twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));

  return "${_twoDigits(time.inHours)}:$twoDigitMinutes";
}

Duration timeOfDayToDuration(TimeOfDay time) =>
    Duration(hours: time.hour, minutes: time.minute);

String dowToString(int dow) {
  return {
    -1: "Null",
    0: "SUN",
    1: "MON",
    2: "TUE",
    3: "WED",
    4: "THU",
    5: "FRI",
    6: "SAT",
    7: "SUN",
  }[dow]!;
}

String? textEdit(TextEditingController edit) =>
    edit.text == "" ? null : edit.text.trim();

int? intEdit(TextEditingController edit) =>
    edit.text == "" ? null : int.parse(edit.text.trim());

//TODO:
String? trimColorString(String? color) {
  if (color != null) {
    color = color.trim().toLowerCase();
    if (color.startsWith("#")) {
      color = color.substring(1, color.length);
    }
    if (color.length != 6) {
      return null;
    }
    for (int i = 0; i < 6; i++) {
      if (!"0123456789abcdef".contains(color.substring(i, i + 1))) {
        return null;
      }
    }
  }
  return color;
}
