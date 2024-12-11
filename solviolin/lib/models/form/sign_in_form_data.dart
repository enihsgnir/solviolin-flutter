import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_form_data.freezed.dart';

@freezed
class SignInFormData with _$SignInFormData {
  const factory SignInFormData({
    @Default("") String userID,
    @Default("") String userPassword,
  }) = _SignInFormData;

  const SignInFormData._();

  bool get enabled => userID.isNotEmpty && userPassword.isNotEmpty;
}
