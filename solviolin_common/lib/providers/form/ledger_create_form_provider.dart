import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/form/ledger_create_form_data.dart';
import 'package:solviolin_common/providers/client_state/ledger_state_provider.dart';

part 'ledger_create_form_provider.g.dart';

@riverpod
class LedgerCreateForm extends _$LedgerCreateForm {
  @override
  LedgerCreateFormData build() {
    return const LedgerCreateFormData();
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setUserID(String value) {
    state = state.copyWith(userID: value);
  }

  void setTermID(int value) {
    state = state.copyWith(termID: value);
  }

  void setAmount(int value) {
    state = state.copyWith(amount: value);
  }

  Future<void> submit() async {
    await ref.read(ledgerStateProvider.notifier).register(
          branchName: state.branchName,
          userID: state.userID,
          termID: state.termID,
          amount: state.amount,
        );
  }
}
