import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/null_if_empty_extension.dart';
import 'package:solviolin_common/models/form/teacher_search_form_data.dart';

part 'teacher_search_form_provider.g.dart';

@riverpod
class TeacherSearchForm extends _$TeacherSearchForm {
  @override
  TeacherSearchFormData build() {
    return const TeacherSearchFormData();
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setTeacherID(String value) {
    state = state.copyWith(teacherID: value.nullIfEmpty);
  }
}
