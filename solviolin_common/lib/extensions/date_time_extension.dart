extension DateTimeExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime get startOfWeek => DateTime(year, month, day - weekday % 7);
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 7));
}
