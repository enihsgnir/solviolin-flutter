import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/user_type.dart';

part 'user_register_form_data.freezed.dart';

@freezed
class UserRegisterFormData with _$UserRegisterFormData {
  const factory UserRegisterFormData({
    @Default("") String userID,
    @Default("") String userPassword,
    @Default("") String userName,
    @Default("") String userPhone,
    @Default("") String userBranch,
    required UserType userType,
  }) = _UserRegisterFormData;

  const UserRegisterFormData._();

  bool get enabled =>
      userID.isNotEmpty &&
      userPassword.isNotEmpty &&
      userName.isNotEmpty &&
      userPhone.isNotEmpty &&
      userBranch.isNotEmpty;
}
