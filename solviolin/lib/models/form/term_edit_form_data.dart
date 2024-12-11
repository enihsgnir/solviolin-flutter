import 'package:freezed_annotation/freezed_annotation.dart';

part 'term_edit_form_data.freezed.dart';

@freezed
class TermEditFormData with _$TermEditFormData {
  const factory TermEditFormData({
    required DateTime termStart,
    required DateTime termEnd,
  }) = _TermEditFormData;

  const TermEditFormData._();

  bool get enabled => termStart.isBefore(termEnd);
}
