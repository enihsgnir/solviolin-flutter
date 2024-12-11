import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/form/ledger_total_form_data.dart';
import 'package:solviolin/providers/client_state/ledger_state_provider.dart';

part 'ledger_total_form_provider.g.dart';

@riverpod
class LedgerTotalForm extends _$LedgerTotalForm {
  @override
  LedgerTotalFormData build() {
    return const LedgerTotalFormData();
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setTermID(int value) {
    state = state.copyWith(termID: value);
  }

  Future<int> search() async {
    final ledgerClient = ref.watch(ledgerStateProvider);
    final total = await ledgerClient.getTotal(
      branchName: state.branchName,
      termID: state.termID,
    );
    return num.parse(total).toInt();
  }
}
