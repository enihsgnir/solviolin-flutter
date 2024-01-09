import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/teacher/teacher.dart';

part 'create_teacher_dto.freezed.dart';
part 'create_teacher_dto.g.dart';

@freezed
class CreateTeacherDto with _$CreateTeacherDto {
  const factory CreateTeacherDto({
    required String teacherID,
    required String teacherBranch,
    required int workDow,
    @TimeConverter() required Duration startTime,
    @TimeConverter() required Duration endTime,
  }) = _CreateTeacherDto;

  factory CreateTeacherDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTeacherDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
