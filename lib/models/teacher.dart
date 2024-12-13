import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/converters/time_converter.dart';
import 'package:solviolin/models/dow.dart';

part 'teacher.freezed.dart';
part 'teacher.g.dart';

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
