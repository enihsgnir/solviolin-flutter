import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/form/term_extend_branch_form_data.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';

part 'term_extend_branch_form_provider.g.dart';

@riverpod
class TermExtendBranchForm extends _$TermExtendBranchForm {
  @override
  TermExtendBranchFormData build() {
    return const TermExtendBranchFormData();
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  Future<void> submit() async {
    await ref
        .read(reservationStateProvider.notifier)
        .extendAllCoursesOfBranch(state.branchName);
  }
}
