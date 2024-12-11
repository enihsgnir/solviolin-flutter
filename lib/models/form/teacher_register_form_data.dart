import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/dow.dart';

part 'teacher_register_form_data.freezed.dart';

@freezed
class TeacherRegisterFormData with _$TeacherRegisterFormData {
  const factory TeacherRegisterFormData({
    @Default("") String teacherID,
    @Default("") String teacherBranch,
    required Dow workDow,
    @Default(Duration.zero) Duration startTime,
    @Default(Duration.zero) Duration endTime,
  }) = _TeacherRegisterFormData;

  const TeacherRegisterFormData._();

  bool get enabled =>
      teacherID.isNotEmpty && teacherBranch.isNotEmpty && startTime < endTime;
}
