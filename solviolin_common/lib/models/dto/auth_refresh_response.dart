// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'auth_refresh_response.freezed.dart';
part 'auth_refresh_response.g.dart';

@freezedResponseDto
class AuthRefreshResponse with _$AuthRefreshResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthRefreshResponse({
    required String accessToken,
  }) = _AuthRefreshResponse;

  factory AuthRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthRefreshResponseFromJson(json);
}
