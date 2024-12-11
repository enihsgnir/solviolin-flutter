import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_in_search_form_data.freezed.dart';

@freezed
class CheckInSearchFormData with _$CheckInSearchFormData {
  const factory CheckInSearchFormData({
    @Default("") String branchName,
    required DateTime startDate,
    required DateTime endDate,
  }) = _CheckInSearchFormData;

  const CheckInSearchFormData._();

  bool get enabled =>
      branchName.isNotEmpty &&
      (startDate.isAtSameMomentAs(endDate) || startDate.isBefore(endDate));
}
