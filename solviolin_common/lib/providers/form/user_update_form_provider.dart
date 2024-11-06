import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/null_if_empty_extension.dart';
import 'package:solviolin_common/models/form/user_update_form_data.dart';
import 'package:solviolin_common/models/user_status.dart';
import 'package:solviolin_common/providers/client_state/user_state_provider.dart';

part 'user_update_form_provider.g.dart';

@riverpod
class UserUpdateForm extends _$UserUpdateForm {
  @override
  UserUpdateFormData build() {
    return const UserUpdateFormData();
  }

  void setUserName(String value) {
    state = state.copyWith(userName: value.nullIfEmpty);
  }

  void setUserPassword(String value) {
    state = state.copyWith(userPassword: value.nullIfEmpty);
  }

  void setUserPhone(String value) {
    state = state.copyWith(userPhone: value.nullIfEmpty);
  }

  void setUserBranch(String value) {
    state = state.copyWith(userBranch: value.nullIfEmpty);
  }

  void setUserCredit(int? value) {
    state = state.copyWith(userCredit: value);
  }

  void setStatus(UserStatus? value) {
    state = state.copyWith(status: value);
  }

  Future<void> submit(String userID) async {
    await ref.read(userStateProvider.notifier).update(
          userID,
          userName: state.userName,
          userPhone: state.userPhone,
          userBranch: state.userBranch,
          userCredit: state.userCredit,
          status: state.status,
        );

    final userPassword = state.userPassword;
    if (userPassword != null) {
      await ref.read(userStateProvider.notifier).resetPassword(
            userID: userID,
            userPassword: userPassword,
          );
    }
  }
}
