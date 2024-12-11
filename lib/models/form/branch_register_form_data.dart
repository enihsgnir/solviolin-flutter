import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_register_form_data.freezed.dart';

@freezed
class BranchRegisterFormData with _$BranchRegisterFormData {
  const factory BranchRegisterFormData({
    @Default("") String branchName,
  }) = _BranchRegisterFormData;

  const BranchRegisterFormData._();

  bool get enabled => branchName.isNotEmpty;
}
