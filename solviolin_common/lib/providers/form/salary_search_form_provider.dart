import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/form/salary_search_form_data.dart';

part 'salary_search_form_provider.g.dart';

@riverpod
class SalarySearchForm extends _$SalarySearchForm {
  @override
  SalarySearchFormData build() {
    return const SalarySearchFormData();
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setTermID(int value) {
    state = state.copyWith(termID: value);
  }

  void setDayTimeCost(int value) {
    state = state.copyWith(dayTimeCost: value);
  }

  void setNightTimeCost(int value) {
    state = state.copyWith(nightTimeCost: value);
  }
}
