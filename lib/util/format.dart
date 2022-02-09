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
  var _dateTime = DateTime.parse(dateTime);

  return DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
      _dateTime.hour, _dateTime.minute);
}

String _twoDigits(int n) => n < 10 ? "0$n" : "$n";

String timeToString(Duration time) {
  var _twoDigitMinutes =
      _twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));

  return "${_twoDigits(time.inHours)}:$_twoDigitMinutes";
}

/// yy/MM/dd HH:mm
String formatDateTime(DateTime dateTime) =>
    DateFormat("yy/MM/dd HH:mm").format(dateTime);

/// HH:mm
String formatTime(DateTime time) => DateFormat("HH:mm").format(time);

/// yy/MM/dd HH:mm ~ HH:mm
String formatDateTimeRange(DateTime start, DateTime end) =>
    formatDateTime(start) + " ~ " + formatTime(end);
