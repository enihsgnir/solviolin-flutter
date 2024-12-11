import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/extensions/date_time_extension.dart';
import 'package:solviolin/models/cancel_in_close.dart';
import 'package:solviolin/models/control_status.dart';
import 'package:solviolin/models/form/control_register_form_data.dart';
import 'package:solviolin/providers/client_state/control_state_provider.dart';

part 'control_register_form_provider.g.dart';

@riverpod
class ControlRegisterForm extends _$ControlRegisterForm {
  @override
  ControlRegisterFormData build() {
    final today = DateTime.now().dateOnly;

    return ControlRegisterFormData(
      controlStartDate: today,
      controlEndDate: today,
      status: ControlStatus.open,
      cancelInClose: CancelInClose.none,
    );
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setTeacherID(String value) {
    state = state.copyWith(teacherID: value);
  }

  void setControlStartDate(DateTime value) {
    state = state.copyWith(controlStartDate: value);
  }

  void setControlStartTime(Duration value) {
    state = state.copyWith(controlStartTime: value);
  }

  void setControlEndDate(DateTime value) {
    state = state.copyWith(controlEndDate: value);
  }

  void setControlEndTime(Duration value) {
    state = state.copyWith(controlEndTime: value);
  }

  void setStatus(ControlStatus value) {
    state = state.copyWith(status: value);
  }

  void setCancelInClose(CancelInClose value) {
    state = state.copyWith(cancelInClose: value);
  }

  Future<void> submit() async {
    final cancelInClose = state.status == ControlStatus.open
        ? CancelInClose.none
        : state.cancelInClose;

    await ref.read(controlStateProvider.notifier).register(
          branchName: state.branchName,
          teacherID: state.teacherID,
          controlStart: state.controlStartDate.add(state.controlStartTime),
          controlEnd: state.controlEndDate.add(state.controlEndTime),
          status: state.status,
          cancelInClose: cancelInClose,
        );
  }
}
