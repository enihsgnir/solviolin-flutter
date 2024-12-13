import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/payment_status.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/models/user_type.dart';

part 'user_search_form_data.freezed.dart';

@freezed
class UserSearchFormData with _$UserSearchFormData {
  const factory UserSearchFormData({
    @Default("") String branchName,
    required UserType userType,
    String? userID,
    int? termID,
    required UserStatus status,
    PaymentStatus? isPaid,
  }) = _UserSearchFormData;

  const UserSearchFormData._();

  bool get enabled => branchName.isNotEmpty;
}
