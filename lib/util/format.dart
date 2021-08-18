import 'package:flutter/material.dart';

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

Duration parseTimeOnly(String time) {
  List<String> times = time.split(":");
  int hours = int.parse(times[0]);
  int minutes = int.parse(times[1]);

  return Duration(hours: hours, minutes: minutes);
}

String twoDigits(int n) => n < 10 ? "0$n" : "$n";

String timeToString(Duration time) {
  String twoDigitMinutes =
      twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));

  return "${twoDigits(time.inHours)}:$twoDigitMinutes";
}

DateTime parseDateOnly(String date) => DateUtils.dateOnly(DateTime.parse(date));

DateTime parseDateTime(String dateTime) {
  DateTime _dateTime = DateTime.parse(dateTime);

  return DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
      _dateTime.hour, _dateTime.minute);
}

String bookingStatusToString(int bookingStatus) {
  Map<int, String> status = {
    0: "Original",
    1: "MadeUp",
    2: "Canceled",
    3: "Extended",
    -1: "MadeUp(by Admin)",
    -2: "Canceled(by Admin)",
    -3: "Extended(by Admin)",
  };

  return status[bookingStatus]!;
}

Duration convertDateTimeToDuration(DateTime dateTime) =>
    Duration(hours: dateTime.hour, minutes: dateTime.minute);

DateTime trimDateTime(DateTime dateTime) => DateTime(dateTime.year,
    dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);

String controlStatusToString(int status) {
  Map<int, String> _status = {
    0: "Open",
    1: "Close",
  };

  return _status[status]!;
}

// int getFirstDayOffset(DateTime date) {
//   final int weekdayFromMonday = DateTime(date.year, date.month).weekday - 1;
//   int firstDayOfWeekIndex = 0;
//   firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;
//   return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
// }
