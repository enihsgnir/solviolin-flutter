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

Duration parseTimeOnly(String time) {
  List<String> _times = time.split(":");
  int _hours = int.parse(_times[0]);
  int _minutes = int.parse(_times[1]);

  return Duration(hours: _hours, minutes: _minutes);
}

String timeToString(Duration time) {
  String _twoDigits(int n) {
    if (n < 10) {
      return "0$n";
    }
    return "$n";
  }

  String _twoDigitMinutes =
      _twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));

  return "${time.inHours}:$_twoDigitMinutes";
}

DateTime parseDateOnly(String date) {
  DateTime _date = DateTime.parse(date);

  return DateTime(_date.year, _date.month, _date.day);
}

DateTime parseDateTime(String dateTime) {
  DateTime _dateTime = DateTime.parse(dateTime);

  return DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
      _dateTime.hour, _dateTime.month);
}

String dateToString(DateTime date) => "${date.year}/${date.month}/${date.day}";

String dateTimeToTimeString(DateTime dateTime) =>
    "${dateTime.hour}:${dateTime.minute}";
