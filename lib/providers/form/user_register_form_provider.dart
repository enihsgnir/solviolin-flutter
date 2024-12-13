import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/form/user_register_form_data.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/providers/client_state/user_state_provider.dart';

part 'user_register_form_provider.g.dart';

@riverpod
class UserRegisterForm extends _$UserRegisterForm {
  @override
  UserRegisterFormData build() {
    return const UserRegisterFormData(
      userType: UserType.student,
    );
  }

  void setUserID(String value) {
    state = state.copyWith(userID: value);
  }

  void setUserPassword(String value) {
    state = state.copyWith(userPassword: value);
  }

  void setUserName(String value) {
    state = state.copyWith(userName: value);
  }

  void setUserPhone(String value) {
    state = state.copyWith(userPhone: value);
  }

  void setUserBranch(String value) {
    state = state.copyWith(userBranch: value);
  }

  void setUserType(UserType value) {
    state = state.copyWith(userType: value);
  }

  Future<void> submit() async {
    await ref.read(userStateProvider.notifier).register(
          userID: state.userID,
          userPassword: state.userPassword,
          userName: state.userName,
          userPhone: state.userPhone,
          userType: state.userType,
          userBranch: state.userBranch,
        );
  }
}
