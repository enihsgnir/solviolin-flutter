import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/user_status.dart';

part 'user_update_form_data.freezed.dart';

@freezed
class UserUpdateFormData with _$UserUpdateFormData {
  const factory UserUpdateFormData({
    String? userName,
    String? userPassword,
    String? userPhone,
    String? userBranch,
    int? userCredit,
    UserStatus? status,
  }) = _UserUpdateFormData;
}
