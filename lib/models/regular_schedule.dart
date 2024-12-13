import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/converters/time_converter.dart';
import 'package:solviolin/models/dow.dart';

part 'regular_schedule.freezed.dart';
part 'regular_schedule.g.dart';

@freezed
class RegularSchedule with _$RegularSchedule {
  const factory RegularSchedule({
    required int id,
    @TimeConverter() required Duration startTime,
    @TimeConverter() required Duration endTime,
    required Dow dow,
    required String userID,
    required String teacherID,
    required String branchName,
  }) = _RegularSchedule;

  const RegularSchedule._();

  bool get isDaytime => startTime.inHours < 16;
  bool get isWeekend => dow == Dow.sat || dow == Dow.sun;

  factory RegularSchedule.fromJson(Map<String, dynamic> json) =>
      _$RegularScheduleFromJson(json);
}
