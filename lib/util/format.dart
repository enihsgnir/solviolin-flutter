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

  return "${time.inHours}:$twoDigitMinutes";
}

DateTime parseDateOnly(String date) {
  DateTime _date = DateTime.parse(date);

  return DateTime(_date.year, _date.month, _date.day);
}

DateTime parseDateTime(String dateTime) {
  DateTime _dateTime = DateTime.parse(dateTime);

  return DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
      _dateTime.hour, _dateTime.minute);
}

String dateToString(DateTime date) =>
    "${date.year}/${twoDigits(date.month)}/${twoDigits(date.day)}";

String dateTimeToTimeString(DateTime dateTime) =>
    "${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}";

// yyMMddString
String dateTimeToString(DateTime dateTime) =>
    "${dateTime.year % 100}/${twoDigits(dateTime.month)}/${twoDigits(dateTime.day)}" +
    " ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}";

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
