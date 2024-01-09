import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/teacher/teacher_info.dart';
import 'package:solviolin/domains/user/user.dart';

part 'update_user_dto.freezed.dart';
part 'update_user_dto.g.dart';

@freezed
class UpdateUserDto with _$UpdateUserDto {
  const factory UpdateUserDto({
    String? userName,
    String? userPhone,
    String? userBranch,
    int? userCredit,
    UserStatus? status,
    @ColorConverter() Color? color,
  }) = _UpdateUserDto;

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
