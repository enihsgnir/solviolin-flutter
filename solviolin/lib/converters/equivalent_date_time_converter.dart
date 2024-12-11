import 'package:json_annotation/json_annotation.dart';

class EquivalentDateTimeConverter implements JsonConverter<DateTime, String> {
  const EquivalentDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    final dateTime = DateTime.parse(json);
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
