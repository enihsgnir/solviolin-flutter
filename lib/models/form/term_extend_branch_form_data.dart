import 'package:freezed_annotation/freezed_annotation.dart';

part 'term_extend_branch_form_data.freezed.dart';

@freezed
class TermExtendBranchFormData with _$TermExtendBranchFormData {
  const factory TermExtendBranchFormData({
    @Default("") String branchName,
  }) = _TermExtendBranchFormData;

  const TermExtendBranchFormData._();

  bool get enabled => branchName.isNotEmpty;
}
