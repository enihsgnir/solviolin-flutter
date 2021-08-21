import 'package:flutter/material.dart';

DateTime parseDateOnly(String date) => DateUtils.dateOnly(DateTime.parse(date));

Duration parseTimeOnly(String time) {
  List<String> times = time.split(":");
  int hours = int.parse(times[0]);
  int minutes = int.parse(times[1]);

  return Duration(hours: hours, minutes: minutes);
}

DateTime parseDateTime(String dateTime) {
  DateTime _dateTime = DateTime.parse(dateTime);

  return DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
      _dateTime.hour, _dateTime.minute);
}

String twoDigits(int n) => n < 10 ? "0$n" : "$n";

String timeToString(Duration time) {
  String twoDigitMinutes =
      twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));

  return "${time.inHours}:$twoDigitMinutes";
}

String dowToString(int dow) {
  Map<int, String> days = {
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
