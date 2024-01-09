import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/ledger/ledger.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserType {
  @JsonValue(0)
  student,

  @JsonValue(1)
  teacher,

  @JsonValue(2)
  admin,
}

enum UserStatus {
  @JsonValue(0)
  unregistered,

  @JsonValue(1)
  registered,
}

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
    @LocalDateTimeConverter() required List<DateTime> paidAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
