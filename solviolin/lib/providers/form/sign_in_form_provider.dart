import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/form/sign_in_form_data.dart';
import 'package:solviolin/providers/client_state/auth_state_provider.dart';

part 'sign_in_form_provider.g.dart';

@riverpod
class SignInForm extends _$SignInForm {
  @override
  SignInFormData build() {
    return const SignInFormData();
  }

  void setUserID(String value) {
    state = state.copyWith(userID: value);
  }

  void setUserPassword(String value) {
    state = state.copyWith(userPassword: value);
  }

  Future<void> submit() async {
    await ref.read(authStateProvider.notifier).signIn(
          userID: state.userID,
          userPassword: state.userPassword,
        );
  }
}
