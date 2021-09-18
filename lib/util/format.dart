import 'package:flutter/material.dart';

DateTime parseDateOnly(String date) => DateUtils.dateOnly(DateTime.parse(date));

Duration parseTimeOnly(String time) {
  var times = time.split(":");
  var hours = int.parse(times[0]);
  var minutes = int.parse(times[1]);

  return Duration(hours: hours, minutes: minutes);
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
  var days = {
    -1: "Null",
    0: "SUN",
    1: "MON",
    2: "TUE",
    3: "WED",
    4: "THU",
    5: "FRI",
    6: "SAT",
    7: "SUN",
  };

  return days[dow]!;
}

String? textEdit(TextEditingController edit) =>
    edit.text == "" ? null : edit.text;

int? intEdit(TextEditingController edit) =>
    edit.text == "" ? null : int.parse(edit.text);
