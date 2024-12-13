import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/extensions/null_if_empty_extension.dart';
import 'package:solviolin/models/form/user_search_form_data.dart';
import 'package:solviolin/models/payment_status.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/models/user_type.dart';

part 'user_search_form_provider.g.dart';

@riverpod
class UserSearchForm extends _$UserSearchForm {
  @override
  UserSearchFormData build() {
    return const UserSearchFormData(
      userType: UserType.student,
      status: UserStatus.registered,
      isPaid: PaymentStatus.isPaid,
    );
  }

  void setBranchName(String value) {
    state = state.copyWith(branchName: value);
  }

  void setUserType(UserType value) {
    state = state.copyWith(userType: value);
  }

  void setUserID(String value) {
    state = state.copyWith(userID: value.nullIfEmpty);
  }

  void setTermID(int? value) {
    state = state.copyWith(termID: value);
  }

  void setStatus(UserStatus value) {
    state = state.copyWith(status: value);
  }

  void setIsPaid(PaymentStatus? value) {
    state = state.copyWith(isPaid: value);
  }
}
