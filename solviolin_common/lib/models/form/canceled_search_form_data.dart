import 'package:freezed_annotation/freezed_annotation.dart';

part 'canceled_search_form_data.freezed.dart';

@freezed
class CanceledSearchFormData with _$CanceledSearchFormData {
  const factory CanceledSearchFormData({
    @Default("") String teacherID,
  }) = _CanceledSearchFormData;

  const CanceledSearchFormData._();

  bool get enabled => teacherID.isNotEmpty;
}
