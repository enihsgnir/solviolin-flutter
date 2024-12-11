import 'package:intl/intl.dart';
import 'package:solviolin/models/dow.dart';
import 'package:solviolin/utils/utils.dart';

typedef Formatter<T> = String Function(T value);

extension FormatExtension<T> on T {
  String format(Formatter<T> formatter) => formatter(this);
}

String number(int? value) {
  if (value == null) {
    return "-";
  }
  return NumberFormat("#,##0").format(value);
}

String weekday(int value) {
  return Dow.values[value % 7].label;
}

String date(DateTime value) {
  final y = (value.year % 100).toString().padLeft(2, "0");
  final m = value.month.toString().padLeft(2, "0");
  final d = value.day.toString().padLeft(2, "0");
  final w = value.weekday.format(weekday);
  return "$y.$m.$d.($w)";
}

String time(DateTime value) {
  final h = value.hour.toString().padLeft(2, "0");
  final m = value.minute.toString().padLeft(2, "0");
  return "$h:$m";
}

String durationTime(Duration value) {
  final hour = value.inHours % Duration.hoursPerDay;
  final h = "$hour".padLeft(2, "0");

  final minute = value.inMinutes % Duration.minutesPerHour;
  final m = "$minute".padLeft(2, "0");

  return "$h:$m";
}

String dateTime(DateTime value) {
  return "${value.format(date)} ${value.format(time)}";
}

String dateTimeRange((DateTime, DateTime) value) {
  final (start, end) = value;
  if (isSameDay(start, end)) {
    return "${start.format(date)} ${start.format(time)} ~ ${end.format(time)}";
  }
  return "${start.format(date)} ${start.format(time)} ~ ${end.format(date)} ${end.format(time)}";
}

String phoneNumber(String value) {
  final regex = RegExp(r'^(\d{3})(\d{3,4})(\d{4})$');
  if (!regex.hasMatch(value)) {
    return value;
  }

  return value.replaceAllMapped(regex, (m) => "${m[1]}-${m[2]}-${m[3]}");
}
