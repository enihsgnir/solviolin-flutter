import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/form/branch_register_form_data.dart';
import 'package:solviolin/providers/client_state/branch_state_provider.dart';

part 'branch_register_form_provider.g.dart';

@riverpod
class BranchRegisterForm extends _$BranchRegisterForm {
  @override
  BranchRegisterFormData build() {
    return const BranchRegisterFormData();
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  Future<void> submit() async {
    await ref.read(branchStateProvider.notifier).register(state.branchName);
  }
}
