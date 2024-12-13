import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/converters/color_converter.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/utils/freezed.dart';

part 'user_update_request.freezed.dart';
part 'user_update_request.g.dart';

@freezedRequestDto
class UserUpdateRequest with _$UserUpdateRequest {
  const factory UserUpdateRequest({
    String? userName,
    String? userPhone,
    int? userCredit,
    String? userBranch,
    UserStatus? status,
    @ColorConverter() Color? color,
  }) = _UserUpdateRequest;

  @override
  Map<String, dynamic> toJson();
}
