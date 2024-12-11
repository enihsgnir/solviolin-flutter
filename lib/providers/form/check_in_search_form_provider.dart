import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/extensions/date_time_extension.dart';
import 'package:solviolin/models/form/check_in_search_form_data.dart';

part 'check_in_search_form_provider.g.dart';

@riverpod
class CheckInSearchForm extends _$CheckInSearchForm {
  @override
  CheckInSearchFormData build() {
    final today = DateTime.now().dateOnly;
    return CheckInSearchFormData(
      startDate: today,
      endDate: today,
    );
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setStartDate(DateTime value) {
    state = state.copyWith(startDate: value);
  }

  void setEndDate(DateTime value) {
    state = state.copyWith(endDate: value);
  }
}
