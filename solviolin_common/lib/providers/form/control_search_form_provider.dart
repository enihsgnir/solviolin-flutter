import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';
import 'package:solviolin_common/extensions/null_if_empty_extension.dart';
import 'package:solviolin_common/models/control_status.dart';
import 'package:solviolin_common/models/form/control_search_form_data.dart';

part 'control_search_form_provider.g.dart';

@riverpod
class ControlSearchForm extends _$ControlSearchForm {
  @override
  ControlSearchFormData build() {
    final today = DateTime.now().dateOnly;

    return ControlSearchFormData(
      controlStart: today.subtract(const Duration(days: 2)),
      controlEnd: today.add(const Duration(days: 7)),
    );
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setTeacherID(String value) {
    state = state.copyWith(teacherID: value.nullIfEmpty);
  }

  void setControlStart(DateTime value) {
    state = state.copyWith(controlStart: value);
  }

  void setControlEnd(DateTime value) {
    state = state.copyWith(controlEnd: value);
  }

  void setStatus(ControlStatus? value) {
    state = state.copyWith(status: value);
  }
}
