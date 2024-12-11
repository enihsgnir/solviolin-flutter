import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_search_form_data.freezed.dart';

@freezed
class SalarySearchFormData with _$SalarySearchFormData {
  const factory SalarySearchFormData({
    @Default("") String branchName,
    @Default(0) int termID,
    @Default(0) int dayTimeCost,
    @Default(0) int nightTimeCost,
  }) = _SalarySearchFormData;

  const SalarySearchFormData._();

  bool get enabled =>
      branchName.isNotEmpty &&
      termID != 0 &&
      dayTimeCost >= 0 &&
      nightTimeCost >= 0;
}
