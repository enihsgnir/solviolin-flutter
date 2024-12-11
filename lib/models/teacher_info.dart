import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/teacher_color.dart';

part 'teacher_info.freezed.dart';
part 'teacher_info.g.dart';

@freezed
class TeacherInfo with _$TeacherInfo {
  const factory TeacherInfo({
    required String teacherID,
    required TeacherColor teacher,
  }) = _TeacherInfo;

  const TeacherInfo._();

  Color get color => teacher.color;

  factory TeacherInfo.fromJson(Map<String, dynamic> json) =>
      _$TeacherInfoFromJson(json);
}
