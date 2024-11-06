import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/form/term_extend_student_form_data.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';

part 'term_extend_student_form_provider.g.dart';

@riverpod
class TermExtendStudentForm extends _$TermExtendStudentForm {
  @override
  TermExtendStudentFormData build() {
    return const TermExtendStudentFormData();
  }

  void setUserID(String value) {
    state = state.copyWith(userID: value);
  }

  Future<void> submit() async {
    await ref
        .read(reservationStateProvider.notifier)
        .extendAllCoursesOfUser(state.userID);
  }
}
