import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/ledger_info.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/models/user_type.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String userID,
    required String userName,
    required String userPhone,
    required UserType userType,
    required String branchName,
    required int userCredit,
    required UserStatus status,
    required List<LedgerInfo> ledgers,
  }) = _User;

  const User._();

  DateTime? get paidAt => ledgers.firstOrNull?.paidAt;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
