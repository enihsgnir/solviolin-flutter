import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/user/user.dart';

part 'create_user_dto.freezed.dart';
part 'create_user_dto.g.dart';

@freezed
class CreateUserDto with _$CreateUserDto {
  const factory CreateUserDto({
    required String userID,
    required String userPassword,
    required String userName,
    required String userPhone,
    required UserType userType,
    required String userBranch,
  }) = _CreateUserDto;

  factory CreateUserDto.fromJson(Map<String, dynamic> json) =>
      _$CreateUserDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
