import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher.freezed.dart';
part 'teacher.g.dart';

enum Dow {
  @JsonValue(0)
  sun,

  @JsonValue(1)
  mon,

  @JsonValue(2)
  tue,

  @JsonValue(3)
  wed,

  @JsonValue(4)
  thu,

  @JsonValue(5)
  fri,

  @JsonValue(6)
  sat,
}

@freezed
class Teacher with _$Teacher {
  const factory Teacher({
    required int id,
    required String teacherID,
    required String branchName,
    required Dow workDow,
    @TimeConverter() required Duration startTime,
    @TimeConverter() required Duration endTime,
  }) = _Teacher;

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
}

class TimeConverter implements JsonConverter<Duration, String> {
  const TimeConverter();

  @override
  Duration fromJson(String json) {
    final times = json.split(":").map(int.parse).toList();
    return Duration(hours: times[0], minutes: times[1]);
  }

  @override
  String toJson(Duration object) {
    final hh = object.inHours.toString().padLeft(2, "0");
    final mm = object.inMinutes.remainder(60).toString().padLeft(2, "0");
    return "$hh:$mm";
  }
}
