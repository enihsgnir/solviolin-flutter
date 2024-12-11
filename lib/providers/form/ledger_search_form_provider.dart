import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/extensions/null_if_empty_extension.dart';
import 'package:solviolin/models/form/ledger_search_form_data.dart';

part 'ledger_search_form_provider.g.dart';

@riverpod
class LedgerSearchForm extends _$LedgerSearchForm {
  @override
  LedgerSearchFormData build() {
    return const LedgerSearchFormData();
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setTermID(int value) {
    state = state.copyWith(termID: value);
  }

  void setUserID(String value) {
    state = state.copyWith(userID: value.nullIfEmpty);
  }
}
