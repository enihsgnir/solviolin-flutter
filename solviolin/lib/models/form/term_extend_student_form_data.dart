import 'package:freezed_annotation/freezed_annotation.dart';

part 'term_extend_student_form_data.freezed.dart';

@freezed
class TermExtendStudentFormData with _$TermExtendStudentFormData {
  const factory TermExtendStudentFormData({
    @Default("") String userID,
  }) = _TermExtendStudentFormData;

  const TermExtendStudentFormData._();

  bool get enabled => userID.isNotEmpty;
}
