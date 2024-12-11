import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/form/term_edit_form_data.dart';
import 'package:solviolin/providers/client_state/reservation_state_provider.dart';

part 'term_update_form_provider.g.dart';

@riverpod
class TermUpdateForm extends _$TermUpdateForm {
  @override
  TermEditFormData build(int id) {
    final today = DateTime.now();
    return TermEditFormData(
      termStart: today,
      termEnd: today,
    );
  }

  void setTermStart(DateTime value) {
    state = state.copyWith(termStart: value);
  }

  void setTermEnd(DateTime value) {
    state = state.copyWith(termEnd: value);
  }

  Future<void> submit() async {
    await ref.read(reservationStateProvider.notifier).modifyTerm(
          id,
          termStart: state.termStart,
          termEnd: state.termEnd,
        );
  }
}
