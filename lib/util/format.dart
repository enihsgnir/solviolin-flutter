String dowToString(int dow) {
  Map<int, String> _days = {
    0: "일",
    1: "월",
    2: "화",
    3: "수",
    4: "목",
    5: "금",
    6: "토",
    7: "일",
  };

  return _days[dow]!;
}

String dowToRRuleString(int dow) {
  Map<int, String> _days = {
    0: "SU",
    1: "MO",
    2: "TU",
    3: "WE",
    4: "TH",
    5: "FR",
    6: "SA",
    7: "SU",
  };

  return _days[dow]!;
}

Duration parseTimeOnly(String time) {
  List<String> _times = time.split(":");
  int _hours = int.parse(_times[0]);
  int _minutes = int.parse(_times[1]);

  return Duration(hours: _hours, minutes: _minutes);
}

String timeToString(Duration time) {
  String _twoDigitMinutes =
      twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));

  return "${time.inHours}:$_twoDigitMinutes";
}

String twoDigits(int n) => n < 10 ? "0$n" : "$n";

DateTime parseDateOnly(String date) {
  DateTime _date = DateTime.parse(date);

  return DateTime(_date.year, _date.month, _date.day);
}

DateTime parseDateTime(String dateTime) {
  DateTime _dateTime = DateTime.parse(dateTime);

  return DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
      _dateTime.hour, _dateTime.month);
}

String dateToString(DateTime date) =>
    "${date.year}/${twoDigits(date.month)}/${twoDigits(date.day)}";

String dateTimeToTimeString(DateTime dateTime) =>
    "${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}";

String bookingStatusToString(int bookingStatus) {
  Map<int, String> _status = {
    0: "기본",
    1: "보강",
    2: "취소",
    3: "연장",
    -1: "보강(관리자)",
    -2: "취소(관리자)",
    -3: "연장(관리자)",
  };

  return _status[bookingStatus]!;
}
