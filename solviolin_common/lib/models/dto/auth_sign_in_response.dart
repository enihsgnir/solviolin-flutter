// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'auth_sign_in_response.freezed.dart';
part 'auth_sign_in_response.g.dart';

@freezedResponseDto
class AuthSignInResponse with _$AuthSignInResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthSignInResponse({
    required String accessToken,
    required String refreshToken,
  }) = _AuthSignInResponse;

  factory AuthSignInResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSignInResponseFromJson(json);
}
