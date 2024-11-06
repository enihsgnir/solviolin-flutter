import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/dow.dart';
import 'package:solviolin_common/models/form/teacher_register_form_data.dart';
import 'package:solviolin_common/providers/client_state/teacher_state_provider.dart';

part 'teacher_register_form_provider.g.dart';

@riverpod
class TeacherRegisterForm extends _$TeacherRegisterForm {
  @override
  TeacherRegisterFormData build() {
    return const TeacherRegisterFormData(
      workDow: Dow.sun,
    );
  }

  void setTeacherID(String value) {
    state = state.copyWith(teacherID: value);
  }

  void setTeacherBranch(String value) {
    state = state.copyWith(teacherBranch: value);
  }

  void setWorkDow(Dow value) {
    state = state.copyWith(workDow: value);
  }

  void setStartTime(Duration value) {
    state = state.copyWith(startTime: value);
  }

  void setEndTime(Duration value) {
    state = state.copyWith(endTime: value);
  }

  Future<void> submit() async {
    await ref.read(teacherStateProvider.notifier).register(
          teacherID: state.teacherID,
          teacherBranch: state.teacherBranch,
          workDow: state.workDow.index,
          startTime: state.startTime,
          endTime: state.endTime,
        );
  }
}
