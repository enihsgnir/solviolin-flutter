import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_search_form_data.freezed.dart';

@freezed
class TeacherSearchFormData with _$TeacherSearchFormData {
  const factory TeacherSearchFormData({
    @Default("") String branchName,
    String? teacherID,
  }) = _TeacherSearchFormData;

  const TeacherSearchFormData._();

  bool get enabled => branchName.isNotEmpty;
}
